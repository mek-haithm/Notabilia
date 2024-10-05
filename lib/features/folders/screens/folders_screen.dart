import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:notabilia/databases/database_helper.dart';
import 'package:notabilia/features/folders/models/folder.dart';
import 'package:notabilia/features/folders/screens/folder_screen.dart';
import 'package:notabilia/features/notes/screens/index_screen.dart';
import 'package:notabilia/features/trash/screens/trash_screen.dart';
import 'package:notabilia/shared/alerts/my_message.dart';
import 'package:notabilia/shared/constants/colors.dart';
import 'package:notabilia/shared/widgets/my_app_bar.dart';
import 'package:notabilia/shared/widgets/my_progress_indicator.dart';
import 'package:notabilia/shared/widgets/my_snack_bar.dart';
import 'package:notabilia/shared/widgets/my_text_field.dart';
import '../../../shared/constants/sizes.dart';
import '../../../shared/constants/text_styles.dart';
import '../../favorites/screens/favorites_screen.dart';
import '../../settings/screens/settings_screen.dart';

class FoldersScreen extends StatefulWidget {
  const FoldersScreen({super.key});

  @override
  State<FoldersScreen> createState() => _FoldersScreenState();
}

class _FoldersScreenState extends State<FoldersScreen> {
  late Future<List<Folder>> _foldersFuture;
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _folderNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    _foldersFuture = _databaseHelper.getFolders();
    super.initState();
  }

  @override
  void dispose() {
    _folderNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          Get.offAll(IndexScreen());
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: kBackground,
        appBar: MyAppBar(
          title: 'folders'.tr,
          leadingWidget: IconButton(
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            icon: const Icon(
              Icons.menu,
              color: kMainColor,
            ),
          ),
        ),
        drawer: Drawer(
          backgroundColor: kMainColorDark,
          child: ListView(
            padding: const EdgeInsets.all(20.0),
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: kMainColorDark,
                ),
                child: Center(
                  child: Text(
                    'notabilia'.tr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: "ibmFont",
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(
                  Iconsax.heart,
                  color: kBackground,
                ),
                title: Text(
                  'favorites'.tr,
                  style: kButtonTextStyle(context),
                ),
                onTap: () {
                  Get.to(const FavoritesScreen());
                },
              ),
              ListTile(
                leading: const Icon(
                  Iconsax.trash,
                  color: kBackground,
                ),
                title: Text(
                  'trash'.tr,
                  style: kButtonTextStyle(context),
                ),
                onTap: () {
                  Get.to(const TrashScreen());
                },
              ),
              ListTile(
                leading: const Icon(
                  Iconsax.settings,
                  color: kBackground,
                ),
                title: Text(
                  'settings'.tr,
                  style: kButtonTextStyle(context),
                ),
                onTap: () {
                  Get.to(SettingsScreen());
                },
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(
            left: 10.0,
            right: 10.0,
            top: 15.0,
          ),
          child: FutureBuilder<List<Folder>>(
            future: _foldersFuture,
            builder:
                (BuildContext context, AsyncSnapshot<List<Folder>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: MyProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'somethingWrongHappened'.tr,
                    style: kSmallTextStyle(context),
                  ),
                );
              } else if (snapshot.data!.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Iconsax.folder,
                        color: Colors.grey,
                        size: 100.0,
                      ),
                      kSizedBoxHeight_20,
                      Text(
                        textAlign: TextAlign.center,
                        'noFolders'.tr,
                        style: kInactiveTextStyle(context),
                      )
                    ],
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: GestureDetector(
                        onTap: () {
                          if (snapshot.data![index].password.isNotEmpty ||
                              snapshot.data![index].password != '') {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: kBackground,
                                  title: Text(
                                    'enterPassword'.tr,
                                    style: kMediumTextStyle(context),
                                  ),
                                  content: MyTextField(
                                    hintText: 'enterPassword'.tr,
                                    controller: _passwordController,
                                  ),
                                  actions: <Widget>[
                                    InkWell(
                                      onTap: () {
                                        Get.back();
                                        _passwordController.clear();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          'cancel'.tr,
                                          style: kButtonAlertTextStyle(context),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        if (_passwordController
                                                .text.isNotEmpty ||
                                            _passwordController.text != '') {
                                          if (_passwordController.text ==
                                              snapshot.data![index].password) {
                                            Get.back();
                                            Get.to(FolderScreen(
                                              folderId:
                                                  snapshot.data![index].id!,
                                              folderName:
                                                  snapshot.data![index].name,
                                              password: snapshot
                                                  .data![index].password,
                                            ));
                                            _passwordController.clear();
                                          } else {
                                            MyMessage.showErrorMessage(
                                              context,
                                              "invalidPassword".tr,
                                            );
                                            _passwordController.clear();
                                          }
                                        } else {
                                          MyMessage.showWarningMessage(
                                              context, 'emptyField'.tr);
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          'ok'.tr,
                                          style: kButtonAlertTextStyle(context),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            Get.to(FolderScreen(
                              folderId: snapshot.data![index].id!,
                              folderName: snapshot.data![index].name,
                              password: snapshot.data![index].password,
                            ));
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: kCardColor,
                            borderRadius: BorderRadius.circular(15.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Row(
                            children: <Widget>[
                              const Icon(
                                Iconsax.folder5,
                                color: kMainColor,
                              ),
                              kSizedBoxWidth_15,
                              Expanded(
                                  child: Row(
                                children: [
                                  Text(
                                    '${snapshot.data![index].name} ',
                                    style: kMediumTextStyle(context),
                                  ),
                                  if (snapshot.data![index].password != '')
                                    const Icon(
                                      Iconsax.lock5,
                                      color: kMainColor,
                                      size: 15.0,
                                    ),
                                ],
                              )),
                              FutureBuilder<int>(
                                future: _databaseHelper.getNoteCountInFolder(
                                    snapshot.data![index].id!),
                                builder: (BuildContext context,
                                    AsyncSnapshot<int> snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Text('0',
                                        style: kInactiveTextStyle(context));
                                  } else {
                                    if (snapshot.hasError) {
                                      return Text('0',
                                          style: kInactiveTextStyle(context));
                                    } else {
                                      return Text(snapshot.data.toString(),
                                          style: kInactiveTextStyle(context));
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: kBackground,
                  title: Text(
                    'enterFolderName'.tr,
                    style: kMediumBoldTextStyle(context),
                  ),
                  content: MyTextField(
                    controller: _folderNameController,
                    hintText: 'folderName'.tr,
                  ),
                  actions: <Widget>[
                    InkWell(
                      onTap: () {
                        Get.back();
                        _passwordController.clear();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'cancel'.tr,
                          style: kButtonAlertTextStyle(context),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (_folderNameController.text.isEmpty) {
                          MyMessage.showWarningMessage(
                            context,
                            'emptyField'.tr,
                          );
                        } else {
                          DateTime now = DateTime.now();
                          String formattedDate =
                              DateFormat('dd-MM-yyyy  HH:mm').format(now);
                          Folder folder = Folder(
                            name: _folderNameController.text,
                            updatedAt: formattedDate,
                          );
                          _databaseHelper.addFolder(folder).then((int id) {
                            if (id == -1) {
                              MySnackBar.showSnackBar(
                                message: 'somethingWrongHappened'.tr,
                              );
                            } else {
                              MySnackBar.showSnackBar(
                                message: 'folderAdded'.tr,
                              );
                              _folderNameController.clear();
                            }
                          });
                          Get.offAll(
                            IndexScreen(index: 1),
                          );
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'addFolder'.tr,
                          style: kButtonAlertTextStyle(context),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
          backgroundColor: kMainColor,
          child: const Icon(
            Iconsax.folder_add,
            color: kBackground,
          ),
        ),
      ),
    );
  }
}
/*

                      */
