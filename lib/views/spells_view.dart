import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/spell_model.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../utils/top_snackbar.dart';
import 'character_view.dart';
import 'favorite_spells_view.dart';
import 'login_view.dart';

class SpellsView extends StatefulWidget {
  const SpellsView({super.key});

  @override
  State<SpellsView> createState() => _SpellsViewState();
}

class _SpellsViewState extends State<SpellsView> {
  late Future<List<Spell>> _spellsFuture;
  late Box _favoriteBox;

  @override
  void initState() {
    super.initState();
    _spellsFuture = ApiService.getSpells();
    _favoriteBox = Hive.box('favorite_spells');
  }

  void _toggleFavorite(Spell spell) async {
    final key = spell.index.toString();
    final isFav = _favoriteBox.containsKey(key);

    if (isFav) {
      await _favoriteBox.delete(key);
      if (mounted) {
        TopSnackBar.showError(
          context,
          'Remove!',
          '${spell.spell} removed from fav list!',
        );
      }
    } else {
      await _favoriteBox.put(key, spell.toMap());
      if (mounted) {
        TopSnackBar.showSuccess(
          context,
          'Add!',
          '${spell.spell} successfully added to fav list!',
        );
      }
    }
    setState(() {});
  }

  void _logout() async {
    await AuthService.logout();
    if (mounted) {
      TopSnackBar.showSuccess(
        context,
        'Success!',
        'Logged out Successfully',
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginView()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Harry Potter Spells Gallery'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),
      body: FutureBuilder<List<Spell>>(
        future: _spellsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final spells = snapshot.data ?? [];
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
            itemCount: spells.length,
            itemBuilder: (context, index) {
              final spell = spells[index];
              final isFav = _favoriteBox.containsKey(spell.index.toString());

              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  leading: const Icon(Icons.book, color: Colors.black87),
                  title: Text(spell.spell),
                  subtitle: Text(spell.use),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.favorite,
                      color: isFav ? Colors.red : Colors.grey.shade800,
                    ),
                    onPressed: () => _toggleFavorite(spell),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FavoriteSpellsView()),
          ).then((_) => setState(() {}));
        },
        child: const Icon(Icons.favorite, color: Colors.red),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton.tonal(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const CharacterView()),
                );
              },
              child: const Text('Characters'),
            ),
          ),
        ),
      ),
    );
  }
}