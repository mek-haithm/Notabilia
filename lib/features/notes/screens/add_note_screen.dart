import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:notabilia/databases/database_helper.dart';
import 'package:notabilia/features/notes/models/note.dart';
import 'package:notabilia/features/notes/screens/index_screen.dart';
import 'package:notabilia/shared/alerts/my_message.dart';
import 'package:notabilia/shared/constants/colors.dart';
import 'package:notabilia/shared/constants/note_colors.dart';
import 'package:notabilia/shared/constants/sizes.dart';
import 'package:notabilia/shared/constants/text_styles.dart';
import 'package:notabilia/shared/widgets/my_button.dart';
import 'package:notabilia/shared/widgets/my_content_text_field.dart';
import 'package:notabilia/shared/widgets/my_snack_bar.dart';
import 'package:notabilia/shared/widgets/my_text_field.dart';
import '../../../shared/widgets/my_app_bar.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  int _selectedColorIndex = 0;
  String password = '';
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    Color selectedColor = NoteColors.colors[_selectedColorIndex];
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(
          title: "addNote".tr,
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
            ],
            onSelected: (String value) {
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
                        onTap: () {
                          if (_passwordController.text.contains(' ')) {
                            MyMessage.showWarningMessage(
                              context,
                              'cannotHaveSpaces'.tr,
                            );
                          } else {
                            password = _passwordController.text;
                            Get.back();
                            MySnackBar.showSnackBar(message: 'passwordSet'.tr);
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
            },
          ),
        ),
        backgroundColor: kBackground,
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 15.0,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: MyTextField(
                      hintText: 'title'.tr,
                      controller: _titleController,
                      color: selectedColor,
                    ),
                  ),
                  kSizedBoxWidth_5,
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: kBackground,
                            content: SizedBox(
                              height: 30,
                              width: double.maxFinite,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: NoteColors.colors.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedColorIndex = index;
                                      });
                                      Navigator.of(context).pop();
                                    },
                                    child: Container(
                                      width: 30,
                                      margin: const EdgeInsets.all(5.0),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: NoteColors.colors[index],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: NoteColors.colors[_selectedColorIndex],
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 1,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              kSizedBoxHeight_20,
              Expanded(
                child: SingleChildScrollView(
                  child: MyContentTextField(
                    hintText: 'content'.tr,
                    controller: _contentController,
                    color: selectedColor,
                  ),
                ),
              ),
              kSizedBoxHeight_20,
              MyButton(
                text: 'save'.tr,
                onPressed: () async {
                  String title = _titleController.text;
                  String content = _contentController.text;
                  DateTime now = DateTime.now();
                  String formattedDate =
                      DateFormat('dd-MM-yyyy  HH:mm').format(now);
                  Note note = Note(
                    title: title,
                    content: content,
                    colorIndex: _selectedColorIndex,
                    password: password,
                    createdAt: formattedDate,
                    updatedAt: formattedDate,
                    folderId: 1,
                  );

                  int id = await _databaseHelper.addNote(note);
                  if (id == -1) {
                    MySnackBar.showSnackBar(
                      message: 'somethingWrongHappened'.tr,
                    );
                  } else {
                    Get.offAll(IndexScreen());
                    MySnackBar.showSnackBar(
                      message: 'noteAdded'.tr,
                    );
                    _titleController.clear();
                    _contentController.clear();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
