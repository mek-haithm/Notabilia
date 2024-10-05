import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';
import '../features/folders/models/folder.dart';
import '../features/notes/models/note.dart';
import '../shared/widgets/my_snack_bar.dart';

class DatabaseHelper {
  static Database? _db;

  Future<Database?> get db async {
    _db ??= await initDB();
    return _db;
  }

  Future<Database?> initDB() async {
    try {
      String databasePath =
          await getDatabasesPath(); // Gets the base path for databases
      String path = join(databasePath,
          'notabilia.db'); // Appends your database name to the path

      if (kDebugMode) {
        print('Database is supposed to be at: $path');
      }

      Database myDB = await openDatabase(
        path,
        onCreate: _onCreate,
        version: 1,
        onUpgrade: _onUpgrade,
      );

      // Check if the database file actually exists
      bool dbExists = await File(path).exists();
      if (kDebugMode) {
        print('Database exists after initDB(): $dbExists at $path');
      }

      return myDB;
    } catch (e) {
      if (kDebugMode) {
        print('Error while initializing database: $e');
      }
      return null;
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    try {
      await db.execute('''
      CREATE TABLE folders (
        folder_id INTEGER PRIMARY KEY AUTOINCREMENT,
        folder_name TEXT NOT NULL,
        password TEXT,
        updated_at TEXT
      )
      ''');

      await db.execute('''
      CREATE TABLE notes (
        note_id INTEGER PRIMARY KEY AUTOINCREMENT,
        note_title TEXT,
        note_content TEXT,
        note_color_index INTEGER NOT NULL,
        password TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT,
        folder_id INTEGER,
        is_favorite INTEGER NOT NULL DEFAULT 0,
        is_trash INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (folder_id) REFERENCES folders (folder_id)
      )
      ''');

      await db.insert(
        'folders',
        {'folder_name': 'Main'},
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error while creating tables: $e');
      }
    }
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    try {
      // Drop the existing tables
      await db.execute('DROP TABLE IF EXISTS folders');
      await db.execute('DROP TABLE IF EXISTS notes');

      // Recreate the tables
      await _onCreate(db, newVersion);
    } catch (e) {
      if (kDebugMode) {
        print('Error while upgrading database: $e');
      }
    }
  }

  // Backup database
  Future<void> backupDatabase() async {
    try {
      // Ensure database is initialized
      Database? dbInstance = await db;
      if (dbInstance == null) {
        if (kDebugMode) {
          print('Database not initialized');
        }
        return;
      }

      // Get the actual database path
      String databasePath = await getDatabasesPath();
      String dbPath = join(databasePath, 'notabilia.db');

      // Check if the database file exists
      File dbFile = File(dbPath);
      if (!await dbFile.exists()) {
        if (kDebugMode) {
          print('Database file not found at $dbPath');
        }
        return;
      }

      // Open file picker to select the backup location
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

      if (selectedDirectory != null) {
        // Copy the database file to the selected location
        String backupPath = join(selectedDirectory, 'notabilia_backup.db');
        await dbFile.copy(backupPath);

        if (kDebugMode) {
          print('Database backup created at $backupPath');
        }
        MySnackBar.showSnackBar(message: 'databaseSaved'.tr);
      } else {
        MySnackBar.showSnackBar(message: 'backupLocationError'.tr);
        if (kDebugMode) {
          print('Backup location not selected');
        }
      }
    } catch (e) {
      MySnackBar.showSnackBar(message: 'backupError'.tr);
      if (kDebugMode) {
        print('Error during database backup: $e');
      }
    }
  }

  // Restore database
  Future<void> restoreDatabase() async {
    try {
      // Open file picker to select the backup file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any, // Changed to any to avoid custom file type issues
      );

      if (result != null && result.files.single.path != null) {
        // Get the selected backup file path
        String backupPath = result.files.single.path!;

        // Get the database path
        String databasePath = await getDatabasesPath();
        String dbPath = join(databasePath, 'notabilia.db');

        // Close the current database connection
        if (_db != null) {
          await _db!.close();
          _db = null; // Ensure the database instance is null
        }

        // Delete the current database file
        File dbFile = File(dbPath);
        if (await dbFile.exists()) {
          await dbFile.delete();
        }

        // Copy the backup file to the database location
        File backupFile = File(backupPath);
        await backupFile.copy(dbPath);

        // Reinitialize the database connection
        await initDB();
        MySnackBar.showSnackBar(message: 'databaseRestored'.tr);
        if (kDebugMode) {
          print('Database restored from $backupPath and reinitialized');
        }
      } else {
        MySnackBar.showSnackBar(message: 'backupLocationError'.tr);
        if (kDebugMode) {
          print('Backup file not selected');
        }
      }
    } catch (e) {
      MySnackBar.showSnackBar(message: 'backupError'.tr);
      if (kDebugMode) {
        print('Error during database restore: $e');
      }
    }
  }

// get notes for a specific folder
  Future<List<Note>> getNotesForFolder(int id) async {
    final db = await this.db;
    if (db == null) {
      if (kDebugMode) {
        print('Database has not been initialized.');
      }
      return [];
    }

    try {
      // Get the notes for the folder with the given id
      final List<Map<String, dynamic>> maps = await db.query(
        'notes',
        where: 'folder_id = ? AND is_trash = 0',
        whereArgs: [id],
        orderBy: 'updated_at DESC',
      );

      // Convert the List<Map<String, dynamic> into a List<Note>.
      return List.generate(maps.length, (i) {
        return Note.fromMap(maps[i]);
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error while getting notes for folder: $e');
      }
      return [];
    }
  }

  // add note
  Future<int> addNote(Note note) async {
    final db = await this.db;
    if (db == null) {
      if (kDebugMode) {
        print('Database has not been initialized.');
      }
      return -1;
    }

    try {
      final id = await db.insert('notes', {
        'note_title': note.title,
        'note_content': note.content,
        'note_color_index': note.colorIndex,
        'password': note.password,
        'created_at': note.createdAt!,
        'updated_at': note.updatedAt!,
        'folder_id': note.folderId,
      });
      if (kDebugMode) {
        print('note $id added.');
      }
      return id;
    } catch (e) {
      if (kDebugMode) {
        print('Error while adding note: $e');
      }
      return -1;
    }
  }

  // update note
  Future<int> updateNote(int id, Note note) async {
    final db = await this.db;
    if (db == null) {
      if (kDebugMode) {
        print('Database has not been initialized.');
      }
      return -1;
    }

    try {
      final rowsAffected = await db.update(
        'notes',
        {
          'note_title': note.title,
          'note_content': note.content,
          'note_color_index': note.colorIndex,
          'password': note.password ?? '',
          'updated_at': note.updatedAt,
        },
        where: 'note_id = ?',
        whereArgs: [id],
      );
      return rowsAffected;
    } catch (e) {
      if (kDebugMode) {
        print('Error while updating note: $e');
      }
      return -1;
    }
  }

  // delete note
  Future<int> moveNoteToTrash(int id) async {
    final db = await this.db;
    if (db == null) {
      if (kDebugMode) {
        print('Database has not been initialized.');
      }
      return -1;
    }

    try {
      int count = await db.update(
        'notes',
        {'is_trash': 1},
        where: 'note_id = ?',
        whereArgs: [id],
      );
      if (kDebugMode) {
        print('Note has been moved to trash $count');
      }
      return count;
    } catch (e) {
      if (kDebugMode) {
        print('Error while moving note note to trash: $e');
      }
      return -1;
    }
  }

// get all folders
  Future<List<Folder>> getFolders() async {
    final db = await this.db;
    if (db == null) {
      if (kDebugMode) {
        print('Database has not been initialized.');
      }
      return [];
    }
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        'folders',
        where: 'folder_id != ?',
        whereArgs: [1],
        orderBy: 'updated_at DESC',
      );

      // Convert List<Map<String, dynamic>> to List<Folder>
      return List.generate(maps.length, (i) {
        return Folder.fromMap(maps[i]);
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error while getting folders $e');
      }
      return [];
    }
  }

// add folder
  Future<int> addFolder(Folder folder) async {
    final db = await this.db;
    if (db == null) {
      if (kDebugMode) {
        print('Database has not been initialized.');
      }
      return -1;
    }

    try {
      final id = await db.insert('folders', {
        'folder_name': folder.name,
        'updated_at': folder.updatedAt,
        'password': folder.password,
      });
      return id;
    } catch (e) {
      if (kDebugMode) {
        print('Error while adding folder: $e');
      }
      return -1;
    }
  }

