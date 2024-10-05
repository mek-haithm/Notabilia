import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/widgets/my_snack_bar.dart';
import '../../config/language/locale_controller.dart';
import '../constants/colors.dart';
import '../constants/sizes.dart';
import '../constants/text_styles.dart';

class LanguagePopup extends StatefulWidget {
  const LanguagePopup({super.key});

  @override
  State<LanguagePopup> createState() => _LanguagePopupState();
}

class _LanguagePopupState extends State<LanguagePopup> {
  final LocalController controllerLang = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
      decoration: const BoxDecoration(
        color: kBackground,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40.0,
              height: 7.0,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          kSizedBoxHeight_15,
          Text(
            'selectLanguage'.tr,
            style: kLargeTextStyle(context),
          ),
          kSizedBoxHeight_5,
          const Divider(
            color: kMainColor,
          ),
          _buildLanguageOption('arabic'.tr, 'ar'),
          _buildLanguageOption('english'.tr, 'en'),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(String languageName, String languageCode) {
    return ListTile(
      title: Text(
        languageName,
        style: kSmallBoldTextStyle(context),
      ),
      onTap: () {
        setState(() {
          controllerLang.changeLang(languageCode);
        });
        Get.back();
        MySnackBar.showSnackBar(
          message: 'languageChanged'.tr,
        );
      },
    );
  }
}
