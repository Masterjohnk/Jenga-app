class ExpenseItem {
  final String recID;
  final String expenseName;
  final String expenseAmount;
  final String expenseDescription;
  final String expenseDate;

  ExpenseItem({
    required this.recID,
    required this.expenseName,
    required this.expenseAmount,
    required this.expenseDescription,
    required this.expenseDate,
  });

  factory ExpenseItem.fromJson(Map<String, dynamic> json) {
    return ExpenseItem(
      recID: json['recID'].toString() ?? '',
      expenseName: json['expenseName'] ?? '',
      expenseAmount: json['expenseAmount'].toString() ?? '',
      expenseDescription: json['expenseDescription'] ?? '',
      expenseDate: json['expenseDate'] ?? '',
    );
  }
}
