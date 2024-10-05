import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'config/language/locale.dart';
import 'config/language/locale_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/startups/screens/splash_screen.dart';

SharedPreferences? sharedPref;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPref = await SharedPreferences.getInstance();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    LocalController controller = Get.put(LocalController());
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      locale: controller.initialLang,
      translations: MyLocale(),
      home: const SplashScreen(),
    );
  }
}