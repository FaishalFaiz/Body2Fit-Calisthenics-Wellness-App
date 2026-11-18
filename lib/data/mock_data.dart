/// Data dummy untuk profil, ringkasan aktivitas, dan riwayat latihan.
library;

class UserProfile {
  const UserProfile({
    required this.name,
    required this.username,
    required this.tier,
    required this.levelLabel,
    required this.focus,
    required this.quote,
    required this.weightKg,
    required this.heightCm,
    required this.bodyFatPercent,
    required this.bmi,
    required this.initials,
  });

  final String name;
  final String username;
  final String tier;
  final String levelLabel;
  final String focus;
  final String quote;
  final double weightKg;
  final double heightCm;
  final double bodyFatPercent;
  final double bmi;
  final String initials;

  /// Salinan profil dengan sebagian data diperbarui, termasuk inisial yang
  /// dihitung ulang dari nama agar avatar tetap konsisten.
  UserProfile copyWith({
    String? name,
    String? username,
    String? tier,
    String? levelLabel,
    String? focus,
    String? quote,
    double? weightKg,
    double? heightCm,
    double? bodyFatPercent,
    double? bmi,
  }) {
    final String nextName = name ?? this.name;
    return UserProfile(
      name: nextName,
      username: username ?? this.username,
      tier: tier ?? this.tier,
      levelLabel: levelLabel ?? this.levelLabel,
      focus: focus ?? this.focus,
      quote: quote ?? this.quote,
      weightKg: weightKg ?? this.weightKg,
      heightCm: heightCm ?? this.heightCm,
      bodyFatPercent: bodyFatPercent ?? this.bodyFatPercent,
      bmi: bmi ?? this.bmi,
      initials: initialsFrom(nextName),
    );
  }

  static String initialsFrom(String value) {
    final List<String> parts = value
        .trim()
        .split(RegExp(r'\s+'))
        .where((String part) => part.isNotEmpty)
        .toList(growable: false);
    if (parts.isEmpty) return 'B2';
    if (parts.length == 1) {
      final String single = parts.first;
      return single.substring(0, single.length >= 2 ? 2 : 1).toUpperCase();
    }
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  String get weightLabel => weightKg.toStringAsFixed(1);
  String get heightLabel => heightCm.toStringAsFixed(0);
  String get bodyFatLabel => bodyFatPercent.toStringAsFixed(1);
  String get bmiLabel => bmi.toStringAsFixed(1);

  /// Umur akun / pengalaman sebagai label pendek pada kartu profil.
  String get handle => '$username · $levelLabel';
}

const UserProfile kMockUser = UserProfile(
  name: 'Arya Pratama',
  username: '@arya_calisthenics',
  tier: 'PRO',
  levelLabel: 'Level 4 Intermediate',
  focus: 'Handstand & Hypertrophy',
  quote: 'Master Your Bodyweight, Transform Your Health.',
  weightKg: 68.5,
  heightCm: 175,
  bodyFatPercent: 14.2,
  bmi: 22.4,
  initials: 'AP',
);

class ActivityStats {
  const ActivityStats({
    required this.totalSessions,
    required this.totalHours,
    required this.totalReps,
    required this.streakDays,
    required this.achievedDays,
    required this.targetDays,
    required this.readinessPercent,
    required this.caloriesBurned,
    required this.calorieTarget,
    required this.activeMinutes,
    required this.minuteTarget,
  });

  final int totalSessions;
  final double totalHours;
  final int totalReps;
  final int streakDays;
  final int achievedDays;
  final int targetDays;
  final int readinessPercent;

  /// Metrik harian pada dashboard.
  final int caloriesBurned;
  final int calorieTarget;
  final int activeMinutes;
  final int minuteTarget;

  double get calorieProgress =>
      calorieTarget == 0 ? 0 : (caloriesBurned / calorieTarget).clamp(0, 1);
  double get minuteProgress =>
      minuteTarget == 0 ? 0 : (activeMinutes / minuteTarget).clamp(0, 1);
  int get consistencyPercent =>
      targetDays == 0 ? 0 : ((achievedDays / targetDays) * 100).round();

  String get totalHoursLabel => totalHours.toStringAsFixed(1);
}

const ActivityStats kMockStats = ActivityStats(
  totalSessions: 22,
  totalHours: 14.2,
  totalReps: 1480,
  streakDays: 5,
  achievedDays: 5,
  targetDays: 6,
  readinessPercent: 94,
  caloriesBurned: 485,
  calorieTarget: 600,
  activeMinutes: 38,
  minuteTarget: 45,
);

enum DayStatus { done, today, planned, rest }

class WeeklyDay {
  const WeeklyDay({required this.label, required this.minutes, required this.status});

  final String label;
  final int? minutes;
  final DayStatus status;
}

const List<WeeklyDay> kMockWeek = <WeeklyDay>[
  WeeklyDay(label: 'SEN', minutes: 30, status: DayStatus.done),
  WeeklyDay(label: 'SEL', minutes: 45, status: DayStatus.done),
  WeeklyDay(label: 'RAB', minutes: 40, status: DayStatus.done),
  WeeklyDay(label: 'KAM', minutes: 25, status: DayStatus.done),
  WeeklyDay(label: 'JUM', minutes: 38, status: DayStatus.today),
  WeeklyDay(label: 'SAB', minutes: null, status: DayStatus.planned),
  WeeklyDay(label: 'MIN', minutes: null, status: DayStatus.rest),
];

class WorkoutHistoryItem {
  const WorkoutHistoryItem({
    required this.exerciseCode,
    required this.dateLabel,
    required this.sets,
    required this.reps,
    required this.minutes,
    required this.calories,
    required this.formScore,
  });

  final String exerciseCode;
  final String dateLabel;
  final int sets;
  final int reps;
  final int minutes;
  final int calories;
  final int formScore;
}

const List<WorkoutHistoryItem> kMockHistory = <WorkoutHistoryItem>[
  WorkoutHistoryItem(
    exerciseCode: 'PUSH_UPS',
    dateLabel: 'Hari ini, 08.30',
    sets: 3,
    reps: 12,
    minutes: 38,
    calories: 140,
    formScore: 100,
  ),
  WorkoutHistoryItem(
    exerciseCode: 'PLANK',
    dateLabel: 'Kemarin, 16.45',
    sets: 4,
    reps: 45,
    minutes: 25,
    calories: 95,
    formScore: 96,
  ),
];
