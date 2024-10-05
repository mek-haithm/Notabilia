import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/constants/colors.dart';
import '../../../shared/constants/sizes.dart';
import '../../notes/screens/index_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void>.delayed(const Duration(seconds: 3), () {
      Get.off(IndexScreen());
    });

    return Scaffold(
      backgroundColor: kBackground,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          kSizedBoxHeight_5,
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/Notabilia Logo.png',
                  width: 100.0,
                ),
              ),
              kSizedBoxHeight_15,
              Text(
                'notabilia'.tr,
                style: const TextStyle(
                  fontSize: 35.0,
                  fontWeight: FontWeight.w600,
                  color: kMainColor,
                  fontFamily: 'ibmFont',
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
          Column(
            children: [
              Text(
                'notabiliaApp'.tr,
                style: const TextStyle(
                  fontSize: 20.0,
                  color: Colors.grey,
                  fontFamily: 'ibmFont',
                ),
              ),
              kSizedBoxHeight_30,
            ],
          )
        ],
      ),
    );
  }
}
