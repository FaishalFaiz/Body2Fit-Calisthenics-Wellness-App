import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/exercise.dart';
import 'exercise_localizations.dart';

/// Memuat data latihan dari aset lokal. Tanpa jaringan, tanpa API key.
class ExerciseRepository {
  static const String assetPath = 'assets/data/exercises.json';

  List<Exercise>? _cache;

  Future<List<Exercise>> load({bool forceReload = false}) async {
    if (!forceReload && _cache != null) return _cache!;

    final String raw = await rootBundle.loadString(assetPath);
    final dynamic decoded = jsonDecode(raw);
    if (decoded is! List) {
      throw const FormatException('Struktur data latihan tidak valid.');
    }

    final List<Exercise> result = <Exercise>[];
    for (final dynamic item in decoded) {
      if (item is! Map) continue;
      final Map<String, dynamic> json = Map<String, dynamic>.from(item);
      final String code = json['code'] is String ? json['code'] as String : '';
      final ExerciseLocalization? localization = kExerciseLocalizationsId[code];

      final Exercise exercise = Exercise.fromJson(
        json,
        nameOverride: localization?.name,
        descriptionOverride: localization?.description,
      );

      if (exercise.id.isEmpty) continue;
      result.add(exercise);
    }

    _cache = List<Exercise>.unmodifiable(result);
    return _cache!;
  }
}
