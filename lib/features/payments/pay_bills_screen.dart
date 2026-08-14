import 'package:flutter/material.dart';
import 'package:lux_blocks/lux_blocks.dart';
import 'package:lucide_icons/lucide_icons.dart';

class PayBillsScreen extends StatefulWidget {
  const PayBillsScreen({super.key});

  @override
  State<PayBillsScreen> createState() => _PayBillsScreenState();
}

class _PayBillsScreenState extends State<PayBillsScreen> {
  final _refController = TextEditingController();
  final _amountController = TextEditingController();
  String? _selectedBiller;

  final _billers = const [
    {
      'name': 'การไฟฟ้า (MEA/PEA)',
      'icon': LucideIcons.zap,
      'color': Color(0xFFF59E0B),
    },
    {
      'name': 'การประปา (MWA/PWA)',
      'icon': LucideIcons.droplet,
      'color': Color(0xFF3B82F6),
    },
    {
      'name': 'อินเทอร์เน็ต / ดิจิทัล',
      'icon': LucideIcons.wifi,
      'color': Color(0xFF6366F1),
    },
    {
      'name': 'บัตรเครดิต & สินเชื่อ',
      'icon': LucideIcons.creditCard,
      'color': Color(0xFF10B981),
    },
    {
      'name': 'ประกันภัย & ประกันชีวิต',
      'icon': LucideIcons.shieldCheck,
      'color': Color(0xFFEC4899),
    },
    {
      'name': 'ค่าเทอม & การศึกษา',
      'icon': LucideIcons.graduationCap,
      'color': Color(0xFF8B5CF6),
    },
  ];

  @override
  void dispose() {
    _refController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
    final fg = isDark ? AppColors.foregroundDark : AppColors.foregroundLight;
    final muted = isDark
        ? AppColors.mutedForegroundDark
        : AppColors.mutedForegroundLight;
    final cardBg = isDark ? AppColors.cardDark : AppColors.cardLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('ชำระบิล', style: AppTextStyles.h3(color: fg)),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(Icons.arrow_back_ios_rounded, color: fg, size: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('เลือกหมวดหมู่บริการ', style: AppTextStyles.label(color: fg)),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.6,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: _billers.length,
              itemBuilder: (context, index) {
                final biller = _billers[index];
                final isSelected = _selectedBiller == biller['name'];
                final color = biller['color'] as Color;

                return GestureDetector(
                  onTap: () => setState(
                    () => _selectedBiller = biller['name'] as String,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? color.withValues(alpha: 0.15)
                          : cardBg,
                      borderRadius: BorderRadius.circular(AppColors.radiusLg),
                      border: Border.all(
                        color: isSelected ? color : border,
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(
                              AppColors.radiusMd,
                            ),
                          ),
                          child: Icon(
                            biller['icon'] as IconData,
                            color: color,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            biller['name'] as String,
                            style:
                                AppTextStyles.caption(
                                  color: isSelected ? color : fg,
                                ).copyWith(
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            if (_selectedBiller != null) ...[
              const SizedBox(height: 28),
              Text(
                'รายละเอียดบิล: $_selectedBiller',
                style: AppTextStyles.label(color: fg),
              ),
              const SizedBox(height: 12),
              BlocksInput(
                label: 'เลขที่อ้างอิง / เลขประจำตัวผู้เสียภาษี',
                hint: 'กรอกรหัสลูกค้า หรือ สแกนบาร์โค้ด',
                controller: _refController,
                leading: const Icon(LucideIcons.scanLine, size: 18),
              ),
              const SizedBox(height: 16),
              BlocksInput(
                label: 'จำนวนเงินชำระ',
                hint: '0.00',
                controller: _amountController,
                keyboardType: TextInputType.number,
                leading: const Text(
                  '฿',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: BlocksButton(
                  label: 'ยืนยันการชำระเงิน',
                  onPressed: () {
                    DialogConfirmation.show(context);
                  },
                  variant: BlocksButtonVariant.primary,
                ),
              ),
            ],

            const SizedBox(height: 28),
            Text(
              'คำแนะนำการชำระบิล',
              style: AppTextStyles.bodySmall(color: muted),
            ),
            const SizedBox(height: 12),
            const GridListIcons(),
          ],
        ),
      ),
    );
  }
}
