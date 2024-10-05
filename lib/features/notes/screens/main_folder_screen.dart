import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:notabilia/features/favorites/screens/favorites_screen.dart';
import 'package:notabilia/features/notes/screens/view_note_screen.dart';
import 'package:notabilia/features/trash/screens/trash_screen.dart';
import 'package:notabilia/shared/alerts/my_message.dart';
import 'package:notabilia/shared/constants/text_styles.dart';
import 'package:notabilia/shared/widgets/my_app_bar.dart';
import 'package:notabilia/shared/widgets/my_snack_bar.dart';
import 'package:notabilia/shared/widgets/my_text_field.dart';
import 'package:notabilia/shared/widgets/note_box.dart';
import '../../../databases/database_helper.dart';
import '../../../shared/constants/colors.dart';
import '../../../shared/constants/sizes.dart';
import '../../../shared/widgets/my_progress_indicator.dart';
import '../../settings/screens/settings_screen.dart';
import '../models/note.dart';
import 'add_note_screen.dart';

class MainFolderScreen extends StatefulWidget {
  const MainFolderScreen({super.key});

  @override
  State<MainFolderScreen> createState() => _MainFolderScreenState();
}

class _MainFolderScreenState extends State<MainFolderScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Future<List<Note>> _notesFuture;
  List<Note> _allNotes = [];
  List<Note> _filteredNotes = [];

  @override
  void initState() {
    super.initState();
    _notesFuture = DatabaseHelper().getNotesForFolder(1);
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
    return Scaffold(
      key: _scaffoldKey,
      appBar: MyAppBar(
        title: 'main'.tr,
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
      backgroundColor: kBackground,
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
                Get.offUntil(
                  MaterialPageRoute(
                      builder: (context) =>
                      const TrashScreen()),
                      (route) => route.isFirst,
                );
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
                                            style:
                                                kButtonAlertTextStyle(context),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          if (_passwordController
                                                  .text.isNotEmpty ||
                                              _passwordController.text != '') {
                                            if (_passwordController.text ==
                                                note.password) {
                                              Get.back();
                                              Get.to(ViewNoteScreen(
                                                note: note,
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
                                            style:
                                                kButtonAlertTextStyle(context),
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
                          icon:
                              note.isFavorite ? Iconsax.heart5 : Iconsax.heart,
                          onFavoritePressed: () async {
                            await _databaseHelper.toggleFavorite(note);
                            if (note.isFavorite) {
                              MySnackBar.showSnackBar(
                                  message: "noteAddedToFavorites".tr);
                            } else {
                              MySnackBar.showSnackBar(
                                  message: "noteRemovedFromFavorites".tr);
                            }
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
          Get.to(const AddNoteScreen());
        },
        backgroundColor: kMainColor,
        child: const Icon(
          Iconsax.note_add,
          color: kBackground,
        ),
      ),
    );
  }
}
