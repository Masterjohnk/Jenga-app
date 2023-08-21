import 'package:get/get.dart';
import 'package:jengapp/pages/admindashboard.dart';
import 'package:jengapp/pages/create_order_items.dart';
import 'package:jengapp/pages/landingpage.dart';
import 'package:jengapp/pages/order-invoice-viewer.dart';

import '../pages/AllOrders.dart';
import '../pages/alerts.dart';
import '../pages/cart.dart';
import '../pages/create_expense_items.dart';
import '../pages/createorder.dart';
import '../pages/customers.dart';
import '../pages/homescreen.dart';
import '../pages/login.dart';
import '../pages/ordermanagement.dart';
import '../pages/register.dart';

int transtionDuration = 100;
Transition transition = Transition.leftToRightWithFade;

class Routes {
  static final routes = [
    GetPage(
        name: '/',
        page: () => LandingPage(),
        transition: transition,
        transitionDuration: Duration(milliseconds: transtionDuration)),
    GetPage(
        name: '/login',
        page: () => Login(),
        transition: transition,
        transitionDuration: Duration(milliseconds: transtionDuration)),
    GetPage(
        name: '/register',
        page: () => Register(),
        transition: transition,
        transitionDuration: Duration(milliseconds: transtionDuration)),
    GetPage(
        name: '/order_items',
        page: () => OrderItems(),
        transition: transition,
        transitionDuration: Duration(milliseconds: transtionDuration)),
    GetPage(
        name: '/order-place',
        page: () => OrderPlace(),
        transition: transition,
        transitionDuration: Duration(milliseconds: transtionDuration)),
    GetPage(
        name: '/homescreen',
        page: () => HomeScreen(),
        transition: transition,
        transitionDuration: Duration(milliseconds: transtionDuration)),
    GetPage(
        name: '/all-orders',
        page: () => AllOrders(),
        transition: transition,
        transitionDuration: Duration(milliseconds: transtionDuration)),
    GetPage(
        name: '/order-management',
        page: () => OrderManagement(),
        transition: transition,
        transitionDuration: Duration(milliseconds: transtionDuration)),
    GetPage(
        name: '/alerts',
        page: () => Alerts(),
        transition: transition,
        transitionDuration: Duration(milliseconds: transtionDuration)),
    GetPage(
        name: '/admin-dashboard',
        page: () => AdminDashboard(),
        transition: transition,
        transitionDuration: Duration(milliseconds: transtionDuration)),
    GetPage(
        name: '/expenses',
        page: () => Expenses(),
        transition: transition,
        transitionDuration: Duration(milliseconds: transtionDuration)),
    GetPage(
        name: '/order-invoice',
        page: () => OrderInvoiceViewer(),
        transition: transition,
        transitionDuration: Duration(milliseconds: transtionDuration)),
    GetPage(
        name: '/all-customers',
        page: () => Customers(),
        transition: transition,
        transitionDuration: Duration(milliseconds: transtionDuration)),
    GetPage(
        name: '/my-cart',
        page: () => Cart(),
        transition: transition,
        transitionDuration: Duration(milliseconds: transtionDuration))
  ];
}
