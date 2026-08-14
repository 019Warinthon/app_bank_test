import 'package:go_router/go_router.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/register_screen.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/cards/cards_screen.dart';
import '../features/transactions/transactions_screen.dart';
import '../features/transfer/transfer_screen.dart';
import '../features/payments/pay_bills_screen.dart';
import '../features/payments/qr_scan_screen.dart';
import '../features/ai_assistant/ai_chat_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/profile/settings_screen.dart';
import '../features/profile/security_screen.dart';
import '../features/notifications/notifications_screen.dart';
import '../shared/app_shell.dart';

final appRouter = GoRouter(
  initialLocation: '/dashboard',
  routes: [
    GoRoute(path: '/login', builder: (_, _) => const LoginScreen()),
    GoRoute(path: '/register', builder: (_, _) => const RegisterScreen()),

    StatefulShellRoute.indexedStack(
      builder: (_, _, shell) => AppShell(navigationShell: shell),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(path: '/dashboard', builder: (_, _) => const DashboardScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/cards', builder: (_, _) => const CardsScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/transactions', builder: (_, _) => const TransactionsScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/ai', builder: (_, _) => const AiChatScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/profile', builder: (_, _) => const ProfileScreen()),
        ]),
      ],
    ),

    GoRoute(path: '/transfer', builder: (_, _) => const TransferScreen()),
    GoRoute(path: '/pay-bills', builder: (_, _) => const PayBillsScreen()),
    GoRoute(path: '/qr-scan', builder: (_, _) => const QrScanScreen()),
    GoRoute(path: '/settings', builder: (_, _) => const SettingsScreen()),
    GoRoute(path: '/security', builder: (_, _) => const SecurityScreen()),
    GoRoute(path: '/notifications', builder: (_, _) => const NotificationsScreen()),
  ],
);
