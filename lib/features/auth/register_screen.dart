import 'package:flutter/material.dart';
import 'package:lux_blocks/lux_blocks.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;

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
                    color: isDark
                        ? AppColors.foregroundDark
                        : AppColors.foregroundLight,
                  ),
                ),
                const SizedBox(height: AppColors.spacingSm),
                Text(
                  'เริ่มต้นใช้งาน LuxBank วันนี้',
                  style: AppTextStyles.body(
                    color: isDark
                        ? AppColors.mutedForegroundDark
                        : AppColors.mutedForegroundLight,
                  ),
                ),
                const SizedBox(height: AppColors.spacing2xl),
                LoginCardSignup(
                  useScaffold: false,
                  onSignUp: (name, email, password) {
                    // TODO: handle signup
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
