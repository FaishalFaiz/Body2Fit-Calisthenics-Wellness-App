import 'package:flutter/material.dart';

import 'core/app_router.dart';
import 'core/app_state.dart';
import 'theme/app_colors.dart';
import 'theme/app_theme.dart';

class Body2FitApp extends StatelessWidget {
  const Body2FitApp({super.key, required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    return AppScope(
      state: state,
      child: MaterialApp(
        title: 'Body2Fit',
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        darkTheme: buildAppTheme(),
        themeMode: ThemeMode.dark,
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRouter.onGenerateRoute,
        builder: (BuildContext context, Widget? child) => AppFrame(child: child),
      ),
    );
  }
}

/// Membatasi lebar aplikasi saat dijalankan di desktop/web agar proporsi
/// tetap seperti perangkat mobile pada referensi desain.
class AppFrame extends StatelessWidget {
  const AppFrame({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final Widget content = child ?? const SizedBox.shrink();
        if (constraints.maxWidth <= 520) return content;

        return ColoredBox(
          color: const Color(0xFF07090C),
          child: Center(
            child: Container(
              width: 440,
              height: constraints.maxHeight,
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(
                border: Border.symmetric(
                  vertical: BorderSide(color: AppColors.border),
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Color(0x66000000),
                    blurRadius: 40,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: content,
            ),
          ),
        );
      },
    );
  }
}
