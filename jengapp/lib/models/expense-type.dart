class ExpenseType {
  final String expense;

  ExpenseType({
    required this.expense,
  });

  factory ExpenseType.fromJson(Map<String, dynamic> json) {
    return ExpenseType(
      expense: json['name'] ?? '',
    );
  }
}
