class AccountsData {
  final String accountid;
  final String name;
  final int amount;
  final List arecords;

  AccountsData(
      {required this.accountid,
      required this.name,
      required this.amount,
      required this.arecords});
}

class IncomeExpenseData {
  final int income;
  final int expense;

  IncomeExpenseData({
    required this.income,
    required this.expense,
  });
}

class RecordsData {
  final int amount;
  final String rtype;

  RecordsData({
    required this.amount,
    required this.rtype,
  });
}
