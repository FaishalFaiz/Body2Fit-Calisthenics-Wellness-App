import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../data/exercise_repository.dart';
import '../data/mock_data.dart';
import '../models/exercise.dart';
import '../utils/exercise_meta.dart';

enum MuscleGroup { semua, push, pull, core, legs }

extension MuscleGroupX on MuscleGroup {
  String get label => switch (this) {
        MuscleGroup.semua => 'Semua',
        MuscleGroup.push => 'Push (Dada/Bahu)',
        MuscleGroup.pull => 'Pull (Punggung)',
        MuscleGroup.core => 'Core & Abs',
        MuscleGroup.legs => 'Kaki',
      };

  bool matches(Exercise exercise) {
    if (this == MuscleGroup.semua) return true;

    final Set<String> codes = switch (this) {
      MuscleGroup.push => const {'CHEST', 'SHOULDERS', 'TRICEPS'},
      MuscleGroup.pull => const {'BACK', 'BICEPS', 'FOREARMS', 'TRAPS', 'LATS'},
      MuscleGroup.core => const {'ABDOMINALS', 'OBLIQUES', 'LOWER_BACK'},
      MuscleGroup.legs => const {
          'QUADRICEPS',
          'HAMSTRINGS',
          'GLUTES',
          'CALVES',
          'ADDUCTORS',
          'ABDUCTORS',
        },
      MuscleGroup.semua => const {},
    };

    return exercise.primaryMuscles.any(
      (tag) => codes.contains(tag.code.toUpperCase()),
    );
  }
}

/// State global aplikasi: data latihan, bookmark, profil, dan pengaturan.
class AppState extends ChangeNotifier {
  AppState({ExerciseRepository? repository})
      : _repository = repository ?? ExerciseRepository();

  final ExerciseRepository _repository;

  List<Exercise> _exercises = const <Exercise>[];
  bool _isLoading = true;
  String? _errorMessage;
  final Set<String> _bookmarkedIds = <String>{};
  final List<WorkoutHistoryItem> _history = List<WorkoutHistoryItem>.of(kMockHistory);

  UserProfile _user = kMockUser;
  bool _remindersEnabled = true;

  List<Exercise> get exercises => _exercises;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  UserProfile get user => _user;
  ActivityStats get stats => kMockStats;
  List<WeeklyDay> get week => kMockWeek;
  List<WorkoutHistoryItem> get history => List.unmodifiable(_history);
  bool get remindersEnabled => _remindersEnabled;

  /// Total sesi kumulatif: angka dummy ditambah sesi yang diselesaikan di
  /// perangkat ini sehingga rapor ikut bertambah setelah workout.
  int get totalSessions =>
      kMockStats.totalSessions + math.max(0, _history.length - kMockHistory.length);

  int get totalReps {
    int extra = 0;
    for (int i = 0; i < _history.length - kMockHistory.length; i++) {
      final WorkoutHistoryItem item = _history[i];
      final Exercise? exercise = byCode(item.exerciseCode);
      final bool hold =
          exercise == null ? false : ExerciseMeta.forExercise(exercise).isHold;
      if (!hold) extra += item.reps;
    }
    return kMockStats.totalReps + extra;
  }

  double get totalHours {
    int extraMinutes = 0;
    for (int i = 0; i < _history.length - kMockHistory.length; i++) {
      extraMinutes += _history[i].minutes;
    }
    return kMockStats.totalHours + extraMinutes / 60;
  }

  Future<void> load() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _exercises = await _repository.load();
    } catch (_) {
      _errorMessage = 'Data latihan gagal dimuat. Coba muat ulang aplikasi.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Exercise? byCode(String code) {
    for (final Exercise exercise in _exercises) {
      if (exercise.code.toUpperCase() == code.toUpperCase()) return exercise;
    }
    return null;
  }

  Exercise? byId(String id) {
    for (final Exercise exercise in _exercises) {
      if (exercise.id == id) return exercise;
    }
    return null;
  }

  /// Tiga gerakan yang ditonjolkan di dashboard: prioritaskan bodyweight.
  List<Exercise> get featuredExercises {
    const List<String> preferred = <String>['PUSH_UPS', 'PLANK', 'CLOSE_GRIP_PUSH_UPS'];
    final List<Exercise> sorted = List<Exercise>.of(_exercises);
    sorted.sort((a, b) {
      int rank(Exercise exercise) {
        final int index = preferred.indexOf(exercise.code.toUpperCase());
        if (index >= 0) return index;
        return exercise.isBodyweight ? preferred.length : preferred.length + 1;
      }

      return rank(a).compareTo(rank(b));
    });
    return List<Exercise>.unmodifiable(sorted.take(3));
  }

  List<Exercise> filter({MuscleGroup group = MuscleGroup.semua, String query = ''}) {
    return List<Exercise>.unmodifiable(
      _exercises.where(
        (exercise) => group.matches(exercise) && exercise.matchesQuery(query),
      ),
    );
  }

  bool isBookmarked(String exerciseId) => _bookmarkedIds.contains(exerciseId);

  void toggleBookmark(String exerciseId) {
    if (!_bookmarkedIds.add(exerciseId)) {
      _bookmarkedIds.remove(exerciseId);
    }
    notifyListeners();
  }

  void addHistory(WorkoutHistoryItem item) {
    _history.insert(0, item);
    notifyListeners();
  }

  void setRemindersEnabled(bool value) {
    if (_remindersEnabled == value) return;
    _remindersEnabled = value;
    notifyListeners();
  }

  void updateProfile(UserProfile profile) {
    _user = profile;
    notifyListeners();
  }
}

/// Menyediakan [AppState] ke seluruh widget tree.
class AppScope extends InheritedNotifier<AppState> {
  const AppScope({
    super.key,
    required AppState state,
    required super.child,
  }) : super(notifier: state);

  static AppState of(BuildContext context) {
    final AppScope? scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope?.notifier != null, 'AppScope tidak ditemukan pada widget tree.');
    return scope!.notifier!;
  }
}
