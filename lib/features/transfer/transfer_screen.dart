// lib/features/transfer/transfer_screen.dart

import 'package:flutter/material.dart';
import 'package:lux_blocks/lux_blocks.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../dashboard/services/account_service.dart';
import 'services/transfer_service.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  int _selectedContact = -1;

  final _accountService = AccountService.instance;
  final _transferService = TransferService.instance;

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
    final fg = isDark ? AppColors.foregroundDark : AppColors.foregroundLight;
    final muted =
        isDark ? AppColors.mutedForegroundDark : AppColors.mutedForegroundLight;
    final cardBg = isDark ? AppColors.cardDark : AppColors.cardLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;

    final accounts = _accountService.getDepositAccounts();
    final primaryAccount = accounts.isNotEmpty ? accounts.first : null;
    final contacts = _transferService.getContacts();

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('โอนเงิน', style: AppTextStyles.h3(color: fg)),
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
            // ── From Account ──
            if (primaryAccount != null)
              BlocksCard(
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.chartIndigo.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppColors.radiusMd),
                      ),
                      child: const Icon(
                        LucideIcons.wallet,
                        color: AppColors.chartIndigo,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('จากบัญชี', style: AppTextStyles.caption(color: muted)),
                          Text(
                            primaryAccount.name,
                            style: AppTextStyles.label(color: fg),
                          ),
                          Text(
                            '฿${primaryAccount.balance.toStringAsFixed(2)}',
                            style: AppTextStyles.bodySmall(color: AppColors.success),
                          ),
                        ],
                      ),
                    ),
                    Icon(LucideIcons.chevronDown, color: muted, size: 18),
                  ],
                ),
              ),

            const SizedBox(height: 20),

            // ── Quick Contacts ──
            Text('โอนด่วน', style: AppTextStyles.label(color: fg)),
            const SizedBox(height: 12),
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: contacts.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Column(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: cardBg,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: border,
                                style: BorderStyle.solid,
                              ),
                            ),
                            child: Icon(LucideIcons.plus, color: muted, size: 20),
                          ),
                          const SizedBox(height: 6),
                          Text('เพิ่มใหม่',
                              style: AppTextStyles.caption(color: muted)),
                        ],
                      ),
                    );
                  }
                  final contact = contacts[index - 1];
                  final isSelected = _selectedContact == index - 1;
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedContact = index - 1),
                      child: Column(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              gradient: isSelected
                                  ? const LinearGradient(
                                      colors: [
                                        Color(0xFF6366F1),
                                        Color(0xFF8B5CF6),
                                      ],
                                    )
                                  : null,
                              color: isSelected ? null : cardBg,
                              shape: BoxShape.circle,
                              border: isSelected
                                  ? null
                                  : Border.all(color: border),
                            ),
                            child: Center(
                              child: Text(
                                contact.avatar,
                                style: AppTextStyles.label(
                                  color: isSelected ? Colors.white : fg,
                                ).copyWith(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            contact.name,
                            style: AppTextStyles.caption(
                              color: isSelected ? AppColors.chartIndigo : muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // ── Amount Input ──
            BlocksInput(
              label: 'จำนวนเงิน',
              hint: '0.00',
              controller: _amountController,
              keyboardType: TextInputType.number,
              leading: const Text('฿', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),

            const SizedBox(height: 16),

            // ── Note ──
            BlocksInput(
              label: 'บันทึกช่วยจำ (ไม่บังคับ)',
              hint: 'เช่น ค่าอาหาร, ค่าเช่า',
              controller: _noteController,
            ),

            const SizedBox(height: 32),

            // ── Submit Button ──
            SizedBox(
              width: double.infinity,
              child: BlocksButton(
                label: 'โอนเงิน',
                onPressed: () {
                  DialogConfirmation.show(context);
                },
                variant: BlocksButtonVariant.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
