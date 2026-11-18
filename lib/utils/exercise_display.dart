import '../models/exercise.dart';

/// Label Bahasa Indonesia untuk tag otot, tipe gerakan, dan kategori alat.
/// Kode asli tetap dipakai untuk filter; hanya tampilan yang diterjemahkan.
const Map<String, String> _muscleLabels = <String, String>{
  'CHEST': 'Dada (Pectoralis)',
  'SHOULDERS': 'Bahu Depan (Deltoid)',
  'TRICEPS': 'Trisep',
  'BACK': 'Punggung',
  'LATS': 'Latissimus Dorsi',
  'TRAPS': 'Trapezius',
  'TRAPEZIUS': 'Trapezius',
  'BICEPS': 'Bisep',
  'FOREARMS': 'Lengan Bawah',
  'ABS': 'Otot Perut (Core)',
  'ABDOMINALS': 'Otot Perut (Core)',
  'OBLIQUES': 'Otot Samping',
  'LOWER_BACK': 'Punggung Bawah',
  'QUADRICEPS': 'Paha Depan (Quadriceps)',
  'HAMSTRINGS': 'Paha Belakang (Hamstrings)',
  'GLUTES': 'Bokong (Glutes)',
  'CALVES': 'Betis',
  'ADDUCTORS': 'Adduktor',
  'ABDUCTORS': 'Abduktor',
};

const Map<String, String> _typeLabels = <String, String>{
  'ISOLATION': 'Isolasi',
  'POLYARTICULAR': 'Multi Sendi',
};

const Map<String, String> _categoryLabels = <String, String>{
  'BODY_WEIGHT': 'Berat Tubuh',
  'FREE_WEIGHT': 'Beban Bebas',
  'MACHINE': 'Mesin',
  'CABLE': 'Kabel',
  'DUMBBELL': 'Dumbbell',
  'BARBELL': 'Barbel',
};

String muscleLabel(ExerciseTag tag) =>
    _muscleLabels[tag.code.toUpperCase()] ?? tag.name;

String exerciseTypeLabel(ExerciseTag tag) =>
    _typeLabels[tag.code.toUpperCase()] ?? tag.name;

String exerciseCategoryLabel(ExerciseTag tag) =>
    _categoryLabels[tag.code.toUpperCase()] ?? tag.name;

/// Label pendek untuk chip ringkasan, mis. `Dada · Trisep`.
String joinTags(Iterable<ExerciseTag> tags, String Function(ExerciseTag) label) {
  return tags.map(label).where((String value) => value.isNotEmpty).join(' · ');
}
