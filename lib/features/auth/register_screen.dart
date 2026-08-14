import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lux_blocks/lux_blocks.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
    final muted = isDark ? AppColors.mutedForegroundDark : AppColors.mutedForegroundLight;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: isDark ? AppColors.foregroundDark : AppColors.foregroundLight,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppColors.spacingLg),
            child: Column(
              children: [
                Text(
                  'สร้างบัญชีใหม่',
                  style: AppTextStyles.h2(
                    color: isDark ? AppColors.foregroundDark : AppColors.foregroundLight,
                  ),
                ),
                const SizedBox(height: AppColors.spacingSm),
                Text(
                  'เริ่มต้นใช้งาน LuxBank วันนี้',
                  style: AppTextStyles.body(
                    color: isDark ? AppColors.mutedForegroundDark : AppColors.mutedForegroundLight,
                  ),
                ),
                const SizedBox(height: AppColors.spacing2xl),
                LoginCardSignup(
                  useScaffold: false,
                  onSignUp: (name, email, password) {
                    context.go('/dashboard');
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('มีบัญชีอยู่แล้ว? ', style: AppTextStyles.bodySmall(color: muted)),
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Text(
                        'เข้าสู่ระบบ',
                        style: AppTextStyles.bodySmall(color: AppColors.chartIndigo).copyWith(
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.chartIndigo,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
