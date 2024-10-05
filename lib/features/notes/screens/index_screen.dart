import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:notabilia/shared/constants/colors.dart';
import '../../../config/language/locale_controller.dart';
import '../../../shared/widgets/my_bottom_nav_bar.dart';
import '../../folders/screens/folders_screen.dart';
import 'main_folder_screen.dart';

class IndexScreen extends StatelessWidget {
  final int index;
  IndexScreen({super.key, this.index = 0});

  final List<IconData> _icons = [
    Iconsax.note5,
    Iconsax.folder5,
  ];

  final List<Widget> _screens = [
    const MainFolderScreen(),
    const FoldersScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kBackground,
        bottomNavigationBar: GetBuilder<LocalController>(
          builder: (controller) {
            final List<String> labels = [
              'notesScreen'.tr,
              'foldersScreen'.tr,
            ];
            return MyBottomNavBar(
              screens: _screens,
              icons: _icons,
              labels: labels,
              initialIndex: index,
            );
          },
        ),
      ),
    );
  }
}
