class AccountsData {
  final String accountid;
  late final String name;
  final int amount;

  AccountsData(
      {required this.accountid,
      required this.name,
      required this.amount,});
}

class IncomeExpenseData {
  final int income;
  final int expense;

  IncomeExpenseData({
    required this.income,
    required this.expense,
  });
}

