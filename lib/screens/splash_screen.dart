import 'dart:async';

import 'package:flutter/material.dart';

import '../core/app_router.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/avatars.dart';
import '../widgets/glow_backdrop.dart';

/// Splash screen: logo, wordmark, tagline, lalu lanjut otomatis.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const Duration _splashDuration = Duration(milliseconds: 2200);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(_splashDuration, _goToOnboarding);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _goToOnboarding() {
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(AppRoutes.onboarding);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackdrop(
        showGrid: true,
        glows: const <GlowSpec>[
          GlowSpec(
            color: AppColors.primary,
            alignment: Alignment.bottomLeft,
            size: 360,
            opacity: 0.18,
          ),
          GlowSpec(
            color: AppColors.secondary,
            alignment: Alignment.topRight,
            size: 280,
            opacity: 0.09,
          ),
        ],
        child: SafeArea(
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(milliseconds: 850),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.scale(
                  scale: 0.94 + (value * 0.06),
                  child: child,
                ),
              );
            },
            child: Column(
              children: <Widget>[
                const Spacer(flex: 3),
                SizedBox(
                  width: 96,
                  height: 96,
                  child: Image.asset(
                    'assets/images/body2fit_logo_small.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.fitness_center_rounded,
                      size: 56,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const BrandWordmark(fontSize: 34),
                const SizedBox(height: 10),
                SizedBox(
                  width: 250,
                  child: Text(
                    'Master Your Bodyweight,\nTransform Your Health.',
                    textAlign: TextAlign.center,
                    style: AppText.bodySm.copyWith(
                      color: AppColors.onSurfaceVariant,
                      height: 1.6,
                    ),
                  ),
                ),
                const Spacer(flex: 4),
                const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                    backgroundColor: Color(0x33FF5D68),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'CALISTHENICS & GYM TRACKER',
                  style: AppText.eyebrow.copyWith(
                    color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
                    fontSize: 10,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
