import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jengapp/models/expense-type.dart';
import 'package:jengapp/models/expense_item.dart';
import 'package:jengapp/utils/api.dart';
import 'package:jengapp/utils/constants.dart';

import '../controllers/expense-item-controller.dart';
import '../utils/helpers.dart';
import '../widgets/customicon.dart';
import '../widgets/dialogs.dart';
import '../widgets/input_widget.dart';

class Expenses extends StatelessWidget {
  final ExpenseController expenseController = Get.put(ExpenseController());

  TextEditingController amountTextEditingController = TextEditingController();
  TextEditingController commentTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getAllExpenseItems().then((allExpenses) {
        expenseController.updateExpensesList(allExpenses);
        expenseController.setExpenseListNotLoading();
      });
      getAllExpenseTypes().then((allExpenseTypes) {
        expenseController.updateExpenseType(allExpenseTypes);
      });
    });
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Constants.primaryColor,
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: 0.0,
            top: -20.0,
            child: Opacity(
              opacity: 0.3,
              child: Image.asset(
                "assets/images/background.png",
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: kToolbarHeight,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.0,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              FontAwesomeIcons.arrowLeft,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "Expenses",
                            //"Order #" + orderID + " Items",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: Colors.white,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    width: double.infinity,
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height - 100.0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                      color: Constants.scaffoldBackgroundColor,
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 24.0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Add Expense Items",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Constants.primaryColor,
                                  fontSize: 18),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 1.0, horizontal: 30),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Item",
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Obx(() => DropdownButton<String>(
                                            // Step 3.
                                            value: expenseController
                                                .selectedExpenseType.value,
                                            // Step 4.
                                            items: expenseController.expenseType
                                                .map<DropdownMenuItem<String>>(
                                                    (ExpenseType value) {
                                              return DropdownMenuItem<String>(
                                                value: value.expense,
                                                child: Text(
                                                  value.expense,
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Constants
                                                          .primaryColor),
                                                  textAlign: TextAlign.center,
                                                ),
                                              );
                                            }).toList(),
                                            // Step 5.
                                            onChanged: (String? newValue) {
                                              expenseController
                                                  .updateSelectedExpenseType(
                                                      newValue!);
                                            },
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InputWidget(
                                    prefixIcon: Icons.numbers,
                                    topLabel: "Amount",
                                    hintText: "E.g 200",
                                    textEditingController:
                                        amountTextEditingController,
                                  ),
                                  InputWidget(
                                    prefixIcon: FontAwesomeIcons.comment,
                                    topLabel: "Comment",
                                    hintText: "E.g any comment",
                                    textEditingController:
                                        commentTextEditingController,
                                  ),
                                ],
                              ),
                              myAdminButton("Add Expense", 10, 15, () {
                                if (amountTextEditingController.text.isEmpty) {
                                  Get.snackbar("Expense",
                                      "Amount for expense can not be empty!",
                                      snackPosition: SnackPosition.BOTTOM,
                                      colorText: Constants.grayColor,
                                      backgroundColor: Constants.whiteColor,
                                      borderRadius: 10,
                                      icon: MyCustomIcon(
                                          iconData: FontAwesomeIcons.check,
                                          iconColor: Constants.secondaryColor,
                                          containerColor:
                                              Constants.secondaryColorOpacity));
                                } else {
                                  addExpense(
                                      expenseController
                                          .selectedExpenseType.value,
                                      amountTextEditingController.text
                                          .toString(),
                                      commentTextEditingController.text
                                          .toString());
                                }
                              }),
                              Divider(
                                indent: 25,
                                endIndent: 25,
                              ),
                            ],
                          ),
                        ),
                        Obx(
                          () => Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10.0,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 40,
                                      child: Text("No.",
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              color: Constants.primaryColor),
                                          textAlign: TextAlign.start),
                                    ),
                                    Container(
                                      width: 130,
                                      child: Text(
                                        "Name",
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: Constants.primaryColor),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    Container(
                                      width: 130,
                                      child: Text(
                                        "Amount",
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: Constants.primaryColor),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    Container(
                                      width: 20,
                                      child: Icon(
                                        Icons.delete,
                                        color: Constants.primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(
                                  indent: 25,
                                  endIndent: 25,
                                ),
                                expenseController.expenseListLoading.value
                                    ? Center(
                                        child: Text("Loading expense items...",
                                            style: TextStyle(fontSize: 18)),
                                      )
                                    : expenseController.expenseList.length > 0
                                        ? Column(children: [
                                            ListView.separated(
                                              shrinkWrap: true,
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 16.0,
                                                vertical: 10.0,
                                              ),
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                // Lets pass the order to a new widget and render it there
                                                return Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          width: 40,
                                                          child: Text(
                                                              (index + 1)
                                                                      .toString() +
                                                                  ". ",
                                                              style: TextStyle(
                                                                  fontSize: 17),
                                                              textAlign:
                                                                  TextAlign
                                                                      .start),
                                                        ),
                                                        Container(
                                                          width: 130,
                                                          child: Text(
                                                            expenseController
                                                                .expenseList[
                                                                    index]
                                                                .expenseName,
                                                            style: TextStyle(
                                                                fontSize: 17),
                                                            textAlign:
                                                                TextAlign.start,
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 130,
                                                          child: Text(
                                                            forCurrencyString(
                                                                expenseController
                                                                    .expenseList[
                                                                        index]
                                                                    .expenseAmount),
                                                            style: TextStyle(
                                                                fontSize: 17),
                                                            textAlign:
                                                                TextAlign.start,
                                                          ),
                                                        ),
                                                        // Container(
                                                        //   width: 50,
                                                        //   child: Text(
                                                        //     orderItemListController
                                                        //         .orderItemList[
                                                        //             index]
                                                        //         .itemQuantity,
                                                        //     style: TextStyle(
                                                        //         fontSize: 17),
                                                        //     textAlign:
                                                        //         TextAlign.start,
                                                        //   ),
                                                        // ),

                                                        Container(
                                                          width: 20,
                                                          child:
                                                              GestureDetector(
                                                            child: Icon(
                                                                Icons.delete),
                                                            onTap: () => deleteExpense(
                                                                expenseController
                                                                    .expenseList[
                                                                        index]
                                                                    .recID),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    if (expenseController
                                                        .expenseList[index]
                                                        .expenseDescription
                                                        .isNotEmpty)
                                                      Row(
                                                        children: [
                                                          SizedBox(
                                                            width: 70,
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              expenseController
                                                                  .expenseList[
                                                                      index]
                                                                  .expenseDescription,
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  color: Constants
                                                                      .grayColor),
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 70,
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            myDateFormat(
                                                                expenseController
                                                                    .expenseList[
                                                                        index]
                                                                    .expenseDate),
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                color: Constants
                                                                    .grayColor),
                                                            textAlign:
                                                                TextAlign.start,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                );
                                              },
                                              separatorBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return SizedBox(
                                                  height: 5.0,
                                                );
                                              },
                                              itemCount: expenseController
                                                  .expenseList.length,
                                            ),
                                            Divider(
                                              indent: 25,
                                              endIndent: 25,
                                            ),
                                            Text(
                                              "Total expenses: " +
                                                  forCurrencyString(
                                                      getItemCount(
                                                              expenseController
                                                                  .expenseList)
                                                          .toString()),
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ])
                                        : Center(
                                            child: Text("No expense items...",
                                                style: TextStyle(fontSize: 18)),
                                          ),

                                // Let's create an order model
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<List<ExpenseItem>?> getAllExpenseItems() async {
    String url = apiEndpoints.allExpenses;
    http.Response response;
    response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((expenseItem) => ExpenseItem.fromJson(expenseItem))
          .toList();
    } else {
      return null;
    }
  }

  Future<List<ExpenseType>?> getAllExpenseTypes() async {
    String url = apiEndpoints.allExpenseTypes;
    http.Response response;
    response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((item) => ExpenseType.fromJson(item)).toList();
    } else {
      return null;
    }
  }

  getItemCount(List<ExpenseItem> orderItemList) {
    late double itemCount = 0;
    for (var i = 0; i < orderItemList.length; i++) {
      itemCount =
          itemCount + double.parse(orderItemList[i].expenseAmount.toString());
    }
    double total = itemCount;
    return total;
  }

  void deleteExpense(recordID) {
    showConfirmationModalDialog(
        "Delete Expense", "Delete expense item?", "Delete", "Cancel", () {
      //showProgressDialog("Deleting", "Please hold..");
      //Get.back();
      var client = http.Client();
      client.delete(
          Uri.parse(apiEndpoints.deleteExpenses + "?recordID=" + recordID),
          body: {
            "recordID": recordID,
          }).then((response) {
        client.close();

        if (response.statusCode == 200) {
          var jsonResponse = json.decode(response.body);
          if (jsonResponse['code'] == 1 || jsonResponse['code'] == 0) {
            Get.snackbar("Expense", jsonResponse['message'],
                snackPosition: SnackPosition.BOTTOM,
                colorText: Constants.grayColor,
                backgroundColor: Constants.whiteColor,
                borderRadius: 10,
                icon: MyCustomIcon(
                    iconData: FontAwesomeIcons.check,
                    iconColor: Constants.secondaryColor,
                    containerColor: Constants.secondaryColorOpacity));
          }
        } else {
          serverError(response.statusCode.toString());
        }
        getAllExpenseItems().then((allExpenses) {
          expenseController.updateExpensesList(allExpenses);
          expenseController.setExpenseListNotLoading();
        });
      });
      Get.back();
    });
  }

  void addExpense(String selectedExpenseType, String amount, String comment) {
    showProgressDialog("Adding", "Please hold..");
    Get.back();
    var client = http.Client();
    client.post(Uri.parse(apiEndpoints.addExpenses), body: {
      "expenseType": selectedExpenseType,
      "amount": amount.toString(),
      "comment": comment,
    }).then((response) {
      client.close();

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse['code'] == 1 || jsonResponse['code'] == 0) {
          Get.snackbar("Order", jsonResponse['message'],
              snackPosition: SnackPosition.BOTTOM,
              colorText: Constants.grayColor,
              backgroundColor: Constants.whiteColor,
              borderRadius: 10,
              icon: MyCustomIcon(
                  iconData: FontAwesomeIcons.check,
                  iconColor: Constants.secondaryColor,
                  containerColor: Constants.secondaryColorOpacity));
        }
      } else {
        serverError(response.statusCode.toString());
      }

      getAllExpenseItems().then((allExpenses) {
        expenseController.updateExpensesList(allExpenses);
        expenseController.setExpenseListNotLoading();
      });
    });

    //Get.back();
    commentTextEditingController.text = "";
    amountTextEditingController.text = "";
    //orderItemListController.initializeUnits();
  }
}
