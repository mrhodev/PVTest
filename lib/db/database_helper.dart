import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import '../models/reaction_event.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'pvt.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE reaction_events (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        sessionId INTEGER,
        timestamp INTEGER,
        reactionTime INTEGER,
        type TEXT
      )
    ''');
  }

  Future<int> insertEvent(ReactionEvent event) async {
    final db = await database;
    return await db.insert(
      'reaction_events',
      event.toMap(), // no incluye el campo id
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ReactionEvent>> getEventsForSession(int sessionId) async {
    final db = await database;
    final maps = await db.query(
      'reaction_events',
      where: 'sessionId = ?',
      whereArgs: [sessionId],
    );
    return List.generate(maps.length, (i) => ReactionEvent.fromMap(maps[i]));
  }

  Future<List<int>> getAllSessionIds() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT DISTINCT sessionId FROM reaction_events ORDER BY sessionId DESC',
    );
    return result.map((row) => row['sessionId'] as int).toList();
  }

  Future<void> clearAll() async {
    final db = await database;
    await db.delete('reaction_events');
  }
}
