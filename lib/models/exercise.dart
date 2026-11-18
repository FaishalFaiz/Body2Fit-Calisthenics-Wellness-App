import 'package:flutter/material.dart';

/// Satu tag dari data latihan (otot, tipe gerakan, atau kategori alat).
@immutable
class ExerciseTag {
  const ExerciseTag({
    required this.id,
    required this.code,
    required this.name,
    this.color,
  });

  final String id;
  final String code;
  final String name;
  final Color? color;

  factory ExerciseTag.fromJson(Map<String, dynamic> json) {
    return ExerciseTag(
      id: _asString(json['id']),
      code: _asString(json['code']),
      name: _asString(json['name']),
      color: _parseColor(json['color']),
    );
  }

  static String _asString(dynamic value) => value is String ? value : '';

  static Color? _parseColor(dynamic value) {
    if (value is! String) return null;
    final String hex = value.replaceFirst('#', '').trim();
    if (hex.length != 6 && hex.length != 8) return null;
    final int? parsed = int.tryParse(hex, radix: 16);
    if (parsed == null) return null;
    return Color(hex.length == 6 ? 0xFF000000 | parsed : parsed);
  }
}

/// Model latihan lokal (lihat `assets/data/exercises.json`).
@immutable
class Exercise {
  const Exercise({
    required this.id,
    required this.code,
    required this.name,
    required this.description,
    this.primaryMuscles = const [],
    this.secondaryMuscles = const [],
    this.types = const [],
    this.categories = const [],
  });

  final String id;
  final String code;
  final String name;
  final String description;
  final List<ExerciseTag> primaryMuscles;
  final List<ExerciseTag> secondaryMuscles;
  final List<ExerciseTag> types;
  final List<ExerciseTag> categories;

  /// Gambar statis untuk kartu.
  String get cardImage => 'assets/exercises/images/${id}_basic_concentric.png';

  /// Animasi dasar untuk halaman detail.
  String get basicGif => 'assets/exercises/basic/$id.gif';

  /// Animasi dengan otot target di-highlight.
  String get musclesGif => 'assets/exercises/muscles/$id.gif';

  bool get isBodyweight =>
      categories.any((tag) => tag.name.toLowerCase() == 'body weight');

  bool get isPolyarticular =>
      types.any((tag) => tag.code.toUpperCase() == 'POLYARTICULAR');

  /// True untuk gerakan isometrik (mis. plank) yang dihitung per detik.
  bool get isHold => code.toUpperCase() == 'PLANK';

  String get categoryLabel =>
      categories.map((tag) => tag.name).where((name) => name.isNotEmpty).join(', ');

  String get typeLabel =>
      types.map((tag) => tag.name).where((name) => name.isNotEmpty).join(', ');

  /// Parse defensif: semua field boleh hilang.
  factory Exercise.fromJson(
    Map<String, dynamic> json, {
    String? nameOverride,
    String? descriptionOverride,
  }) {
    final String rawName = nameOverride ?? ExerciseTag._asString(json['name']);
    final String rawDescription =
        descriptionOverride ?? ExerciseTag._asString(json['description']);
    return Exercise(
      id: ExerciseTag._asString(json['id']),
      code: ExerciseTag._asString(json['code']),
      name: rawName.trim().isEmpty ? 'Latihan' : rawName.trim(),
      description: rawDescription.trim(),
      primaryMuscles: _tagList(json['primaryMuscles']),
      secondaryMuscles: _tagList(json['secondaryMuscles']),
      types: _tagList(json['types']),
      categories: _tagList(json['categories']),
    );
  }

  static List<ExerciseTag> _tagList(dynamic value) {
    if (value is! List) return const [];
    return value
        .whereType<Map>()
        .map((item) => ExerciseTag.fromJson(Map<String, dynamic>.from(item)))
        .where((tag) => tag.name.isNotEmpty)
        .toList(growable: false);
  }

  bool matchesQuery(String query) {
    final String q = query.trim().toLowerCase();
    if (q.isEmpty) return true;
    if (name.toLowerCase().contains(q)) return true;
    if (description.toLowerCase().contains(q)) return true;
    return primaryMuscles.any((tag) => tag.name.toLowerCase().contains(q)) ||
        secondaryMuscles.any((tag) => tag.name.toLowerCase().contains(q)) ||
        categories.any((tag) => tag.name.toLowerCase().contains(q));
  }
}
