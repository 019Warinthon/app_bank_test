import 'package:flutter/material.dart';
import 'package:lux_blocks/lux_blocks.dart';
import 'package:lucide_icons/lucide_icons.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final _notifications = [
    _NotifItem(
      icon: LucideIcons.arrowDownLeft,
      color: Color(0xFF10B981),
      title: 'รับเงิน ฿85,000.00',
      body: 'บริษัท LuxTech Co., Ltd. โอนเงินเดือนเข้าบัญชีออมทรัพย์',
      time: '2 นาทีก่อน',
      isRead: false,
      type: _NotifType.income,
    ),
    _NotifItem(
      icon: LucideIcons.shieldCheck,
      color: Color(0xFF6366F1),
      title: 'เข้าสู่ระบบสำเร็จ',
      body: 'ตรวจพบการเข้าสู่ระบบใหม่ด้วย Face ID บน iPhone 15 Pro',
      time: '1 ชม. ก่อน',
      isRead: false,
      type: _NotifType.security,
    ),
    _NotifItem(
      icon: LucideIcons.arrowUpRight,
      color: Color(0xFFEF4444),
      title: 'โอนเงิน ฿10,000.00',
      body: 'โอนเงินให้ สมศรี ก. สำเร็จ · บัญชีกสิกรไทย',
      time: '3 ชม. ก่อน',
      isRead: false,
      type: _NotifType.expense,
    ),
    _NotifItem(
      icon: LucideIcons.receipt,
      color: Color(0xFFF59E0B),
      title: 'ชำระบิลสำเร็จ',
      body: 'ชำระค่าไฟฟ้า MEA ฿1,850.00 เรียบร้อยแล้ว',
      time: 'เมื่อวาน',
      isRead: true,
      type: _NotifType.bill,
    ),
    _NotifItem(
      icon: LucideIcons.star,
      color: Color(0xFF8B5CF6),
      title: 'ยินดีด้วย! คะแนนสะสมใหม่',
      body: 'คุณได้รับ 850 LuxPoints จากการใช้จ่ายในเดือนนี้',
      time: 'เมื่อวาน',
      isRead: true,
      type: _NotifType.reward,
    ),
    _NotifItem(
      icon: LucideIcons.creditCard,
      color: Color(0xFF06B6D4),
      title: 'ใกล้ถึงวงเงินบัตร',
      body: 'บัตรเครดิต Platinum ใช้ไปแล้ว 34.5% ของวงเงิน (฿34,500 / ฿100,000)',
      time: '2 วันก่อน',
      isRead: true,
      type: _NotifType.security,
    ),
    _NotifItem(
      icon: LucideIcons.trendingUp,
      color: Color(0xFF10B981),
      title: 'สรุปรายงานการใช้จ่ายประจำเดือน',
      body: 'เดือนนี้คุณประหยัดได้ ฿50,500 เพิ่มขึ้น 12% จากเดือนก่อน 🎉',
      time: '3 วันก่อน',
      isRead: true,
      type: _NotifType.summary,
    ),
  ];

  int get _unreadCount => _notifications.where((n) => !n.isRead).length;

  void _markAllRead() => setState(() {
        for (final n in _notifications) {
          n.isRead = true;
        }
      });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
    final fg = isDark ? AppColors.foregroundDark : AppColors.foregroundLight;
    final muted = isDark ? AppColors.mutedForegroundDark : AppColors.mutedForegroundLight;
    final cardBg = isDark ? AppColors.cardDark : AppColors.cardLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('การแจ้งเตือน', style: AppTextStyles.h3(color: fg)),
            if (_unreadCount > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.destructiveLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$_unreadCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ],
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(Icons.arrow_back_ios_rounded, color: fg, size: 20),
        ),
        actions: [
          if (_unreadCount > 0)
            TextButton(
              onPressed: _markAllRead,
              child: Text(
                'อ่านทั้งหมด',
                style: AppTextStyles.caption(color: AppColors.chartIndigo),
              ),
            ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: _notifications.length,
        itemBuilder: (context, i) {
          final notif = _notifications[i];
          return GestureDetector(
            onTap: () => setState(() => notif.isRead = true),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: notif.isRead
                    ? cardBg
                    : notif.color.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(AppColors.radiusLg),
                border: Border.all(
                  color: notif.isRead ? border : notif.color.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: notif.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(AppColors.radiusMd),
                    ),
                    child: Icon(notif.icon, color: notif.color, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                notif.title,
                                style: AppTextStyles.label(color: fg).copyWith(
                                  fontWeight: notif.isRead
                                      ? FontWeight.w500
                                      : FontWeight.w700,
                                ),
                              ),
                            ),
                            if (!notif.isRead)
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: notif.color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          notif.body,
                          style: AppTextStyles.caption(color: muted),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          notif.time,
                          style: AppTextStyles.caption(color: muted).copyWith(fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

enum _NotifType { income, expense, security, bill, reward, summary }

class _NotifItem {
  final IconData icon;
  final Color color;
  final String title;
  final String body;
  final String time;
  bool isRead;
  final _NotifType type;

  _NotifItem({
    required this.icon,
    required this.color,
    required this.title,
    required this.body,
    required this.time,
    required this.isRead,
    required this.type,
  });
}
