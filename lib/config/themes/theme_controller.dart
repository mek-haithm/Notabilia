// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'themes.dart';
//
// class ThemeController extends GetxController {
//   RxBool isDarkMode = false.obs;
//
//   ThemeData get currentTheme =>
//       isDarkMode.value ? Themes.darkTheme : Themes.lightTheme;
//
//   void toggleTheme(bool value) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     isDarkMode.value = value;
//     prefs.setBool('isDarkMode', isDarkMode.value);
//     Get.changeTheme(currentTheme);
//   }
//
//   @override
//   void onInit() async {
//     super.onInit();
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     isDarkMode.value = prefs.getBool('isDarkMode') ?? false;
//     Get.changeTheme(currentTheme);
//   }
// }
