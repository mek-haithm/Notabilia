import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/colors.dart';

class MySnackBar {
  static void showSnackBar({
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    Get.showSnackbar(
      GetSnackBar(
        margin: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 32.0),
        backgroundColor: kMainColor,
        borderRadius: 10.0,
        messageText: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'ibmFont',
            fontSize: 14.0,
          ),
        ),
        duration: duration,
        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,
        animationDuration: const Duration(milliseconds: 400),
      ),
    );
  }
}
