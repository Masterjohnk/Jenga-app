import 'package:shared_preferences/shared_preferences.dart';

import '../models/loggedinuser.dart';

class Prefs {
  // static late SharedPreferences prefs;
  // init() async {
  //   prefs ??= await SharedPreferences.getInstance();
  // }
  Future addStringToSF(String key, String val) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, val);
  }

  Future<String?> getStringValuesSF(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final image = prefs.getString(key);
    return image;
  }

  Future addBooleanToSF(String key, bool val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, val);
  }

  Future saveLoggedUser(LoggedInUser user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("phone", user.phone);
    prefs.setString("fname", user.fname);
    prefs.setString("lname", user.lname);
    prefs.setString("image", user.image);
    prefs.setString("role", user.role);
    prefs.setString("customerID", user.memberID.toString());
  }

  Future<bool> getBooleanValuesSF(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final val = prefs.getBool(key);
    return val ?? false;
  }

  Future<LoggedInUser> getLoggedUSer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final fname = prefs.getString('fname');
    final lname = prefs.getString('lname');
    final phone = prefs.getString('phone');
    final image = prefs.getString('image');
    final role = prefs.getString('role');
    final memberID = prefs.getString('memberID');
    LoggedInUser loggedInUser =
        LoggedInUser(fname, lname, phone, image, role, memberID);
    return loggedInUser;
  }
}
