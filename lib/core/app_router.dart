import 'package:flutter/material.dart';

import '../screens/auth_screen.dart';
import '../screens/exercise_detail_screen.dart';
import '../screens/main_shell.dart';
import '../screens/onboarding_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/workout_session_screen.dart';

abstract final class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String auth = '/auth';
  static const String home = '/home';

  // Fase 2 — layar latihan.
  static const String exerciseDetail = '/exercise-detail';
  static const String workout = '/workout';
}

abstract final class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return _page(const SplashScreen(), settings);
      case AppRoutes.onboarding:
        return _page(const OnboardingScreen(), settings);
      case AppRoutes.auth:
        return _page(const AuthScreen(), settings);
      case AppRoutes.home:
        return _page(const MainShell(), settings);
      case AppRoutes.exerciseDetail:
        return _page(
          ExerciseDetailScreen(exerciseCode: _codeArgument(settings.arguments)),
          settings,
        );
      case AppRoutes.workout:
        return _page(
          WorkoutSessionScreen(exerciseCode: _codeArgument(settings.arguments)),
          settings,
        );
      default:
        return _page(const SplashScreen(), settings);
    }
  }

  static String _codeArgument(Object? arguments) {
    return arguments is String ? arguments : '';
  }

  static MaterialPageRoute<void> _page(Widget child, RouteSettings settings) {
    return MaterialPageRoute<void>(
      builder: (_) => child,
      settings: settings,
    );
  }
}
