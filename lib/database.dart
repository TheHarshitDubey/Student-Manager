import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:student_manager/student.dart';


class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('students.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final path = join(await getDatabasesPath(), filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE students (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        age INTEGER,
        course TEXT
      )
    ''');
  }

Future<int> insertStudent(Student student) async {
  final db = await instance.database;
  int id = await db.insert('students', student.toMap());

  print("Inserted ID: $id"); // 🔥 DEBUG
  return id;
}

Future<List<Student>> getStudents() async {
  final db = await instance.database;
  final result = await db.query('students');

  print("DB DATA: $result"); // 🔥 DEBUG

  return result.map((e) => Student.fromMap(e)).toList();
}

  Future<int> deleteStudent(int id) async {
    final db = await instance.database;
    return await db.delete('students', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateStudent(Student student) async {
    final db = await instance.database;
    return await db.update(
      'students',
      student.toMap(),
      where: 'id = ?',
      whereArgs: [student.id],
    );
  }
}