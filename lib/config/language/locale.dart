import 'package:get/get.dart';

class MyLocale implements Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        "ar": {
          // my message
          "cancel": "إلغاء",
          "ok": "موافق",
          "error": "خطأ!",
          "warning": "تنبيه",
          "emptyFieldsWarning": "يجب ملء جميع الحقول لحفظ المذكرة!",
          "emptyField": "يجب ملء الحقل للمواصلة!",
          "emptyTitleWarning":
              "لا يمكن أن يكون حقل الموضوع فارغًا، يرجى إدخال موضوع للمفكرة لمتابعة الجفظ",
          "emptyContentWarning":
              "لا يمكن أن يكون حقل المحتوى فارغًا، يرجى إدخال مجتوى للمفكرة لمتابعة الجفظ",
          "invalidPassword": "كلمة مرور خاطئة. حاول مرة أخرى.",
          "cannotHaveSpaces": "كلمة المرور لا يمكن أن تحتوي على مسافات.",
          "confirmNoteMoveToTrash":
              "هل أنت متأكد من نقل هذه المذكرة الى سلة المهملات؟",
          "confirmNoteDelete": "هل أنت متأكد من حذف هذه المذكرة نهائيًا؟",
          "confirmFolderDelete":
              "هل أنت متأكد من حذف هذا المجلد، وكل المذكرات الخاصة به؟",
          "confirmEmpty": "هل أنت متأكد أنك تريد إفراغ سلة المهملات؟",
          "confirmRestore": "هل أنت متأكد أنك تريد استعادة كل المذكرات؟",
          "confirmRestoreNote": "هل أنت متأكد من استعادة هذه المذكرة؟",

          // my snack bar
          "languageChanged": "تم تغيير اللغة.",
          "noteAdded": "تم إضافة المذكرة.",
          "noteUpdated": "تم تعديل المذكرة.",
          "passwordSet": "تم تعيين كلمة مرور.",
          "movedToTrash": "تم نقل هذه المذكرة الى سلة المهملات.",
          "fileSaved": "تم حفظ الملف.",
          "noteAddedToFavorites": "تم اضافة المذكرة الى المفضلة.",
          "noteRemovedFromFavorites": "تم إزالة المذكرى من المفضلة.",
          "noEditeFavorite": "لا يمكن تعديل المذكرة أثناء التصفح في المفضلة.",
          "trashEmptied": "تم إفراغ سلة المهملات.",
          "trashRestored": "تم إستعادة كل المذكرات.",
          "noteDeleted": "تم حذف هذه المذكرة.",
          "noteRestored": "تم إستعادة هذه المذكرة.",

          // splash screen
          "notabilia": "دَوِّن",
          "notabiliaApp": "تطبيق دَوِّن - مفكرة",

          // main screen
          "notesScreen": "المذكرات",
          "foldersScreen": "المجلدات",

          // notes screen
          "main": "الرئيسية",
          "searchNotes": "بحث عن المذكرات..",
          "somethingWrongHappened": "حدث خطأ غير متوقع.",
          "noNotes": "لا يوجد مذكرات حاليًا. اضغط على زر ‘+’ للإنشاء.",
          "thisNoteHasPassword": "هذه المذكرة محمية بكلمة مرور.",

          // folders screen
          "folders": "المجلدات",
          "noFolders": "لا يوجد مجلدات حاليًا. اضغط على زر ‘+’ للإنشاء.",
          "enterFolderName": "أدخل اسم المجلد",
          "folderName": "اسم المجلد",
          "addFolder": "إضافة مجلد",
          "folderAdded": "تم إضافة المجلد بنجاح.",

          // folder screen
          "deleteFolder": "حذف المجلد",
          "folderDeleted": "تم حذف المجلد بنجاح",

          // add note screen
          "addNote": "اضافة مذكرة",
          "title": "موضوع المذكرة",
          "content": "محتوى المذكرة",
          "save": "حفظ",
          "setPassword": "تعيين كلمة مرور",
          "enterPassword": "أدخل كلمة مرور.",

