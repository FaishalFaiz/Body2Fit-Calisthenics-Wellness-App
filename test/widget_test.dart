import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:body2fit_calisthenics_welness/core/app_router.dart';
import 'package:body2fit_calisthenics_welness/core/app_state.dart';
import 'package:body2fit_calisthenics_welness/data/exercise_repository.dart';
import 'package:body2fit_calisthenics_welness/data/mock_data.dart';
import 'package:body2fit_calisthenics_welness/screens/activity_screen.dart';
import 'package:body2fit_calisthenics_welness/screens/auth_screen.dart';
import 'package:body2fit_calisthenics_welness/screens/exercise_catalog_screen.dart';
import 'package:body2fit_calisthenics_welness/screens/exercise_detail_screen.dart';
import 'package:body2fit_calisthenics_welness/screens/main_shell.dart';
import 'package:body2fit_calisthenics_welness/screens/profile_screen.dart';
import 'package:body2fit_calisthenics_welness/screens/workout_session_screen.dart';
import 'package:body2fit_calisthenics_welness/theme/app_theme.dart';
import 'package:body2fit_calisthenics_welness/utils/exercise_meta.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppState loadedState;

  setUpAll(() async {
    loadedState = AppState(repository: ExerciseRepository());
    await loadedState.load();
  });

  test('repository memuat 15 latihan dengan terjemahan Indonesia', () async {
    final ExerciseRepository repository = ExerciseRepository();
    final exercises = await repository.load();

    expect(exercises, hasLength(15));
    expect(exercises.any((exercise) => exercise.name == 'Push-Up'), isTrue);
    expect(
      exercises.firstWhere((exercise) => exercise.code == 'PUSH_UPS').description,
      contains('posisi merangkak'),
    );
  });

  test('metadata turunan konsisten untuk setiap latihan', () async {
    final exercises = await ExerciseRepository().load();

    for (final exercise in exercises) {
      final ExerciseMeta meta = ExerciseMeta.forExercise(exercise);
      expect(meta.sets, greaterThan(0));
      expect(meta.restSeconds, greaterThan(0));
      expect(meta.calories, greaterThan(0));
      expect(meta.steps, isNotEmpty);
    }

    final ExerciseMeta plank =
        ExerciseMeta.forExercise(exercises.firstWhere((e) => e.code == 'PLANK'));
    expect(plank.isHold, isTrue);
    expect(plank.volumeLabel, '3 Set × 30s');
  });

  testWidgets('layar auth dapat beralih ke mode daftar', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(theme: buildAppTheme(), home: const AuthScreen()),
    );

    expect(find.text('Masuk ke Akun'), findsOneWidget);

    await tester.tap(find.text('Daftar (Sign Up)'));
    await tester.pumpAndSettle();

    expect(find.text('Buat Akun Baru'), findsOneWidget);
    expect(find.text('Nama Lengkap'), findsOneWidget);
  });

  testWidgets('dashboard tampil tanpa overflow pada layar ponsel', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final AppState state = loadedState;

    await tester.pumpWidget(
      AppScope(
        state: state,
        child: MaterialApp(theme: buildAppTheme(), home: const MainShell()),
      ),
    );
    await tester.pump();

    expect(find.text('Halo Atlet,'), findsOneWidget);
    expect(find.text('Mulai Workout'), findsOneWidget);
    expect(find.text('Push-Up'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('katalog mencari dan menyaring gerakan', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      AppScope(
        state: loadedState,
        child: MaterialApp(
          theme: buildAppTheme(),
          home: const Scaffold(body: ExerciseCatalogScreen()),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('15 Gerakan'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'grip sempit');
    await tester.pump();

    expect(find.text('1 Gerakan'), findsOneWidget);
    expect(find.text('Push-Up Grip Sempit'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('detail menampilkan otot, langkah, dan bookmark', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      AppScope(
        state: loadedState,
        child: MaterialApp(
          theme: buildAppTheme(),
          home: const ExerciseDetailScreen(exerciseCode: 'PUSH_UPS'),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Push-Up'), findsWidgets);
    expect(find.byIcon(Icons.bookmark_border_rounded), findsOneWidget);

    final Finder listView = find.byType(Scrollable).first;
    await tester.scrollUntilVisible(
      find.text('OTOT TARGET UTAMA'),
      240,
      scrollable: listView,
    );
    await tester.pumpAndSettle();
    expect(find.text('OTOT TARGET UTAMA'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('LANGKAH GERAKAN YANG BENAR'),
      240,
      scrollable: listView,
    );
    await tester.pumpAndSettle();
    expect(find.text('LANGKAH GERAKAN YANG BENAR'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.bookmark_border_rounded));
    await tester.pump();

    expect(find.byIcon(Icons.bookmark_rounded), findsOneWidget);
    expect(loadedState.isBookmarked('d3f20182-4c35-4822-947c-c25844a4ab96'), isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('sesi workout mencatat set, istirahat, dan riwayat', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final int historyBefore = loadedState.history.length;

    await tester.pumpWidget(
      AppScope(
        state: loadedState,
        child: MaterialApp(
          theme: buildAppTheme(),
          home: const WorkoutSessionScreen(exerciseCode: 'PUSH_UPS'),
        ),
      ),
    );
    await tester.pump(Duration.zero);

    expect(find.text('SESI LATIHAN'), findsOneWidget);
    expect(find.text('SET 1 / 4'), findsOneWidget);

    for (int set = 1; set <= 4; set++) {
      await tester.tap(find.text('Selesai Set'));
      await tester.pump(const Duration(milliseconds: 250));
      if (set < 4) {
        expect(find.text('ISTIRAHAT'), findsWidgets);
        await tester.tap(find.text('Lewati Istirahat'));
        await tester.pump(const Duration(milliseconds: 250));
        expect(find.text('SET ${set + 1} / 4'), findsOneWidget);
      }
    }

    await tester.pumpAndSettle();
    expect(find.text('Sesi Selesai!'), findsOneWidget);
    expect(loadedState.history.length, historyBefore + 1);

    await tester.tap(find.text('Selesai & Tutup'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });

  testWidgets('aktivitas menampilkan konsistensi dan riwayat baru', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final AppState state = AppState(repository: ExerciseRepository());
    await tester.runAsync(state.load);

    await tester.pumpWidget(
      AppScope(
        state: state,
        child: MaterialApp(
          theme: buildAppTheme(),
          home: const Scaffold(body: ActivityScreen()),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Progres Latihanmu'), findsOneWidget);
    expect(find.text('KONSISTENSI LATIHAN MINGGUAN'), findsOneWidget);
    expect(find.text('5 dari 6 hari target tercapai (83%)'), findsOneWidget);
    expect(find.text('Disiplin'), findsOneWidget);
    expect(find.text('RIWAYAT LATIHAN TERKINI'), findsOneWidget);
    expect(find.text('22'), findsOneWidget);
    expect(find.text('1.480'), findsOneWidget);
    expect(find.text('Push-Up'), findsOneWidget);
    expect(find.text('Plank'), findsOneWidget);
    expect(tester.takeException(), isNull);

    state.addHistory(
      const WorkoutHistoryItem(
        exerciseCode: 'CLOSE_GRIP_PUSH_UPS',
        dateLabel: 'Hari ini, 19.05',
        sets: 3,
        reps: 10,
        minutes: 20,
        calories: 55,
        formScore: 98,
      ),
    );
    await tester.pump();

    expect(find.text('23'), findsOneWidget);
    expect(find.text('1.490'), findsOneWidget);
    expect(find.text('Push-Up Grip Sempit'), findsOneWidget);
    expect(find.text('-55 kkal'), findsOneWidget);
    expect(find.text('98% Form'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('profil memperbarui pengingat dan dapat keluar', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final AppState state = AppState(repository: ExerciseRepository());
    await tester.runAsync(state.load);

    await tester.pumpWidget(
      AppScope(
        state: state,
        child: MaterialApp(
          theme: buildAppTheme(),
          home: const Scaffold(body: ProfileScreen()),
          onGenerateRoute: AppRouter.onGenerateRoute,
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Arya Pratama'), findsOneWidget);
    expect(find.text('PRO'), findsOneWidget);
    expect(find.text('Body Fat Est.'), findsOneWidget);
    expect(find.text('Pengingat Latihan Harian'), findsOneWidget);
    expect(find.text('Keamanan & Sandi Akun'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byType(Switch).first);
    await tester.pump();
    expect(state.remindersEnabled, isFalse);
    expect(find.text('Nonaktif'), findsOneWidget);

    await tester.tap(find.byType(Switch).first);
    await tester.pump();
    expect(state.remindersEnabled, isTrue);

    await tester.tap(find.text('Keluar'));
    await tester.pumpAndSettle();
    expect(find.text('Keluar dari akun?'), findsOneWidget);

    await tester.tap(find.text('Keluar').last);
    await tester.pumpAndSettle();

    expect(find.byType(AuthScreen), findsOneWidget);
    expect(find.text('Masuk ke Akun'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('sheet edit profil menyimpan nama baru', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final AppState state = AppState(repository: ExerciseRepository());
    await tester.runAsync(state.load);

    await tester.pumpWidget(
      AppScope(
        state: state,
        child: MaterialApp(
          theme: buildAppTheme(),
          home: const Scaffold(body: ProfileScreen()),
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.byIcon(Icons.edit_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Edit Profil Atlet'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Arya Pratama'),
      'Arya Pradana',
    );
    await tester.tap(find.text('Simpan Perubahan'));
    await tester.pumpAndSettle();

    expect(state.user.name, 'Arya Pradana');
    expect(state.user.initials, 'AP');
    expect(find.text('Arya Pradana'), findsOneWidget);
    expect(find.text('Profil berhasil diperbarui.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('tab aktivitas dan profil terbuka dari navigasi bawah', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      AppScope(
        state: loadedState,
        child: MaterialApp(theme: buildAppTheme(), home: const MainShell()),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Aktivitas'));
    await tester.pumpAndSettle();
    expect(find.text('Progres Latihanmu'), findsOneWidget);

    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();
    expect(find.text('Akunmu'), findsOneWidget);

    await tester.tap(find.text('Beranda'));
    await tester.pumpAndSettle();
    expect(find.text('Halo Atlet,'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('semua tab tetap rapi pada layar 360px', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(360, 780));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      AppScope(
        state: loadedState,
        child: MaterialApp(theme: buildAppTheme(), home: const MainShell()),
      ),
    );
    await tester.pump();

    for (final String tab in <String>['Latihan', 'Aktivitas', 'Profil', 'Beranda']) {
      await tester.tap(find.text(tab));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'tab $tab overflow');
    }
  });
}
