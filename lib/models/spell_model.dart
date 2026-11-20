class Spell {
  final String spell;
  final String use;
  final int index;

  Spell({
    required this.spell,
    required this.use,
    required this.index,
  });

  factory Spell.fromJson(Map<String, dynamic> json) {
    return Spell(
      spell: json['spell'] ?? '',
      use: json['use'] ?? '',
      index: json['index'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'spell': spell,
      'use': use,
      'index': index,
    };
  }

  factory Spell.fromMap(Map<dynamic, dynamic> map) {
    return Spell(
      spell: map['spell'] ?? '',
      use: map['use'] ?? '',
      index: map['index'] ?? 0,
    );
  }
}