  // get the count of notes in each folder
  Future<int> getNoteCountInFolder(int folderId) async {
    final db = await this.db;
    if (db == null) {
      if (kDebugMode) {
        print('Database has not been initialized.');
      }
      return 0;
    }
    try {
      final List<Map<String, dynamic>> result = await db.rawQuery(
        'SELECT COUNT(*) as note_count FROM notes WHERE folder_id = ? AND is_trash = 0',
        [folderId],
      );

      if (result.isNotEmpty) {
        return result.first['note_count'];
      } else {
        return 0;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error while getting note count in folder $e');
      }
      return 0;
    }
  }

  // toggle favorite
  Future<void> toggleFavorite(Note note) async {
    if (note.isFavorite) {
      await removeFavorite(note.id!);
    } else {
      await addFavorite(note.id!);
    }
    note.isFavorite = !note.isFavorite;
  }

  // add note to favorite
  Future<void> addFavorite(int noteId) async {
    final db = await this.db;
    if (db == null) {
      if (kDebugMode) {
        print('Database has not been initialized.');
      }
      return;
    }

    try {
      await db.update(
        'notes',
        {'is_favorite': 1},
        where: 'note_id = ?',
        whereArgs: [noteId],
      );
      if (kDebugMode) {
        print('Note $noteId marked as favorite.');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error while marking note as favorite: $e');
      }
    }
  }

