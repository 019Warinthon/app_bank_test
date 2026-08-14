import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lux_blocks/lux_blocks.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Profile screen using lux_blocks FormSideLabels block
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
    final fg = isDark ? AppColors.foregroundDark : AppColors.foregroundLight;
    final muted =
        isDark ? AppColors.mutedForegroundDark : AppColors.mutedForegroundLight;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('โปรไฟล์', style: AppTextStyles.h3(color: fg)),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => context.push('/settings'),
            icon: Icon(LucideIcons.settings, color: fg, size: 20),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ── Avatar Section ──
            Center(
              child: Column(
                children: [
                  const BlocksAvatar(
                    name: 'Warinthon K.',
                    size: BlocksAvatarSize.xl,
                  ),
                  const SizedBox(height: 12),
                  Text('Warinthon K.', style: AppTextStyles.h3(color: fg)),
                  Text(
                    'warinthon@luxbank.com',
                    style: AppTextStyles.bodySmall(color: muted),
                  ),
                  const SizedBox(height: 8),
                  const BlocksBadge(
                    label: 'Platinum Member',
                    variant: BlocksBadgeVariant.info,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ── Form using lux_blocks ──
            const FormSideLabels(useScaffold: false),
          ],
        ),
      ),
    );
  }
}
