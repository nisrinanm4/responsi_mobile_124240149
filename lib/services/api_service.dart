import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/character_model.dart';
import '../models/spell_model.dart';

class ApiService {
  static const String _baseUrl =
      'https://potterapi-fedeperin.vercel.app/en';

  // Ambil daftar karakter
  static Future<List<Character>> getCharacters() async {
    final response = await http.get(Uri.parse('$_baseUrl/books'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Character.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat data karakter');
    }
  }

  // Ambil daftar mantra
  static Future<List<Spell>> getSpells() async {
    final response = await http.get(Uri.parse('$_baseUrl/spells'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Spell.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat data mantra');
    }
  }
}
