import 'package:flutter/material.dart';

import '../core/app_router.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/app_buttons.dart';
import '../widgets/app_text_field.dart';
import '../widgets/avatars.dart';
import '../widgets/glow_backdrop.dart';
import '../widgets/segmented_control.dart';

/// Layar masuk / daftar dengan segmented tab fungsional.
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController =
      TextEditingController(text: 'Arya Pratama');
  final TextEditingController _emailController =
      TextEditingController(text: 'arya.calisthenics@gmail.com');
  final TextEditingController _passwordController =
      TextEditingController(text: 'secretfitness123');

  bool _isSignUp = false;
  bool _obscurePassword = true;
  bool _rememberMe = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (!_isSignUp) return null;
    if ((value ?? '').trim().isEmpty) return 'Nama lengkap wajib diisi.';
    return null;
  }

  String? _validateEmail(String? value) {
    final String email = (value ?? '').trim();
    if (email.isEmpty) return 'Email wajib diisi.';
    final bool valid = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
    if (!valid) return 'Format email belum benar.';
    return null;
  }

  String? _validatePassword(String? value) {
    final String password = value ?? '';
    if (password.isEmpty) return 'Kata sandi wajib diisi.';
    if (password.length < 8) return 'Minimal 8 karakter.';
    return null;
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _openDashboard();
  }

  void _openDashboard() {
    Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
  }

  void _showForgotPassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tautan reset kata sandi akan dikirim ke emailmu.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: AppBackdrop(
        glows: const <GlowSpec>[
          GlowSpec(
            color: AppColors.primary,
            alignment: Alignment.bottomLeft,
            size: 340,
            opacity: 0.12,
          ),
        ],
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const _BrandHeader(),
                const SizedBox(height: 22),
                SegmentedControl(
                  labels: const <String>['Masuk (Login)', 'Daftar (Sign Up)'],
                  selectedIndex: _isSignUp ? 1 : 0,
                  onSelected: (int index) {
                    FocusScope.of(context).unfocus();
                    setState(() => _isSignUp = index == 1);
                  },
                ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      AnimatedSize(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeOut,
                        alignment: Alignment.topCenter,
                        child: _isSignUp
                            ? Column(
                                children: <Widget>[
                                  AppTextField(
                                    label: 'Nama Lengkap',
                                    hint: 'Arya Pratama',
                                    controller: _nameController,
                                    prefixIcon: Icons.person_outline_rounded,
                                    textInputAction: TextInputAction.next,
                                    validator: _validateName,
                                    autofillHints: const <String>[AutofillHints.name],
                                  ),
                                  const SizedBox(height: 14),
                                ],
                              )
                            : const SizedBox.shrink(),
                      ),
                      AppTextField(
                        label: 'Alamat Email',
                        hint: 'nama@email.com',
                        controller: _emailController,
                        prefixIcon: Icons.mail_outline_rounded,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: _validateEmail,
                        autofillHints: const <String>[AutofillHints.email],
                      ),
                      const SizedBox(height: 14),
                      AppTextField(
                        label: 'Kata Sandi',
                        hint: 'Minimal 8 karakter',
                        controller: _passwordController,
                        prefixIcon: Icons.lock_outline_rounded,
                        obscureText: _obscurePassword,
                        textInputAction: TextInputAction.done,
                        validator: _validatePassword,
                        autofillHints: const <String>[AutofillHints.password],
                        onFieldSubmitted: (_) => _submit(),
                        labelTrailing: InkWell(
                          onTap: _showForgotPassword,
                          borderRadius: BorderRadius.circular(4),
                          child: Text(
                            'Lupa Sandi?',
                            style: AppText.labelSm.copyWith(
                              color: AppColors.primary,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                        suffix: IconButton(
                          onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                          tooltip: _obscurePassword
                              ? 'Tampilkan kata sandi'
                              : 'Sembunyikan kata sandi',
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints.tightFor(
                            width: 38,
                            height: 38,
                          ),
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            size: 18,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _RememberRow(
                        value: _rememberMe,
                        onChanged: (bool value) => setState(() => _rememberMe = value),
                      ),
                      const SizedBox(height: 14),
                      PrimaryButton(
                        label: _isSignUp ? 'Buat Akun Baru' : 'Masuk ke Akun',
                        trailingIcon: _isSignUp
                            ? Icons.person_add_alt_1_rounded
                            : Icons.login_rounded,
                        onPressed: _submit,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                const _OrDivider(),
                const SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: _SocialButton(
                        icon: const Icon(
                          Icons.g_mobiledata_rounded,
                          size: 24,
                          color: AppColors.onSurface,
                        ),
                        label: 'Google',
                        onTap: _openDashboard,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _SocialButton(
                        icon: const Icon(
                          Icons.fingerprint_rounded,
                          size: 20,
                          color: AppColors.onSurface,
                        ),
                        label: 'Biometrik',
                        onTap: _openDashboard,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                const _TermsText(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BrandHeader extends StatelessWidget {
  const _BrandHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: 64,
          height: 64,
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Color(0x33000000),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Image.asset(
            'assets/images/body2fit_logo_small.png',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.fitness_center_rounded,
              color: AppColors.primary,
              size: 30,
            ),
          ),
        ),
        const SizedBox(height: 12),
        const BrandWordmark(fontSize: 26),
        const SizedBox(height: 6),
        Text(
          'Master Your Bodyweight, Transform Your Health',
          textAlign: TextAlign.center,
          style: AppText.bodySm.copyWith(
            color: AppColors.onSurfaceVariant,
            fontSize: 11.5,
          ),
        ),
      ],
    );
  }
}

class _RememberRow extends StatelessWidget {
  const _RememberRow({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 20,
          height: 20,
          child: Checkbox(
            value: value,
            onChanged: (bool? next) => onChanged(next ?? false),
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: GestureDetector(
            onTap: () => onChanged(!value),
            child: Text(
              'Ingat saya di perangkat ini',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.bodySm.copyWith(
                color: AppColors.onSurfaceVariant,
                fontSize: 11.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const Expanded(child: Divider(color: AppColors.divider, height: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'ATAU MASUK DENGAN',
            style: AppText.eyebrow.copyWith(
              color: AppColors.onSurfaceVariant,
              fontSize: 9,
              letterSpacing: 0.9,
            ),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.divider, height: 1)),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final Widget icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        hoverColor: AppColors.surfaceContainerHigh,
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              icon,
              const SizedBox(width: 6),
              Text(
                label,
                style: AppText.bodySm.copyWith(
                  color: AppColors.onSurface,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TermsText extends StatelessWidget {
  const _TermsText();

  @override
  Widget build(BuildContext context) {
    final TextStyle base = AppText.labelSm.copyWith(
      color: AppColors.onSurfaceVariant,
      fontSize: 10,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.6,
    );

    return Text.rich(
      TextSpan(
        style: base,
        children: const <InlineSpan>[
          TextSpan(text: 'Dengan melanjutkan, Anda menyetujui '),
          TextSpan(
            text: 'Ketentuan',
            style: TextStyle(
              color: AppColors.primary,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.primary,
            ),
          ),
          TextSpan(text: ' & '),
          TextSpan(
            text: 'Privasi',
            style: TextStyle(
              color: AppColors.primary,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.primary,
            ),
          ),
          TextSpan(text: ' Body2Fit.'),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
