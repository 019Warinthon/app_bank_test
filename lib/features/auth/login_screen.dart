import 'package:flutter/material.dart';
import 'package:lux_blocks/lux_blocks.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppColors.spacingLg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Bank Logo
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.account_balance_rounded,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
                const SizedBox(height: AppColors.spacingLg),
                Text(
                  'LuxBank',
                  style: AppTextStyles.h1(
                    color: isDark
                        ? AppColors.foregroundDark
                        : AppColors.foregroundLight,
                  ),
                ),
                const SizedBox(height: AppColors.spacingSm),
                Text(
                  'ยินดีต้อนรับกลับมา',
                  style: AppTextStyles.body(
                    color: isDark
                        ? AppColors.mutedForegroundDark
                        : AppColors.mutedForegroundLight,
                  ),
                ),
                const SizedBox(height: AppColors.spacing2xl),

                // lux_blocks LoginEmailGoogle block (useScaffold: false to embed)
                LoginEmailGoogle(
                  useScaffold: false,
                  onEmailSignIn: (email) {
                    // TODO: handle email login
                  },
                  onGoogleSignIn: () {
                    // TODO: handle Google sign in
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
