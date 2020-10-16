import 'package:flutter/material.dart';

import 'AppColors.dart';

class Utils {
  /// screen width
  /// 当前屏幕 宽
  static double screenW(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return mediaQuery.size.width;
  }

  /// screen height
  /// 当前屏幕 高
  static double screenH(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return mediaQuery.size.height;
  }

  // static void showToast(String message) {
  //   if (message == null || message.isEmpty) return;
  //   Fluttertoast.showToast(
  //       msg: message,
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.BOTTOM,
  //       backgroundColor: AppColors.normalColor,
  //       fontSize: 14.0);
  // }
  static List<int> getImageParams(int msgWidth, int msgHeight) {
    List<int> params = [100, 100];
    if (msgWidth == 0 || msgHeight == 0) return params;
    if (msgWidth > msgHeight) {
      params[0] = 180;
      params[1] = 180 * msgHeight ~/ msgWidth;
    } else {
      params[0] = 180 * msgWidth ~/ msgHeight;
      params[1] = 180;
    }
    return params;
  }
}
