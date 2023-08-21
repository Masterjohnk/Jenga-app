import 'package:get/get.dart';
import 'package:jengapp/models/expense_item.dart';

import '../models/expense-type.dart';

class ExpenseController extends GetxController {
  final expenseList = <ExpenseItem>[].obs;
  final expenseType = <ExpenseType>[].obs;
  final expenseListLoading = true.obs;
  final selectedExpenseType = "Washing Soap".obs;
  final units = 1.obs;

  updateExpensesList(allExpenses) {
    expenseList.value = allExpenses;
  }

  updateExpenseType(expenseTypes) {
    expenseType.value = expenseTypes;
  }

  setExpenseListNotLoading() {
    expenseListLoading.value = false;
  }

  updateSelectedExpenseType(expense) {
    selectedExpenseType.value = expense;
  }

  increaseUnits() {
    units.value++;
  }

  decreaseUnits() {
    if (units.value > 1) {
      units.value--;
    }
  }

  initializeUnits() {
    {
      units.value = 0;
    }
  }
}
