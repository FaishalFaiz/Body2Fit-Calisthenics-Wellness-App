import 'package:flutter/material.dart';

import '../core/app_router.dart';
import '../core/app_state.dart';
import '../models/exercise.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/app_buttons.dart';
import '../widgets/avatars.dart';
import '../widgets/glow_backdrop.dart';
import '../widgets/screen_top_bar.dart';

/// Onboarding 2 langkah: pengenalan calisthenics lalu panduan visual.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_page == 0) {
      _controller.animateToPage(
        1,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
      );
      return;
    }
    _finish();
  }

  void _finish() {
    Navigator.of(context).pushReplacementNamed(AppRoutes.auth);
  }

  void _back() {
    _controller.animateToPage(
      0,
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.of(context);
    final Exercise? pushUp = state.byCode('PUSH_UPS');
    final Exercise? plank = state.byCode('PLANK');

    return Scaffold(
      body: AppBackdrop(
        glows: <GlowSpec>[
          GlowSpec(
            color: _page == 0 ? AppColors.primary : AppColors.secondary,
            alignment: _page == 0 ? Alignment.bottomLeft : Alignment.bottomRight,
            size: 340,
            opacity: 0.15,
          ),
        ],
        child: SafeArea(
          bottom: false,
          child: Column(
            children: <Widget>[
              _TopBar(
                page: _page,
                onBack: _back,
                onSkip: _finish,
              ),
              Expanded(
                child: PageView(
                  controller: _controller,
                  onPageChanged: (int index) => setState(() => _page = index),
                  children: <Widget>[
                    _OnboardingPage(
                      hero: _FirstHero(exercise: pushUp),
                      stepLabel: 'Langkah 01 / 02',
                      stepColor: AppColors.primary,
                      title: 'Kuasai Kekuatan Alami Tubuhmu',
                      body:
                          'Latihan calisthenics berbasis beban tubuh murni. Bangun otot '
                          'fungsional, kelenturan sendi, dan daya tahan maksimal di mana '
                          'saja tanpa perlengkapan mahal.',
                    ),
                    _OnboardingPage(
                      hero: _SecondHero(exercise: plank),
                      stepLabel: 'Langkah 02 / 02',
                      stepColor: AppColors.secondary,
                      title: 'Panduan Visual & Pelacak Presisi',
                      body:
                          'Setiap gerakan dipandu dengan visual form yang benar, timer '
                          'otomatis, rep counter, dan laporan konsistensi mingguan yang '
                          'membuatmu tetap disiplin.',
                    ),
                  ],
                ),
              ),
              _Footer(
                page: _page,
                onPressed: _next,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.page,
    required this.onBack,
    required this.onSkip,
  });

  final int page;
  final VoidCallback onBack;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: Row(
        children: <Widget>[
          if (page == 0)
            const BrandWordmark(fontSize: 20)
          else
            CircleIconButton(
              icon: Icons.arrow_back_rounded,
              onPressed: onBack,
              tooltip: 'Kembali',
              filled: true,
              size: 34,
              iconSize: 18,
            ),
          if (page == 1) const Expanded(child: Center(child: BrandWordmark(fontSize: 18))),
          if (page == 0) const Spacer(),
          InkWell(
            onTap: onSkip,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Text(
                'Lewati',
                style: AppText.bodySm.copyWith(
                  color: AppColors.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({
    required this.hero,
    required this.stepLabel,
    required this.stepColor,
    required this.title,
    required this.body,
  });

  final Widget hero;
  final String stepLabel;
  final Color stepColor;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          hero,
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: stepColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: stepColor.withValues(alpha: 0.25)),
            ),
            child: Text(
              stepLabel.toUpperCase(),
              style: AppText.eyebrow.copyWith(
                color: stepColor,
                fontSize: 10,
                letterSpacing: 0.9,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: AppText.headline.copyWith(color: AppColors.onSurface),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: AppText.body.copyWith(
              color: AppColors.onSurfaceVariant,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroFrame extends StatelessWidget {
  const _HeroFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderSubtle),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: <Color>[
                  Color(0x1AFF5D68),
                  Colors.transparent,
                  Color(0x1A155DFC),
                ],
                stops: <double>[0, 0.55, 1],
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _FirstHero extends StatelessWidget {
  const _FirstHero({this.exercise});

  final Exercise? exercise;

  @override
  Widget build(BuildContext context) {
    return _HeroFrame(
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ExerciseVisual(exercise: exercise, fallbackIcon: Icons.sports_gymnastics_rounded),
            ),
          ),
          const Positioned(
            left: 12,
            bottom: 12,
            child: _FeaturePill(
              icon: Icons.fitness_center_rounded,
              label: '100% Bebas Alat Gym',
            ),
          ),
        ],
      ),
    );
  }
}

class _SecondHero extends StatelessWidget {
  const _SecondHero({this.exercise});

  final Exercise? exercise;

  @override
  Widget build(BuildContext context) {
    return _HeroFrame(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: const Icon(
                      Icons.timer_outlined,
                      size: 19,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Target Harian: 25 Menit',
                          style: AppText.bodySm.copyWith(
                            color: AppColors.onSurface,
                            fontWeight: FontWeight.w600,
                            fontSize: 11.5,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          'Push-up & Core Mastery',
                          style: AppText.labelSm.copyWith(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '80%',
                    style: AppText.bodySm.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  ExerciseVisual(
                    exercise: exercise,
                    fallbackIcon: Icons.self_improvement_rounded,
                  ),
                  Positioned(
                    right: 0,
                    bottom: 2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Icon(
                            Icons.play_circle_outline_rounded,
                            size: 12,
                            color: AppColors.secondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Panduan Real-time',
                            style: AppText.labelSm.copyWith(
                              color: AppColors.onSurface,
                              fontSize: 9.5,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Row(
                children: <Widget>[
                  const Icon(
                    Icons.local_fire_department_rounded,
                    size: 18,
                    color: AppColors.accentOrange,
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      'Konsistensi: 5 Hari Beruntun',
                      style: AppText.bodySm.copyWith(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  const _StreakDots(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StreakDots extends StatelessWidget {
  const _StreakDots();

  static const List<String> _labels = <String>['S', 'S', 'R', 'K', 'J'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        for (int i = 0; i < _labels.length; i++)
          Padding(
            padding: EdgeInsets.only(left: i == 0 ? 0 : 3),
            child: Container(
              width: 16,
              height: 16,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: i >= 3 ? AppColors.primary : AppColors.primary.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Text(
                _labels[i],
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w800,
                  color: i >= 3 ? AppColors.onPrimary : AppColors.primary,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _FeaturePill extends StatelessWidget {
  const _FeaturePill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 13, color: AppColors.primary),
          const SizedBox(width: 5),
          Text(
            label,
            style: AppText.labelSm.copyWith(
              color: AppColors.onSurface,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }
}

/// Menampilkan visual gerakan dari aset PNG transparan agar menyatu dengan
/// latar gelap. GIF animasi dipakai pada halaman detail (Fase 2) di atas
/// panel terang, karena aset GIF memiliki latar putih solid.
class ExerciseVisual extends StatelessWidget {
  const ExerciseVisual({
    super.key,
    this.exercise,
    this.fallbackIcon = Icons.sports_gymnastics_rounded,
  });

  final Exercise? exercise;
  final IconData fallbackIcon;

  @override
  Widget build(BuildContext context) {
    final Exercise? item = exercise;
    if (item == null) {
      return Center(
        child: Icon(
          fallbackIcon,
          size: 72,
          color: AppColors.primary.withValues(alpha: 0.7),
        ),
      );
    }

    return Image.asset(
      item.cardImage,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.medium,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          item.basicGif,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => Center(
            child: Icon(
              fallbackIcon,
              size: 72,
              color: AppColors.primary.withValues(alpha: 0.7),
            ),
          ),
        );
      },
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.page, required this.onPressed});

  final int page;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final bool isLast = page == 1;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: page == 0 ? 28 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: page == 0 ? AppColors.primary : AppColors.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(width: 8),
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: page == 1 ? 28 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: page == 1 ? AppColors.primary : AppColors.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const Spacer(),
              Text(
                '${page + 1} dari 2',
                style: AppText.bodySm.copyWith(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            label: isLast ? 'Siap Bertransformasi' : 'Lanjutkan',
            trailingIcon: isLast ? Icons.check_circle_rounded : Icons.arrow_forward_rounded,
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}
