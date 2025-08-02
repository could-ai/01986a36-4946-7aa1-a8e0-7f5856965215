import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/password_entry.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._init();
  static Database? _database;

  DBHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('password_manager.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    await db.execute('''
      CREATE TABLE password_entries (
        id $idType,
        title $textType,
        username $textType,
        password $textType
      )
    ''');
  }

  Future<List<PasswordEntry>> getEntries() async {
    final db = await instance.database;
    final result = await db.query('password_entries', orderBy: 'id DESC');
    return result.map((json) => PasswordEntry.fromMap(json)).toList();
  }

  Future<int> insertEntry(PasswordEntry entry) async {
    final db = await instance.database;
    return await db.insert('password_entries', entry.toMap());
  }

  Future<int> updateEntry(PasswordEntry entry) async {
    final db = await instance.database;
    return await db.update(
      'password_entries',
      entry.toMap(),
      where: 'id = ?',
      whereArgs: [entry.id],
    );
  }

  Future<int> deleteEntry(int id) async {
    final db = await instance.database;
    return await db.delete(
      'password_entries',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
