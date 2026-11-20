import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/spell_model.dart';
import '../services/notification_service.dart';

class FavoriteSpellsView extends StatefulWidget {
  const FavoriteSpellsView({super.key});

  @override
  State<FavoriteSpellsView> createState() => _FavoriteSpellsViewState();
}

class _FavoriteSpellsViewState extends State<FavoriteSpellsView> {
  late Box _favoriteBox;

  @override
  void initState() {
    super.initState();
    _favoriteBox = Hive.box('favorite_spells');
  }

  void _deleteFavorite(String key, Spell spell) async {
    // 1. Hapus dari penyimpanan Hive
    await _favoriteBox.delete(key);

    // 2. Munculkan Immediate Notification
    await NotificationService.showDeleteNotification(
      spellName: spell.spell,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Favorite Spell',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: _favoriteBox.listenable(),
        builder: (context, Box box, _) {
          if (box.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada spell favorit',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          final keys = box.keys.toList();

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: keys.length,
            itemBuilder: (context, index) {
              final key = keys[index];
              final spellMap = box.get(key);
              if (spellMap == null) return const SizedBox.shrink();

              final spell = Spell.fromMap(spellMap);

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  leading: const Icon(
                    Icons.menu_book, // Ikon buku sesuai tangkapan layar di Halaman 3
                    color: Colors.black87,
                    size: 22,
                  ),
                  title: Text(
                    spell.spell,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  subtitle: Text(
                    spell.use,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: 20,
                    ),
                    onPressed: () => _deleteFavorite(key.toString(), spell),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}