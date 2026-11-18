import '../models/exercise.dart';

enum ExerciseDifficulty { pemula, menengah, lanjut }

extension ExerciseDifficultyX on ExerciseDifficulty {
  String get label => switch (this) {
        ExerciseDifficulty.pemula => 'Pemula',
        ExerciseDifficulty.menengah => 'Menengah',
        ExerciseDifficulty.lanjut => 'Lanjut',
      };
}

/// Satu langkah eksekusi yang ditampilkan pada halaman detail.
class ExerciseStep {
  const ExerciseStep({required this.title, required this.body});

  final String title;
  final String body;
}

/// Metadata tampilan yang tidak tersedia di JSON sumber (level, set, reps,
/// istirahat, kalori, langkah gerakan). Diturunkan secara deterministik agar
/// setiap kartu punya angka yang konsisten dan bervariasi.
class ExerciseMeta {
  const ExerciseMeta({
    required this.difficulty,
    required this.sets,
    required this.reps,
    required this.holdSeconds,
    required this.restSeconds,
    required this.calories,
    required this.minutes,
    required this.steps,
  });

  final ExerciseDifficulty difficulty;
  final int sets;
  final int reps;
  final int holdSeconds;
  final int restSeconds;
  final int calories;
  final int minutes;
  final List<ExerciseStep> steps;

  bool get isHold => holdSeconds > 0;

  /// Contoh: `3 Set × 12 Reps` atau `3 Set × 30s`.
  String get volumeLabel => isHold
      ? '$sets Set × ${holdSeconds}s'
      : '$sets Set × $reps Reps';

  /// Versi ringkas untuk kartu: `3 Set × 12`.
  String get volumeShort => isHold
      ? '$sets Set × ${holdSeconds}s'
      : '$sets Set × $reps';

  /// Target repetisi pada kartu metrik detail.
  String get targetLabel => isHold ? '$sets Set × ${holdSeconds}s' : '$sets × $reps';

  static ExerciseMeta forExercise(Exercise exercise) {
    final int seed = _stableSeed(exercise.code);
    final bool machine = exercise.categories
        .any((tag) => tag.code.toUpperCase() == 'MACHINE' || tag.code.toUpperCase() == 'CABLE');
    final bool bodyweight = exercise.isBodyweight;
    final bool polyarticular = exercise.isPolyarticular;
    final String code = exercise.code.toUpperCase();

    final ExerciseDifficulty difficulty;
    if (bodyweight) {
      difficulty = code == 'CLOSE_GRIP_PUSH_UPS'
          ? ExerciseDifficulty.menengah
          : ExerciseDifficulty.pemula;
    } else if (machine) {
      difficulty = ExerciseDifficulty.menengah;
    } else if (polyarticular) {
      difficulty = ExerciseDifficulty.lanjut;
    } else {
      difficulty = ExerciseDifficulty.menengah;
    }

    final int sets = exercise.isHold ? 3 : (polyarticular ? 4 : 3);

    final int reps;
    if (code == 'LEG_PRESS_CALF_RAISES' || code == 'BACK_EXTENSIONS') {
      reps = 15;
    } else if (polyarticular) {
      reps = 10;
    } else {
      reps = 12;
    }

    final int holdSeconds = exercise.isHold ? 30 : 0;

    int restSeconds;
    if (exercise.isHold) {
      restSeconds = 30;
    } else if (polyarticular) {
      restSeconds = 60;
    } else {
      restSeconds = 45;
    }

    final int calories = 60 + seed % 35;
    final int minutes = 5 + seed % 5;

    return ExerciseMeta(
      difficulty: difficulty,
      sets: sets,
      reps: reps,
      holdSeconds: holdSeconds,
      restSeconds: restSeconds,
      calories: calories,
      minutes: minutes,
      steps: _stepsFromDescription(exercise.description),
    );
  }

  static int _stableSeed(String value) {
    int hash = 0;
    for (final int unit in value.codeUnits) {
      hash = (hash + (unit * 31)) % 997;
    }
    return hash;
  }

  static List<ExerciseStep> _stepsFromDescription(String description) {
    final List<String> sentences = description
        .split(RegExp(r'(?<=[.!?])\s+'))
        .map((sentence) => sentence.trim())
        .where((sentence) => sentence.length > 24)
        .toList(growable: false);

    if (sentences.isEmpty) {
      return <ExerciseStep>[
        ExerciseStep(
          title: 'Panduan Gerakan',
          body: description.isEmpty ? 'Ikuti gerakan dengan kontrol dan napas teratur.' : description,
        ),
      ];
    }

    final List<String> selected =
        sentences.length > 5 ? sentences.sublist(0, 5) : sentences;
    const List<String> middleTitles = <String>[
      'Fase Eksekusi',
      'Fase Kembali',
      'Kontrol Gerakan',
    ];

    final List<ExerciseStep> steps = <ExerciseStep>[];
    for (int i = 0; i < selected.length; i++) {
      final String body = selected[i];
      final bool isFirst = i == 0;
      final bool isLast = i == selected.length - 1;

      final String title;
      if (isFirst) {
        title = 'Posisi Awal';
      } else if (isLast) {
        final String lower = body.toLowerCase();
        final bool isCue = lower.contains('hindari') ||
            lower.contains('jaga') ||
            lower.contains('pastikan') ||
            lower.contains('aman') ||
            lower.contains('kontrol');
        title = isCue ? 'Catatan Form' : 'Penyelesaian';
      } else {
        title = middleTitles[(i - 1) % middleTitles.length];
      }

      steps.add(ExerciseStep(title: title, body: body));
    }
    return List<ExerciseStep>.unmodifiable(steps);
  }
}
