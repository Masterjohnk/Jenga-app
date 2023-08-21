class apiEndpoints {
  static const root = "https://njengapp.churchapp.co.ke/api/";
  static const String login = "${root}login";
  static const String register = "${root}register";
  static const String services = "${root}services";
  static const String promotions = "${root}promotions";
  static const String profileImage =
      "https://njengapp.churchapp.co.ke/public/profilepics/";
  static const String serviceImages =
      "https://njengapp.churchapp.co.ke/public/serviceimages/";
  static const String promotionImages =
      "https://njengapp.churchapp.co.ke/public/promotionimages/";
  static const String createOrder = "${root}createOrder";
  static const String allOrders = "${root}all-orders";
  static const String deleteOrder = "${root}deleteOrder";
  static const String allOrderItems = "${root}order-items";
  static const String deleteOrderItem = "${root}delete-order-item";
  static const String addOrderItem = "${root}create-order-item";
  static const String allClotheTypes = "${root}all-clothe-types";
  static const String allExpenseTypes = "${root}all-expense-types";
  static const String forGotPassword = "${root}forgot-password";
  static const String allExpenses = "${root}all-expenses";
  static const String deleteExpenses = "${root}delete-expense";
  static const String addExpenses = "${root}add-expense";
  static const String getDashboardData = "${root}allData";
  //invoice
  static const String orderInvoice = "${root}order-invoice";
  //bulk
  static const String personalDashboard = "${root}dashboard_personal";
  static const String groupDashboard = "${root}dashboard_group";
  static const String groupTransactions = "${root}transactions_group";
  static const String personalTransactions = "${root}transactions_personal";

  static const String updatePayStatus = "${root}paystatus";
  static const String updateOrderAmount = "${root}order-amount";
  static const String updateOrderQuantity = "${root}order-quantity";
  static const String updateOrderStatus = "${root}order-status";
  static const String approveTransaction = "${root}approve_transaction";
  static const String updateTransaction = "${root}update_transaction";

  static const String constitution =
      "http://njengapp.churchapp.co.ke/constitution/";
  static const String transactionsCategories = "${root}transaction_categories";
  static const String personalAlerts = "${root}personal-alerts";
  static const String personalRecentTransactions =
      "${root}recentPersonalTransaction";
  static const String groupRecentTransactions = "${root}recentGroupTransaction";
  static const String getAllMembers = "${root}allMembers";
  static const String setMemberRole = "${root}member_role";
  static const String setMemberStatus = "${root}member_status";
  static const String getMemberLoanIDs = "${root}get_loanIDs";
  static const String allMembersLVT = "${root}allMembersLVT";

  static const String updateCustomerDetails = "${root}updateCustomerDetails";
  static const String updateMemberEmail = "${root}updateMemberEmail";
  static const String updateMemberPassword = "${root}updateMemberPassword";
  static const String getMemberProfile = "${root}getMemberProfile";
  static const String getReportList = "${root}getReportList";
  static const String createAlert = "${root}create_alert";
  static const String updateMpesaCode = "${root}updateMpesaCode";
  static const String updateMemberImage = "${root}updateMemberImage";
  static const String report = "${root}report";
  static const String groupSettings = "${root}groutSettings";
}
