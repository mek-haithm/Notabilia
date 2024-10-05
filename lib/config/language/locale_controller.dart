import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import '../../main.dart';

class LocalController extends GetxController {
  Locale initialLang = _getInitialLanguage();
  bool isEnglish = _getInitialLanguage().languageCode == 'en' ? true : false;

  static Locale _getInitialLanguage() {
    Locale defaultLocale = const Locale('en');
    String? storedLang = sharedPref!.getString("lang");
    if (storedLang != null) {
      return Locale(storedLang);
    } else {
      Locale deviceLocale = Get.deviceLocale!;

      if (deviceLocale.languageCode == 'ar' || deviceLocale.languageCode == 'en') {
        return deviceLocale;
      } else {
        return defaultLocale;
      }
    }
  }

  void changeLang(String codeLang) {
    Locale locale = Locale(codeLang);
    sharedPref!.setString("lang", codeLang);
    Get.updateLocale(locale);
    isEnglish = locale.languageCode == 'en' ? true : false;
  }
}
