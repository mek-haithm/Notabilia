import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:notabilia/features/trash/screens/trash_screen.dart';
import '../../../databases/database_helper.dart';
import '../../../shared/alerts/my_message.dart';
import '../../../shared/constants/colors.dart';
import '../../../shared/constants/note_colors.dart';
import '../../../shared/constants/sizes.dart';
import '../../../shared/constants/text_styles.dart';
import '../../../shared/widgets/my_app_bar.dart';
import '../../../shared/widgets/my_button.dart';
import '../../../shared/widgets/my_content_text_field.dart';
import '../../../shared/widgets/my_snack_bar.dart';
import '../../../shared/widgets/my_text_field.dart';
import '../models/note.dart';
import 'index_screen.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;

class ViewNoteScreen extends StatefulWidget {
  final Note note;
  final bool readOnly;
  final bool isTrash;
  const ViewNoteScreen({
    super.key,
    required this.note,
    this.readOnly = false,
    this.isTrash = false,
  });

  @override
  State<ViewNoteScreen> createState() => _ViewNoteScreenState();
}

class _ViewNoteScreenState extends State<ViewNoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  int _selectedColorIndex = 0;
  String password = '';
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  bool isArabic(String text) {
    final arabicRegex = RegExp(r'[\u0600-\u06FF]');
    return arabicRegex.hasMatch(text);
  }

  @override
  void initState() {
    _titleController.text = widget.note.title;
    _contentController.text = widget.note.content;
    _passwordController.text = widget.note.password!;
    _selectedColorIndex = widget.note.colorIndex;
    password = widget.note.password!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color selectedColor = NoteColors.colors[_selectedColorIndex];
    return SafeArea(
        child: Scaffold(
          appBar: MyAppBar(
            title: '',
            actionWidget: widget.readOnly == false
                ? PopupMenuButton<String>(
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
                        value: 'exportToFile'.tr,
                        child: Text(
                          'exportToFile'.tr,
                          style: kSmallTextStyle(context),
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'moveToTrash'.tr,
                        child: Text(
                          'moveToTrash'.tr,
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
                                  onTap: () {
                                    if (_passwordController.text
                                        .contains(' ')) {
                                      MyMessage.showWarningMessage(
                                        context,
                                        'cannotHaveSpaces'.tr,
                                      );
                                    } else {
                                      password = _passwordController.text;
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
                      } else if (value == "exportToFile".tr) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: kBackground,
                              title: Text(
                                'exportToFile'.tr,
                                style: kMediumTextStyle(context),
                              ),
                              actions: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        String title = _titleController.text;
                                        String content =
                                            _contentController.text;
                                        // Reverse the Arabic text
                                        if (isArabic(content)) {
                                          content = content
                                              .split('')
                                              .reversed
                                              .join('');
                                        }
                                        String? directoryPath = await FilePicker
                                            .platform
                                            .getDirectoryPath();

                                        if (directoryPath != null) {
                                          File file =
                                              File('$directoryPath/$title.txt');
                                          await file.writeAsString(content,
                                              encoding: utf8);
                                          MySnackBar.showSnackBar(
                                              message: 'fileSaved'.tr);
                                        } else {
                                          // User canceled the picker
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            const Icon(
                                              Iconsax.document,
                                              color: kMainColor,
                                            ),
                                            kSizedBoxHeight_10,
                                            Text(
                                              'textFile'.tr,
                                              style:
                                                  kSelectedLabelStyle(context),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    kSizedBoxWidth_20,
                                    InkWell(
                                      onTap: () async {
                                        String title = _titleController.text;
                                        String content =
                                            _contentController.text;
                                        // Reverse the Arabic text
                                        if (isArabic(content)) {
                                          content = content
                                              .split('')
                                              .reversed
                                              .join('');
                                        }
                                        final pdf = pw.Document();

                                        List<String> lines =
                                            content.split('\n');

                                        final font = pw.Font.ttf(
                                            await rootBundle.load(
                                                "assets/fonts/arial.ttf"));

                                        pdf.addPage(pw.Page(
                                          build: (pw.Context context) =>
                                              pw.Column(
                                            children: lines
                                                .map((line) => pw.Text(
                                                      line,
                                                      style: pw.TextStyle(
                                                          fontSize: 16,
                                                          font: font),
                                                      textAlign: isArabic(line)
                                                          ? pw.TextAlign.right
                                                          : pw.TextAlign.left,
                                                    ))
                                                .toList(),
                                          ),
                                        ));

                                        String? directoryPath = await FilePicker
                                            .platform
                                            .getDirectoryPath();
                                        if (directoryPath != null) {
                                          File file =
                                              File('$directoryPath/$title.pdf');
                                          await file
                                              .writeAsBytes(await pdf.save());
                                          MySnackBar.showSnackBar(
                                              message: 'fileSaved'.tr);
                                        } else {
                                          // User canceled the picker
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            const Icon(
                                              Iconsax.document_text,
                                              color: kMainColor,
                                            ),
                                            kSizedBoxHeight_10,
                                            Text(
                                              'pdfFile'.tr,
                                              style:
                                                  kSelectedLabelStyle(context),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            );
                          },
                        );
                      } else if (value == "moveToTrash".tr) {
                        MyMessage.showMyMessage(
                          context: context,
                          message: 'confirmNoteMoveToTrash'.tr,
                          firstButton: 'cancel'.tr,
                          onFirstButtonPressed: () {
                            Get.back();
                          },
                          secondButton: 'ok'.tr,
                          onSecondButtonPressed: () async {
                            int id = await _databaseHelper
                                .moveNoteToTrash(widget.note.id!);
                            if (id == -1) {
                              MySnackBar.showSnackBar(
                                message: 'somethingWrongHappened'.tr,
                              );
                            } else {
                              Get.offAll(IndexScreen());
                              MySnackBar.showSnackBar(
                                message: 'movedToTrash'.tr,
                              );
                            }
                          },
                          isDismissible: true,
                        );
                      }
                    },
                  )
                : widget.isTrash
                    ? PopupMenuButton<String>(
                        icon: const Icon(
                          Iconsax.more,
                          color: kMainColor,
                        ),
                        color: kBackground,
                        itemBuilder: (context) => [
                          PopupMenuItem<String>(
                            value: 'restoreNote'.tr,
                            child: Text(
                              'restoreNote'.tr,
                              style: kSmallTextStyle(context),
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'deleteNote'.tr,
                            child: Text(
                              'deleteNote'.tr,
                              style: kSmallTextStyle(context),
                            ),
                          ),
                        ],
                        onSelected: (String value) async {
                          if (value == "restoreNote".tr) {
                            MyMessage.showMyMessage(
                              context: context,
                              message: 'confirmRestoreNote'.tr,
                              firstButton: 'cancel'.tr,
                              onFirstButtonPressed: () {
                                Get.back();
                              },
                              secondButton: 'ok'.tr,
                              onSecondButtonPressed: () async {
                                int id = await _databaseHelper
                                    .restoreNote(widget.note.id!);
                                if (id == -1) {
                                  MySnackBar.showSnackBar(
                                    message: 'somethingWrongHappened'.tr,
                                  );
                                } else {
                                  Get.offUntil(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const TrashScreen()),
                                    (route) => route.isFirst,
                                  );
                                  MySnackBar.showSnackBar(
                                    message: 'noteRestored'.tr,
                                  );
                                }
                              },
                              isDismissible: true,
                            );
                          } else if (value == "deleteNote".tr) {
                            MyMessage.showMyMessage(
                              context: context,
                              message: 'confirmNoteDelete'.tr,
                              firstButton: 'cancel'.tr,
                              onFirstButtonPressed: () {
                                Get.back();
                              },
                              secondButton: 'ok'.tr,
                              onSecondButtonPressed: () async {
                                int id = await _databaseHelper
                                    .deleteNote(widget.note.id!);
                                if (id == -1) {
                                  MySnackBar.showSnackBar(
                                    message: 'somethingWrongHappened'.tr,
                                  );
                                } else {
                                  Get.offUntil(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const TrashScreen()),
                                    (route) => route.isFirst,
                                  );
                                  MySnackBar.showSnackBar(
                                    message: 'noteDeleted'.tr,
                                  );
                                }
                              },
                              isDismissible: true,
                            );
                          }
                        },
                      )
                    : null,
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
                        readOnly: widget.readOnly,
                      ),
                    ),
                    kSizedBoxWidth_5,
                    if (widget.readOnly == false)
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
                                    itemBuilder:
                                        (BuildContext context, int index) {
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
                      readOnly: widget.readOnly,
                    ),
                  ),
                ),
                kSizedBoxHeight_20,
                if (widget.readOnly == false)
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
                        updatedAt: formattedDate,
                      );

                      int id = await _databaseHelper.updateNote(
                          widget.note.id!, note);
                      if (id == -1) {
                        MySnackBar.showSnackBar(
                          message: 'somethingWrongHappened'.tr,
                        );
                      } else {
                        Get.offAll(IndexScreen());
                        MySnackBar.showSnackBar(
                          message: 'noteUpdated'.tr,
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
