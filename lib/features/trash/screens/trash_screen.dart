import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:notabilia/features/notes/screens/index_screen.dart';
import 'package:notabilia/shared/widgets/my_snack_bar.dart';

import '../../../databases/database_helper.dart';
import '../../../shared/alerts/my_message.dart';
import '../../../shared/constants/colors.dart';
import '../../../shared/constants/sizes.dart';
import '../../../shared/constants/text_styles.dart';
import '../../../shared/widgets/my_app_bar.dart';
import '../../../shared/widgets/my_progress_indicator.dart';
import '../../../shared/widgets/my_text_field.dart';
import '../../../shared/widgets/note_box.dart';
import '../../notes/models/note.dart';
import '../../notes/screens/view_note_screen.dart';

class TrashScreen extends StatefulWidget {
  const TrashScreen({
    super.key,
  });

  @override
  State<TrashScreen> createState() => _TrashScreenState();
}

class _TrashScreenState extends State<TrashScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  late Future<List<Note>> _notesFuture;
  List<Note> _allNotes = [];
  List<Note> _filteredNotes = [];

  @override
  void initState() {
    super.initState();
    _notesFuture = DatabaseHelper().getAllTrashNotes();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  _onSearchChanged() {
    setState(() {
      String searchText = _searchController.text;
      _filteredNotes = _allNotes
          .where((note) =>
              note.title.toLowerCase().contains(searchText.toLowerCase()) ||
              note.content.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
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
        appBar: MyAppBar(
          title: 'trash'.tr,
          actionWidget: PopupMenuButton<String>(
            icon: const Icon(
              Iconsax.more,
              color: kMainColor,
            ),
            color: kBackground,
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                value: 'restoreAll'.tr,
                child: Text(
                  'restoreAll'.tr,
                  style: _filteredNotes.isNotEmpty || _allNotes.isNotEmpty
                      ? kSmallTextStyle(context)
                      : kInactiveTextStyle(context),
                ),
              ),
              PopupMenuItem<String>(
                value: 'emptyTrash'.tr,
                child: Text(
                  'emptyTrash'.tr,
                  style: _filteredNotes.isNotEmpty || _allNotes.isNotEmpty
                      ? kSmallTextStyle(context)
                      : kInactiveTextStyle(context),
                ),
              ),
            ],
            onSelected: (String value) async {
              if (value == "restoreAll".tr) {
                if (_filteredNotes.isNotEmpty || _allNotes.isNotEmpty) {
                  MyMessage.showMyMessage(
                    context: context,
                    message: 'confirmRestore'.tr,
                    firstButton: 'cancel'.tr,
                    onFirstButtonPressed: () {
                      Get.back();
                    },
                    secondButton: 'ok'.tr,
                    onSecondButtonPressed: () async {
                      Get.back();
                      MySnackBar.showSnackBar(message: 'trashRestored'.tr);
                      await _databaseHelper.restoreTrash();
                      Get.offUntil(
                        MaterialPageRoute(
                            builder: (context) => const TrashScreen()),
                        (route) => route.isFirst,
                      );
                    },
                    isDismissible: false,
                  );
                }
              } else if (value == "emptyTrash".tr) {
                if (_filteredNotes.isNotEmpty || _allNotes.isNotEmpty) {
                  MyMessage.showMyMessage(
                    context: context,
                    message: 'confirmEmpty'.tr,
                    firstButton: 'cancel'.tr,
                    onFirstButtonPressed: () {
                      Get.back();
                    },
                    secondButton: 'ok'.tr,
                    onSecondButtonPressed: () async {
                      Get.back();
                      MySnackBar.showSnackBar(message: 'trashEmptied'.tr);
                      await _databaseHelper.emptyTrash();
                      Get.offUntil(
                        MaterialPageRoute(
                            builder: (context) => const TrashScreen()),
                        (route) => route.isFirst,
                      );
                    },
                    isDismissible: false,
                  );
                }
              }
            },
          ),
        ),
        backgroundColor: kBackground,
        body: Padding(
          padding: const EdgeInsets.only(
            left: 10.0,
            right: 10.0,
            top: 15.0,
          ),
          child: Column(
            children: [
              MyTextField(
                hintText: 'searchNotes'.tr,
                controller: _searchController,
                icon: Iconsax.search_normal,
              ),
              kSizedBoxHeight_20,
              Expanded(
                child: FutureBuilder<List<Note>>(
                  future: _notesFuture,
                  builder: (context, snapshot) {
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
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Iconsax.trash,
                            color: Colors.grey,
                            size: 100.0,
                          ),
                          kSizedBoxHeight_20,
                          Text(
                            textAlign: TextAlign.center,
                            'noTrashNotes'.tr,
                            style: kInactiveTextStyle(context),
                          )
                        ],
                      );
                    } else {
                      _allNotes = snapshot.data!;
                      if (_searchController.text.isEmpty) {
                        _filteredNotes = _allNotes;
                      }
                      _allNotes = snapshot.data!;
                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15.0,
                          mainAxisSpacing: 10.0,
                        ),
                        itemCount: _filteredNotes.length,
                        itemBuilder: (context, index) {
                          final note = _filteredNotes[index];
                          return NoteBox(
                            onTap: () {
                              if (note.password != '') {
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
                                              style: kButtonAlertTextStyle(
                                                  context),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            if (_passwordController
                                                    .text.isNotEmpty ||
                                                _passwordController.text !=
                                                    '') {
                                              if (_passwordController.text ==
                                                  note.password) {
                                                Get.back();
                                                Get.to(ViewNoteScreen(
                                                  note: note,
                                                  readOnly: true,
                                                  isTrash: true,
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
                                              style: kButtonAlertTextStyle(
                                                  context),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                Get.to(ViewNoteScreen(
                                  note: note,
                                  readOnly: true,
                                  isTrash: true,
                                ));
                              }
                            },
                            title: note.title,
                            content: note.password != ''
                                ? 'thisNoteHasPassword'.tr
                                : note.content,
                            dateAndTime: note.updatedAt.toString(),
                            colorIndex: note.colorIndex,
                            isFavorite: note.isFavorite,
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
