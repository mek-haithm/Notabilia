import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:notabilia/features/folders/screens/add_note_for_folder_screen.dart';
import 'package:notabilia/features/folders/screens/view_note_for_folder_screen.dart';
import 'package:notabilia/features/notes/screens/index_screen.dart';
import '../../../databases/database_helper.dart';
import '../../../shared/alerts/my_message.dart';
import '../../../shared/constants/colors.dart';
import '../../../shared/constants/sizes.dart';
import '../../../shared/constants/text_styles.dart';
import '../../../shared/widgets/my_app_bar.dart';
import '../../../shared/widgets/my_progress_indicator.dart';
import '../../../shared/widgets/my_snack_bar.dart';
import '../../../shared/widgets/my_text_field.dart';
import '../../../shared/widgets/note_box.dart';
import '../../notes/models/note.dart';

class FolderScreen extends StatefulWidget {
  final int folderId;
  final String folderName;
  final String password;
  const FolderScreen({
    super.key,
    required this.folderId,
    required this.folderName,
    this.password = '',
  });

  @override
  State<FolderScreen> createState() => _FolderScreenState();
}

class _FolderScreenState extends State<FolderScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final DatabaseHelper _databaseHelper = DatabaseHelper();

  late Future<List<Note>> _notesFuture;
  List<Note> _allNotes = [];
  List<Note> _filteredNotes = [];
  @override
  void initState() {
    super.initState();
    _notesFuture = DatabaseHelper().getNotesForFolder(widget.folderId);
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
          Get.offAll(IndexScreen(
            index: 1,
          ));
        }
      },
      child: Scaffold(
        appBar: MyAppBar(
          title: widget.folderName,
          actionWidget: PopupMenuButton<String>(
            icon: const Icon(
              Iconsax.more,
              color: kMainColor,
            ),
            color: kBackground,
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                value: 'setPassword'.tr,
                child: Text(
                  'setPassword'.tr,
                  style: kSmallTextStyle(context),
                ),
              ),
              PopupMenuItem<String>(
                value: 'deleteFolder'.tr,
                child: Text(
                  'deleteFolder'.tr,
                  style: kSmallTextStyle(context),
                ),
              ),
            ],
            onSelected: (String value) async {
              if (value == "setPassword".tr) {
                showDialog(
                  context: context,
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
                          onTap: () async {
                            if (_passwordController.text.contains(' ')) {
                              MyMessage.showWarningMessage(
                                context,
                                'cannotHaveSpaces'.tr,
                              );
                            } else {
                              await _databaseHelper.updateFolderPassword(
                                _passwordController.text,
                                widget.folderId,
                              );
                              Get.back();
                              MySnackBar.showSnackBar(
                                  message: 'passwordSet'.tr);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'save'.tr,
                              style: kButtonAlertTextStyle(context),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              } else if (value == "deleteFolder".tr) {
                MyMessage.showMyMessage(
                  context: context,
                  message: 'confirmFolderDelete'.tr,
                  firstButton: 'cancel'.tr,
                  onFirstButtonPressed: () {
                    Get.back();
                  },
                  secondButton: 'ok'.tr,
                  onSecondButtonPressed: () async {
                    int id =
                        await _databaseHelper.deleteFolder(widget.folderId);
                    if (id == -1) {
                      MySnackBar.showSnackBar(
                        message: 'somethingWrongHappened'.tr,
                      );
                    } else {
                      Get.off(IndexScreen(
                        index: 1,
                      ));
                      MySnackBar.showSnackBar(
                        message: 'folderDeleted'.tr,
                      );
                    }
                  },
                  isDismissible: true,
                );
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
                            Iconsax.note_2,
                            color: Colors.grey,
                            size: 100.0,
                          ),
                          kSizedBoxHeight_20,
                          Text(
                            textAlign: TextAlign.center,
                            'noNotes'.tr,
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
                                                Get.off(ViewNoteForFolderScreen(
                                                  note: note,
                                                  folderId: widget.folderId,
                                                  folderName: widget.folderName,
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
                                Get.off(ViewNoteForFolderScreen(
                                  note: note,
                                  folderId: widget.folderId,
                                  folderName: widget.folderName,
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
                            icon: note.isFavorite
                                ? Iconsax.heart5
                                : Iconsax.heart,
                            onFavoritePressed: () async {
                              await _databaseHelper.toggleFavorite(note);
                              MySnackBar.showSnackBar(
                                  message: "noteAddedToFavorites".tr);
                              setState(() {});
                            },
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.off(
              AddNoteForFolderScreen(
                folderId: widget.folderId,
                folderName: widget.folderName,
              ),
            );
          },
          backgroundColor: kMainColor,
          child: const Icon(
            Iconsax.note_add,
            color: kBackground,
          ),
        ),
      ),
    );
  }
}