  // remove note from favorites
  Future<void> removeFavorite(int noteId) async {
    final db = await this.db;
    if (db == null) {
      if (kDebugMode) {
        print('Database has not been initialized.');
      }
      return;
    }

    try {
      await db.update(
        'notes',
        {'is_favorite': 0},
        where: 'note_id = ?',
        whereArgs: [noteId],
      );
      if (kDebugMode) {
        print('Note $noteId removed from favorites.');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error while removing note from favorites: $e');
      }
    }
  }

  // get all favorite notes
  Future<List<Note>> getAllFavoriteNotes() async {
    final db = await this.db;
    if (db == null) {
      if (kDebugMode) {
        print('Database has not been initialized.');
      }
      return [];
    }

    try {
      // Get all favorite notes where is_favorite = 1
      final List<Map<String, dynamic>> maps = await db.query(
        'notes',
        where: 'is_favorite = 1',
        orderBy: 'updated_at DESC',
      );

      // Convert the List<Map<String, dynamic>> into a List<Note>.
      return List.generate(maps.length, (i) {
        return Note.fromMap(maps[i]);
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error while getting all favorite notes: $e');
      }
      return [];
    }
  }

  // get all trash notes
  Future<List<Note>> getAllTrashNotes() async {
    final db = await this.db;
    if (db == null) {
      if (kDebugMode) {
        print('Database has not been initialized.');
      }
      return [];
    }

    try {
      // Get all favorite notes where is_trash = 1
      final List<Map<String, dynamic>> maps = await db.query(
        'notes',
        where: 'is_trash = 1',
        orderBy: 'updated_at DESC',
      );

      // Convert the List<Map<String, dynamic>> into a List<Note>.
      return List.generate(maps.length, (i) {
        return Note.fromMap(maps[i]);
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error while getting all trash notes: $e');
      }
      return [];
    }
  }

  // add note for folder
  Future<int> addNoteForFolder(Note note, int folderId) async {
    final db = await this.db;
    if (db == null) {
      if (kDebugMode) {
        print('Database has not been initialized.');
      }
      return -1;
    }

    try {
      final id = await db.insert('notes', {
        'note_title': note.title,
        'note_content': note.content,
        'note_color_index': note.colorIndex,
        'password': note.password,
        'created_at': note.createdAt!,
        'updated_at': note.updatedAt!,
        'folder_id': folderId,
      });
      return id;
    } catch (e) {
      if (kDebugMode) {
        print('Error while adding note: $e');
      }
      return -1;
    }
  }

  // delete folder
  Future<int> deleteFolder(int id) async {
    final db = await this.db;
    if (db == null) {
      if (kDebugMode) {
        print('Database has not been initialized.');
      }
      return -1;
    }

    try {
      List<Map<String, dynamic>> folders =
          await db.query('folders', where: 'folder_id = ?', whereArgs: [id]);
      if (folders.isNotEmpty) {
        // Delete notes with the same folder_id
        await db.delete('notes', where: 'folder_id = ?', whereArgs: [id]);

        // Delete the folder
        final rowsAffected =
            await db.delete('folders', where: 'folder_id = ?', whereArgs: [id]);
        return rowsAffected;
      }
      return 0;
    } catch (e) {
      if (kDebugMode) {
        print('Error while deleting folder: $e');
      }
      return -1;
    }
  }

  Future<void> updateFolderPassword(String password, int folderId) async {
    try {
      final db = await this.db;

      int count = await db!.update(
        'folders',
        {'password': password},
        where: 'folder_id = ?',
        whereArgs: [folderId],
      );

      // Check if the update was successful
      if (count == 0) {
        if (kDebugMode) {
          print('No folder found with folder_id: $folderId');
        }
      } else {
        if (kDebugMode) {
          print('Updated password for folder folder_id: $folderId');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('An error occurred while updating the password: $e');
      }
    }
  }

  // empty trash
  Future<int> emptyTrash() async {
    final db = await this.db;
    if (db == null) {
      if (kDebugMode) {
        print('Database has not been initialized.');
      }
      return -1;
    }

    try {
      int count = await db.delete(
        'notes',
        where: 'is_trash = ?',
        whereArgs: [1],
      );
      return count;
    } catch (e) {
      if (kDebugMode) {
        print('Error while deleting notes: $e');
      }
      return -1;
    }
  }

  // restore trash
  Future<int> restoreTrash() async {
    final db = await this.db;
    if (db == null) {
      if (kDebugMode) {
        print('Database has not been initialized.');
      }
      return -1;
    }

    try {
      int count = await db.update(
        'notes',
        {'is_trash': 0},
        where: 'is_trash = ?',
        whereArgs: [1],
      );
      return count;
    } catch (e) {
      if (kDebugMode) {
        print('Error while restoring notes: $e');
      }
      return -1;
    }
  }

  // delete note
  Future<int> deleteNote(int id) async {
    final db = await this.db;
    if (db == null) {
      if (kDebugMode) {
        print('Database has not been initialized.');
      }
      return -1;
    }

    try {
      int count = await db.delete(
        'notes',
        where: 'note_id = ?',
        whereArgs: [id],
      );
      if (kDebugMode) {
        print('Note $count deleted');
      }
      return count;
    } catch (e) {
      if (kDebugMode) {
        print('Error while deleting notes: $e');
      }
      return -1;
    }
  }

  // restore note
  Future<int> restoreNote(int id) async {
    final db = await this.db;
    if (db == null) {
      if (kDebugMode) {
        print('Database has not been initialized.');
      }
      return -1;
    }

    try {
      int count = await db.update(
        'notes',
        {'is_trash': 0},
        where: 'is_trash = 1 AND note_id = ?',
        whereArgs: [id],
      );
      return count;
    } catch (e) {
      if (kDebugMode) {
        print('Error while restoring notes: $e');
      }
      return -1;
    }
  }
}
