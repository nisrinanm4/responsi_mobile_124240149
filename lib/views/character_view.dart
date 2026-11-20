import 'package:flutter/material.dart';
import 'package:harry_potter_app/views/profile_page.dart';
import '../models/character_model.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../utils/top_snackbar.dart';
import 'character_detail_view.dart';
import 'login_view.dart';
import 'spells_view.dart';


class CharacterView extends StatefulWidget {
  const CharacterView({super.key});

  @override
  State<CharacterView> createState() => _CharacterViewState();
}

class _CharacterViewState extends State<CharacterView> {
  late Future<List<Character>> _charactersFuture;

  @override
  void initState() {
    super.initState();
    _charactersFuture = ApiService.getCharacters();
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
        title: const Text('Harry Potter Character Gallery'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Profile',
            onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfilePage(username: 'widget.username',)),
                );
              },
          ),
        ],
      ),
      body: FutureBuilder<List<Character>>(
        future: _charactersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final characters = snapshot.data ?? [];
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            itemCount: characters.length,
            itemBuilder: (context, index) {
              final character = characters[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: Image.network(
                      character.cover,
                      width: 40,
                      height: 56,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 40,
                        height: 56,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.person, color: Colors.grey),
                      ),
                    ),
                  ),
                  title: Text(character.originalTitle),
                  subtitle: Text(character.releaseDate),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CharacterDetailView(character: character),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
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
                  MaterialPageRoute(builder: (_) => const SpellsView()),
                );
              },
              child: const Text('Spells'),
            ),
          ),
        ),
      ),
    );
  }
}