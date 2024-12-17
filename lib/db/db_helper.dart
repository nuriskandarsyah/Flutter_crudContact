import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'contacts.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE contacts (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            phone TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> createContact(String name, String phone) async {
    final db = await database;
    return await db.insert('contacts', {'name': name, 'phone': phone});
  }

  Future<List<Map<String, dynamic>>> readContacts() async {
    final db = await database;
    return await db.query('contacts');
  }

  Future<int> updateContact(int id, String name, String phone) async {
    final db = await database;
    return await db.update(
      'contacts',
      {'name': name, 'phone': phone},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteContact(int id) async {
    final db = await database;
    return await db.delete(
      'contacts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
