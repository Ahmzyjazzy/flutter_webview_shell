import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Swift {
  static const String app_version = "Version 1.0.0";
  static const kAndroidUserAgent =
      '''Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36''';

  static const kDesktopUserAgent =
      'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.130 Safari/537.36';

  //*  Texts
  static const String loginNote =
      "Manage your suppliers, customers, expenses, cash flow, payroll and inventory amongst other business activities from anywhere";
  static const String loading_text = "Loading...";
  static const String try_again_text = "Try Again";
  static const String some_error_text = "Some error";
  static const String signInText = "LOGIN";
  static const String signUpText = "SIGN UP";
  static const String forgetPasswordText = "Forgot Password?";
  static const String resetText = "Reset Password";
  static const String wrongText = "Something went wrong";
  static const String confirmText = "Confirm";
  static const String supportText = "Support Needed";
  static const String featureText = "Feature Request";
  static const String moreFeatureText = "More Features coming soon.";
  static const String updateNowText =
      "Please update your app for seamless experience.";
  static const String checkNetText =
      "It seems like your internet connection is not active.";

  //* ActionTexts

  //* Function
  static String validatePassword(String value) {
    if (value.length < 6)
      return 'Password must be 6 or more charater';
    else
      return null;
  }

  static String validateMobile(String value) {
    // Nigeria Mobile number are of 11 digit only
    if (value.length != 11)
      return 'Mobile Number must be of 10 digit';
    else
      return null;
  }

  static String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  static bool isValidEmail(value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return false;
    else
      return true;
  }

  static bool isValidPassword(String value) {
    if (value.length < 6)
      return false;
    else
      return true;
  }

  static String createQueryString(
      {String table, Map<String, dynamic> columnData, String primaryKey}) {
    String table = 'user';
    var buffer = new StringBuffer();
    buffer.write('CREATE TABLE IF NOT EXISTS $table(');
    //create table if not exist
    columnData.forEach((key, value) {
      //check for primary key first
      if (key.toLowerCase() == primaryKey.toLowerCase()) {
        buffer.write('$key integer primary key autoincrement,');
      } else {
        (value != null && value is String)
            ? buffer.write('$key text not null,')
            : buffer.write('$key integer not null,');
      }
    });
    //close
    buffer.write(')');
    return buffer.toString();
  }

  static showToast({String msg, String toastType}) {
    Map<String, Color> type = {
      'error': Colors.red,
      'success': Colors.green,
      'info': Colors.blue,
      'warning': Colors.yellow,
      'default': Colors.black54
    };

    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 3,
        backgroundColor: toastType != null ? type[toastType] : type['default'],
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