          // view note screen
          "exportToFile": "التصدير لملف",
          "deleteNote": "حذف المذكرة",
          "moveToTrash": "نقل الى سلة المهملات",
          "textFile": "ملف نصي",
          "pdfFile": "ملف PDF",
          "restoreNote": "إستعادة المذكرة",

          // trash screen
          "noTrashNotes": "لا يوجد أي مذكرات في سلة المهملات.",
          "emptyTrash": "إفراغ سلة المهملات",
          "restoreAll": "إستعادة الكل",

          // favorites screen
          "noFavoriteNotes": "لا يوجد أي مذكرات في المفضلة.",

          // drawer
          "settings": "الإعدادات",
          "favorites": "المفضلة",
          "trash": "سلة المهملات",

          // settings screen
          "language": "اللغة",
          "arabic": "العربية",
          "english": "الإنجليزية",
          "selectLanguage": "إختر اللغة",
          "backup": "النسخ الإحتياطي",
          "saveNotes": "عمل نسخة احتياطية",
          "restoreNotes": "استعادة من نسخة إحتياطية محفوظة",

          // confirm backup screen
          "databaseSaved": "تم حفظ النسخة الإحتياطة من قاعدة البيانات.",
          "databaseRestored": "تم استعادة قاعدة البيانات من النسخة الإحتياطية.",
          "instruction1":
              "لضمان سلامة بياناتك، انسخ قاعدة بيانات التطبيق في ملف بامتداد ",
          "instruction2": "سيتم تسمية ملف النسخ الاحتياطي ",
          "instruction3":
              "بعد الضغط على زر النسخ الاحتياطي، ستفتح نافذة اختيار الملفات.",
          "instruction4": "امنح الأذونات اللازمة لفتح نافذة اختيار الملفات.",
          "instruction5": "اختر مجلدًا أو مكانًا لحفظ ملف النسخ الاحتياطي.",
          "instruction6": "أكد اختيارك بالنقر على زر حفظ.",
          "instruction7": "انتظر حتى تكتمل عملية النسخ الاحتياطي.",
          "instruction8": "بمجرد اكتمال النسخ الاحتياطي، ستتلقى رسالة تأكيد.",
          "restore1": "اضغط على زر الاستعادة لبدء عملية الاستعادة.",
          "restore2":
              "ستفتح نافذة اختيار الملفات. اختر ملف النسخ الاحتياطي الذي تريد استعادته.",
          "restore3": "أكد اختيارك بالنقر على زر فتح.",
          "restore4":
              "سيحل ملف قاعدة البيانات الجديد محل قاعدة بيانات التطبيق الحالية، مما يؤدي إلى مسح جميع المذكرات والمجلدات التي لديك حاليًا، إلا إذا قمت بعمل نسخة احتياطية من قاعدة البيانات الحالية في ملف منفصل من الشاشة السابقة.",
          // database helper
          "backupLocationError":
              "لم يتم تحديد موقع حفظ ملف النسخة الإتحتياطية.",
          "backupError": "حدث خطأ اثناء حفظ النسخة الإتحياطية.",
        },
        "en": {
          //my message
          "cancel": "Cancel",
          "ok": "OK",
          "error": "Error!",
          "warning": "Warning",
          "emptyFieldsWarning": "All fields must be filled!",
          "emptyField": "You must fill this field to continue!",
          "emptyTitleWarning":
              "The title field cannot be empty, please enter a title.",
          "emptyContentWarning":
              "The content field cannot be empty, please enter some content.",
          "invalidPassword": "Invalid Password. Try again.",
          "cannotHaveSpaces": "Password cannot contain white spaces.",
          "confirmNoteMoveToTrash":
              "Are you sure you want to move this note to trash?",
          "confirmNoteDelete":
              "Are you sure you want to delete this note permanently?",
          "confirmFolderDelete":
              "Are you sure you want to delete this folder, and all its notes?",
          "confirmEmpty": "Are you sure you want to empty trash?",
          "confirmRestore": "Are you sure you want to restore all notes?",
          "confirmRestoreNote": "Are you sure you want to restore this note?",

          // my snack bar
          "languageChanged": "Language changed.",
          "noteAdded": "Note added successfully.",
          "noteUpdated": "Note updated successfully.",
          "passwordSet": "Password is set successfully.",
          "movedToTrash": "This note has been moved to trash.",
          "fileSaved": "File has been save successfully.",
          "noEditeFavorite": "You cannot edit notes while in Favorites.",
          "noteAddedToFavorites":
              "Note has been added to Favorites successfully.",
          "noteRemovedFromFavorites": "Note has been removed from Favorites.",
          "trashEmptied": "Trash emptied.",
          "trashRestored": "All notes restored.",
          "noteDelete": "Note deleted.",
          "noteRestored": "Note restored.",

          // splash screen
          "notabilia": "Notabilia",
          "notabiliaApp": "Notabilia App- Notepad",

          // main screen
          "notesScreen": "Notes",
          "foldersScreen": "Folders",

          // notes screen
          "main": "Main",
          "searchNotes": "Search for Notes..",
          "somethingWrongHappened": "Something Wrong Happened.",
          "noNotes": "No existing notes. Tap on the ‘+’ button to create.",
          "thisNoteHasPassword": "This Note is Protected by A Password.",

          // folders screen
          "folders": "Folders",
          "noFolders": "No existing folders. Tap on the ‘+’ button to create.",
          "enterFolderName": "Enter Folder Name",
          "folderName": "Folder name",
          "addFolder": "Add Folder",
          "folderAdded": "Folder added successfully.",

          // folder screen
          "deleteFolder": "Delete Folder",
          "folderDeleted": "Folder has been deleted.",

          // add note screen
          "addNote": "Add Note",
          "title": "Title",
          "content": "Note Content",
          "save": "Save",
          "setPassword": "Set Password",
          "enterPassword": "Enter Password",

          // view note screen
          "exportToFile": "Export to File",
          "deleteNote": "Delete Note",
          "moveToTrash": "Move to Trash",
          "textFile": "Text File",
          "pdfFile": "PDF File",
          "restoreNote": "Restore Note",

          // trash screen
          "noTrashNotes": "No existing notes in the trash.",
          "emptyTrash": "Empty Trash",
          "restoreAll": "Restore All",

          // favorites screen
          "noFavoriteNotes": "No existing notes in the favorites.",

          // drawer screen
          "settings": "Settings",
          "favorites": "Favorites",
          "trash": "Trash",

          // settings screen
          "language": "Language",
          "arabic": "Arabic",
          "english": "English",
          "selectLanguage": "Select Language",
          "backup": "Backup",
          "saveNotes": "Make a Backup",
          "restoreNotes": "Restore Backup",

          // confirm backup screen
          "databaseSaved": "Backup saved successfully.",
          "databaseRestored": "Backup restored successfully.",
          "instruction1":
              "Back up your database to ensure data safety by saving it as a file with the extension ",
          "instruction2": "The backup file will be named ",
          "instruction3":
              "After you press the Backup button, a file picker will open.",
          "instruction4":
              "Grant the necessary permissions to open the file picker.",
          "instruction5": "Select a folder or a place to save the backup file.",
          "instruction6": "Confirm your selection by clicking the Save button.",
          "instruction7": "Wait for the backup process to complete.",
          "instruction8":
              "Once the backup is complete, you will receive a confirmation message.",
          "restore1":
              "Press the Restore button to begin the restoration process.",
          "restore2":
              "A file picker will open. Select the backup file you want to restore.",
          "restore3": "Confirm your selection by clicking the Open button.",
          "restore4":
              "The new database file will replace the current app's database, erasing all the notes and folders you currently have, unless you make a backup of the current database into a separate file from the previous screen.",

          // database helper
          "backupLocationError": "Backup location not selected.",
          "backupError": "Error during database backup",
        },
      };
}
