class DashboardData {
  var allSales;
  var allExpenses;
  var expensesNumber;
  var orderNumber;
  var paidOrdersvalue;
  var unPaidOrdersvalue;
  var uniqueOrders;
  var moneyunpaid;

  DashboardData({
    required this.allSales,
    required this.allExpenses,
    required this.uniqueOrders,
    //required this.orderNumber,
    required this.moneyunpaid,
    required this.paidOrdersvalue,
    required this.unPaidOrdersvalue,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      allSales: json['lifetimesales'] ?? "0.0",
      allExpenses: json['lifetimeexpenses'] ?? '0.0',
      moneyunpaid: json['moneyunpaid'] ?? '0.0',
      uniqueOrders: json['uniqueOrders']?? '0',
      paidOrdersvalue: json['paidOrdersvalue'] ?? '0',
      unPaidOrdersvalue: json['unpaidOrdersvalue'] ?? '0',
    );
  }
}
