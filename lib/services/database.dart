import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../data/models.dart';

class NotesDatabaseService {
  NotesDatabaseService._();
  static final NotesDatabaseService db = NotesDatabaseService._();

  late Database _database;

  Future<Database> get database async {
    _database = await init();
    return _database;
  }

  Future<Database> init() async {
    final String path = join(await getDatabasesPath(), 'notes.db');
    print("Entered path $path");

    return await openDatabase(
      path, 
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE Notes (
            _id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            content TEXT,
            date TEXT,
            isImportant INTEGER
          )
        ''');
        print('New table created at $path');
      },
    );
  }

  Future<List<NotesModel>> getNotesFromDB() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Notes',
      columns: ['_id', 'title', 'content', 'date', 'isImportant'],
    );
    
    return maps.map((map) => NotesModel.fromMap(map)).toList();
  }

  Future<void> updateNoteInDB(NotesModel updatedNote) async {
    final db = await database;
    await db.update(
      'Notes',
      updatedNote.toMap(),
      where: '_id = ?',
      whereArgs: [updatedNote.id],
    );
  }

  Future<void> deleteNoteInDB(NotesModel noteToDelete) async {
    final db = await database;
    await db.delete(
      'Notes',
      where: '_id = ?',
      whereArgs: [noteToDelete.id],
    );
  }

  Future<NotesModel> addNoteInDB(NotesModel newNote) async {
    final db = await database;
    if (newNote.title.trim().isEmpty) newNote.title = 'Untitled Note';
    
    final id = await db.insert('Notes', {
      'title': newNote.title,
      'content': newNote.content,
      'date': newNote.date.toIso8601String(),
      'isImportant': newNote.isImportant ? 1 : 0,
    });
    
    newNote.id = id;
    return newNote;
  }
}
