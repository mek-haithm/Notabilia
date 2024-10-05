import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:notabilia/config/language/locale_controller.dart';
import 'package:notabilia/features/settings/screens/confirm_backup_screen.dart';
import 'package:notabilia/shared/constants/colors.dart';
import 'package:notabilia/shared/constants/sizes.dart';
import 'package:notabilia/shared/constants/text_styles.dart';
import 'package:notabilia/shared/widgets/my_app_bar.dart';

import '../../../shared/widgets/language_popup.dart';
import '../../notes/screens/index_screen.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          Get.offAll(IndexScreen());
        }
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: kBackground,
          appBar: MyAppBar(title: 'settings'.tr),
          body: Padding(
            padding: const EdgeInsets.only(
              left: 20.0,
              right: 20.0,
              top: 20.0,
            ),
            child: Column(
              children: [
                kSizedBoxHeight_20,
                Align(
                  alignment: LocalController().isEnglish
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: Text(
                    'language'.tr,
                    style: kInactiveTextStyle(context),
                  ),
                ),
                const Divider(
                  color: Colors.grey,
                ),
                ListTile(
                  splashColor: Colors.transparent,
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => const LanguagePopup(),
                    );
                  },
                  leading: const Icon(
                    Iconsax.language_circle,
                    color: kMainColor,
                  ),
                  title: Text(
                    'language'.tr,
                    style: kMediumTextStyle(context),
                  ),
                ),
                kSizedBoxHeight_10,
                Align(
                  alignment: LocalController().isEnglish
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: Text(
                    'backup'.tr,
                    style: kInactiveTextStyle(context),
                  ),
                ),
                const Divider(
                  color: Colors.grey,
                ),
                ListTile(
                  splashColor: Colors.transparent,
                  onTap: () async {
                    Get.to(
                      ConfirmBackupScreen(isBackup: true),
                    );
                  },
                  leading: const Icon(
                    Icons.backup_outlined,
                    color: kMainColor,
                  ),
                  title: Text(
                    'saveNotes'.tr,
                    style: kMediumTextStyle(context),
                  ),
                ),
                ListTile(
                  splashColor: Colors.transparent,
                  onTap: () {
                    Get.to(
                      ConfirmBackupScreen(isBackup: false),
                    );
                  },
                  leading: const Icon(
                    Icons.restore_outlined,
                    color: kMainColor,
                  ),
                  title: Text(
                    'restoreNotes'.tr,
                    style: kMediumTextStyle(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
