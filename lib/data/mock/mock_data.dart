import '../models/user_model.dart';
import '../models/account_model.dart';
import '../models/transaction_model.dart';
import '../models/card_model.dart';

class MockData {
  MockData._();

  static const user = UserModel(
    id: '1',
    fullName: 'Warinthon K.',
    email: 'warinthon@luxbank.com',
    phone: '098-765-4321',
  );

  static const accounts = [
    AccountModel(
      id: 'acc-1',
      name: 'บัญชีออมทรัพย์',
      type: AccountType.savings,
      balance: 285750.50,
      accountNumber: '4821093756',
    ),
    AccountModel(
      id: 'acc-2',
      name: 'บัญชีกระแสรายวัน',
      type: AccountType.checking,
      balance: 42300.00,
      accountNumber: '4821093801',
    ),
    AccountModel(
      id: 'acc-3',
      name: 'บัตรเครดิต Platinum',
      type: AccountType.credit,
      balance: -15420.75,
      accountNumber: '5412789034',
    ),
  ];

  static const cards = [
    CardModel(
      id: 'card-1',
      cardNumber: '4532 1234 5678 9012',
      holderName: 'WARINTHON K.',
      expiryDate: '12/28',
      cvv: '456',
      type: CardType.visa,
      tier: CardTier.platinum,
      balance: 285750.50,
      spendingLimit: 100000,
      currentSpending: 34500,
    ),
    CardModel(
      id: 'card-2',
      cardNumber: '5412 9876 5432 1098',
      holderName: 'WARINTHON K.',
      expiryDate: '06/27',
      cvv: '789',
      type: CardType.mastercard,
      tier: CardTier.gold,
      balance: 42300.00,
      spendingLimit: 50000,
      currentSpending: 15420.75,
    ),
  ];

  static final transactions = [
    TransactionModel(
      id: 'tx-1',
      title: 'เงินเดือน',
      description: 'บริษัท LuxTech Co., Ltd.',
      amount: 85000.00,
      type: TransactionType.income,
      category: TransactionCategory.salary,
      date: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    TransactionModel(
      id: 'tx-2',
      title: 'Grab Food',
      description: 'อาหารกลางวัน',
      amount: 245.00,
      type: TransactionType.expense,
      category: TransactionCategory.food,
      date: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    TransactionModel(
      id: 'tx-3',
      title: 'BTS Rabbit',
      description: 'เติมเงิน Rabbit Card',
      amount: 500.00,
      type: TransactionType.expense,
      category: TransactionCategory.transport,
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
    TransactionModel(
      id: 'tx-4',
      title: 'โอนเงิน',
      description: 'ส่งให้คุณแม่',
      amount: 10000.00,
      type: TransactionType.transfer,
      category: TransactionCategory.transfer,
      recipientName: 'สมศรี ก.',
      date: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
    ),
    TransactionModel(
      id: 'tx-5',
      title: 'Central Online',
      description: 'เสื้อผ้า',
      amount: 2890.00,
      type: TransactionType.expense,
      category: TransactionCategory.shopping,
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
    TransactionModel(
      id: 'tx-6',
      title: 'ค่าไฟฟ้า',
      description: 'การไฟฟ้านครหลวง',
      amount: 1850.00,
      type: TransactionType.expense,
      category: TransactionCategory.bills,
      date: DateTime.now().subtract(const Duration(days: 3)),
    ),
    TransactionModel(
      id: 'tx-7',
      title: 'Netflix',
      description: 'Premium Plan',
      amount: 419.00,
      type: TransactionType.expense,
      category: TransactionCategory.entertainment,
      date: DateTime.now().subtract(const Duration(days: 4)),
    ),
    TransactionModel(
      id: 'tx-8',
      title: 'เงินปันผล',
      description: 'กองทุน LTF',
      amount: 3200.00,
      type: TransactionType.income,
      category: TransactionCategory.other,
      date: DateTime.now().subtract(const Duration(days: 5)),
    ),
    TransactionModel(
      id: 'tx-9',
      title: 'โรงพยาบาล',
      description: 'ตรวจสุขภาพประจำปี',
      amount: 4500.00,
      type: TransactionType.expense,
      category: TransactionCategory.health,
      date: DateTime.now().subtract(const Duration(days: 6)),
    ),
    TransactionModel(
      id: 'tx-10',
      title: 'Udemy Course',
      description: 'Flutter Masterclass',
      amount: 390.00,
      type: TransactionType.expense,
      category: TransactionCategory.education,
      date: DateTime.now().subtract(const Duration(days: 7)),
    ),
  ];

  /// Monthly spending data (last 6 months)
  static const monthlySpending = [
    {'month': 'ม.ค.', 'income': 85000.0, 'expense': 42000.0},
    {'month': 'ก.พ.', 'income': 85000.0, 'expense': 38500.0},
    {'month': 'มี.ค.', 'income': 88200.0, 'expense': 45200.0},
    {'month': 'เม.ย.', 'income': 85000.0, 'expense': 51000.0},
    {'month': 'พ.ค.', 'income': 92000.0, 'expense': 39800.0},
    {'month': 'มิ.ย.', 'income': 85000.0, 'expense': 34500.0},
  ];

  /// Spending by category (current month)
  static const categorySpending = [
    {'category': 'อาหาร', 'amount': 8500.0, 'percentage': 0.25},
    {'category': 'เดินทาง', 'amount': 4200.0, 'percentage': 0.12},
    {'category': 'ช้อปปิ้ง', 'amount': 6800.0, 'percentage': 0.20},
    {'category': 'ค่าบิล', 'amount': 5200.0, 'percentage': 0.15},
    {'category': 'บันเทิง', 'amount': 3100.0, 'percentage': 0.09},
    {'category': 'สุขภาพ', 'amount': 4500.0, 'percentage': 0.13},
    {'category': 'อื่นๆ', 'amount': 2200.0, 'percentage': 0.06},
  ];

  /// Quick action contacts for transfer
  static const quickContacts = [
    {'name': 'สมศรี', 'bank': 'กสิกร', 'avatar': 'S'},
    {'name': 'วิชัย', 'bank': 'กรุงเทพ', 'avatar': 'W'},
    {'name': 'นิดา', 'bank': 'ไทยพาณิชย์', 'avatar': 'N'},
    {'name': 'ธนา', 'bank': 'กรุงไทย', 'avatar': 'T'},
  ];
}
