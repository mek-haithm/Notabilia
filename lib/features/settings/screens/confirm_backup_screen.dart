import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notabilia/shared/constants/colors.dart';
import 'package:notabilia/shared/constants/sizes.dart';
import 'package:notabilia/shared/constants/text_styles.dart';
import 'package:notabilia/shared/widgets/my_button.dart';

import '../../../config/language/locale_controller.dart';
import '../../../databases/database_helper.dart';

class ConfirmBackupScreen extends StatelessWidget {
  final bool isBackup;
  ConfirmBackupScreen({
    super.key,
    required this.isBackup,
  });

  final _databaseHelper = DatabaseHelper();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kBackground,
        body: Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 20.0,
            top: 20.0,
          ),
          child: isBackup
              ? Column(
                  children: [
                    kSizedBoxHeight_40,
                    Align(
                      alignment: LocalController().isEnglish
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: Wrap(
                        children: [
                          Text(
                            'instruction1'.tr,
                            style: kMediumTextStyle(context),
                          ),
                          Container(
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                            ),
                            child: SelectableText(
                              "'.db'",
                              style: kSmallTextStyle(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                    kSizedBoxHeight_20,
                    Align(
                      alignment: LocalController().isEnglish
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: Wrap(
                        children: [
                          Text(
                            'instruction2'.tr,
                            style: kMediumTextStyle(context),
                          ),
                          Container(
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                            ),
                            child: SelectableText(
                              "'notabilia_backup.db'",
                              style: kSmallTextStyle(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                    kSizedBoxHeight_20,
                    Align(
                      alignment: LocalController().isEnglish
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: Text(
                        'instruction3'.tr,
                        style: kMediumTextStyle(context),
                      ),
                    ),
                    kSizedBoxHeight_20,
                    Align(
                      alignment: LocalController().isEnglish
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: Text(
                        'instruction4'.tr,
                        style: kMediumTextStyle(context),
                      ),
                    ),
                    kSizedBoxHeight_20,
                    Align(
                      alignment: LocalController().isEnglish
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: Text(
                        'instruction5'.tr,
                        style: kMediumTextStyle(context),
                      ),
                    ),
                    kSizedBoxHeight_20,
                    Align(
                      alignment: LocalController().isEnglish
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: Text(
                        'instruction6'.tr,
                        style: kMediumTextStyle(context),
                      ),
                    ),
                    kSizedBoxHeight_20,
                    Align(
                      alignment: LocalController().isEnglish
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: Text(
                        'instruction7'.tr,
                        style: kMediumTextStyle(context),
                      ),
                    ),
                    kSizedBoxHeight_20,
                    Align(
                      alignment: LocalController().isEnglish
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: Text(
                        'instruction8'.tr,
                        style: kMediumTextStyle(context),
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    kSizedBoxHeight_40,
                    Align(
                      alignment: LocalController().isEnglish
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: Text(
                        'restore1'.tr,
                        style: kMediumTextStyle(context),
                      ),
                    ),
                    kSizedBoxHeight_20,
                    Align(
                      alignment: LocalController().isEnglish
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: Text(
                        'restore2'.tr,
                        style: kMediumTextStyle(context),
                      ),
                    ),
                    kSizedBoxHeight_20,
                    Align(
                      alignment: LocalController().isEnglish
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: Text(
                        'restore3'.tr,
                        style: kMediumTextStyle(context),
                      ),
                    ),
                    kSizedBoxHeight_20,
                    Align(
                      alignment: LocalController().isEnglish
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: Text('warning'.tr,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red[900],
                            fontSize: 17.0,
                            fontFamily: 'ibmFont',
                          )),
                    ),
                    kSizedBoxHeight_5,
                    Align(
                      alignment: LocalController().isEnglish
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: Text('restore4'.tr,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red[900],
                            fontSize: 17.0,
                            fontFamily: 'ibmFont',
                          )),
                    ),
                  ],
                ),
        ),
        bottomNavigationBar: isBackup
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  kSizedBoxHeight_5,
                  MyButton(
                    text: 'backup'.tr,
                    onPressed: () async {
                      await _databaseHelper.backupDatabase();
                    },
                  ),
                  kSizedBoxHeight_5
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  kSizedBoxHeight_5,
                  MyButton(
                    text: 'restoreNotes'.tr,
                    onPressed: () async {
                      await _databaseHelper.restoreDatabase();
                    },
                  ),
                  kSizedBoxHeight_5
                ],
              ),
      ),
    );
  }
}
