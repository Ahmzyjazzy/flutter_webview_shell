import 'package:flutter/material.dart';

class Setting {
  static const String app_name = "Accounting";
  static const int app_version_code = 1;
  static const Color app_color = Color(0xFFAD5389);
  static const app_url = "https://swiftledger.com/accounting/";

  //* Images
  static String app_logo = "assets/images/accounting-logo.png";
  static List<String> intro_images = [
    "assets/images/slide_1.png",
    "assets/images/slide_2.png",
    "assets/images/slide_3.png",
    "assets/images/slide_4.png"
  ];

  static List<String> intro_titles = [
    "Categorize Members",
    "Configure Dues",
    "Overdue debts Reminder",
    "Instant Notifications",
  ];

  //*  Texts
  static List<String> intro_descriptions = [
    "Categorise your members into various groups which will determine how much they pay, articles/news they receive, etc.",
    '''Setup one off (e.g. registration fees) or recurring (e.g. monthly or annual subscription fees) invoices.''',
    "Alert your members when a new payment is due or when they have overdue debts.",
    "Keep your members up to date with important information in the form of news, event notification and birthday reminders.",
  ];
}
