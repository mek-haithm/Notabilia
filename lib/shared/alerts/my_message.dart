import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notabilia/config/language/locale_controller.dart';
import 'package:notabilia/shared/constants/colors.dart';
import '../constants/sizes.dart';
import '../constants/text_styles.dart';

class MyMessage extends StatefulWidget {
  final String message;
  final String title;
  final String? firstButton;
  final String? secondButton;
  final VoidCallback? onFirstButtonPressed;
  final VoidCallback? onSecondButtonPressed;

  const MyMessage({
    super.key,
    required this.title,
    required this.message,
    this.onFirstButtonPressed,
    this.onSecondButtonPressed,
    this.firstButton,
    this.secondButton,
  });
  static void showErrorMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return MyMessage(
          title: 'error'.tr,
          message: message,
          onFirstButtonPressed: () {
            Navigator.of(dialogContext).pop();
          },
        );
      },
    );
  }

  static void showWarningMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return MyMessage(
          title: 'warning'.tr,
          message: message,
          onFirstButtonPressed: () {
            Navigator.of(dialogContext).pop();
          },
        );
      },
    );
  }

  static void showMyMessage({
    required BuildContext context,
    required String message,
    required String firstButton,
    required VoidCallback onFirstButtonPressed,
    required String secondButton,
    required VoidCallback onSecondButtonPressed,
    required bool isDismissible,
  }) {
    showDialog(
      barrierDismissible: isDismissible,
      context: context,
      builder: (BuildContext dialogContext) {
        return MyMessage(
          title: 'warning'.tr,
          message: message,
          onFirstButtonPressed: onFirstButtonPressed,
          onSecondButtonPressed: onSecondButtonPressed,
          firstButton: firstButton,
          secondButton: secondButton,
        );
      },
    );
  }

  @override
  State<MyMessage> createState() => _MyMessageState();
}

class _MyMessageState extends State<MyMessage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: AlertDialog(
        contentPadding: EdgeInsets.zero,
        backgroundColor: kBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        content: Container(
          width: double.infinity,
          padding: LocalController().isEnglish
              ? const EdgeInsets.only(
                  top: 10.0,
                  bottom: 10.0,
                  right: 15.0,
                  left: 30.0,
                )
              : const EdgeInsets.only(
                  top: 10.0,
                  bottom: 10.0,
                  right: 30.0,
                  left: 15.0,
                ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                children: [
                  kSizedBoxHeight_10,
                  Align(
                    alignment: AlignmentDirectional.topStart,
                    child: Text(
                      widget.title,
                      style: kMessageTitleTextStyle(context),
                    ),
                  ),
                  kSizedBoxHeight_20,
                  Align(
                    alignment: AlignmentDirectional.topStart,
                    child: Text(
                      widget.message,
                      style: kMessageAlertTextStyle(context),
                    ),
                  ),
                ],
              ),
              kSizedBoxHeight_10,
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (widget.onFirstButtonPressed != null)
                        InkWell(
                          onTap: () {
                            widget.onFirstButtonPressed!();
                          },
                          child: SizedBox(
                            width: 40.0,
                            height: 25.0,
                            child: Center(
                              child: Text(
                                widget.firstButton ?? 'cancel'.tr,
                                style: kButtonAlertTextStyle(context),
                              ),
                            ),
                          ),
                        ),
                      kSizedBoxWidth_5,
                      if (widget.onSecondButtonPressed != null)
                        InkWell(
                          onTap: () {
                            widget.onSecondButtonPressed!();
                          },
                          child: SizedBox(
                            width: 40.0,
                            height: 25.0,
                            child: Center(
                              child: Text(
                                widget.secondButton ?? 'ok'.tr,
                                style: kButtonAlertTextStyle(context),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
