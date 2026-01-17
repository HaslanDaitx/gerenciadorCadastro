import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:agenda_app/models/cadastro.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'agenda_desktop.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future<void> _onCreate(Database db, int version) async {

    await db.execute('''
      CREATE TABLE cadastro (
        codigo INTEGER PRIMARY KEY, 
        descricao TEXT NOT NULL CHECK (descricao <> '' AND length(descricao) > 0),
        CONSTRAINT check_codigo_positivo CHECK (codigo > 0)
      )
    ''');

    await db.execute('''
      CREATE TABLE log_operacoes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        operacao TEXT NOT NULL,
        data_hora TEXT NOT NULL
      )
    ''');

    
    await db.execute('''
      CREATE TRIGGER log_insert AFTER INSERT ON cadastro
      BEGIN
        INSERT INTO log_operacoes (operacao, data_hora)
        VALUES ('Insert', datetime('now', 'localtime'));
      END;
    ''');

  
    await db.execute('''
      CREATE TRIGGER log_update AFTER UPDATE ON cadastro
      BEGIN
        INSERT INTO log_operacoes (operacao, data_hora)
        VALUES ('Update', datetime('now', 'localtime'));
      END;
    ''');

    // Trigger DELETE
    await db.execute('''
      CREATE TRIGGER log_delete AFTER DELETE ON cadastro
      BEGIN
        INSERT INTO log_operacoes (operacao, data_hora)
        VALUES ('Delete', datetime('now', 'localtime'));
      END;
    ''');
  }
  
  Future<void> inserirCadastro(Cadastro cadastro) async {
    final db = await database;
    await db.insert(
      'cadastro',
      cadastro.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  Future<void> atualizarCadastro(Cadastro cadastro) async {
    final db = await database;
    await db.update(
      'cadastro',
      cadastro.toMap(),
      where: 'codigo = ?',
      whereArgs: [cadastro.codigo],
    );
  }

  Future<void> excluirCadastro(int codigo) async {
    final db = await database;
    await db.delete(
      'cadastro',
      where: 'codigo = ?',
      whereArgs: [codigo],
    );
  }

  Future<List<Cadastro>> listarCadastros() async {
    final db = await database;
    final List<Map<String, dynamic>> result =
        await db.query('cadastro', orderBy: 'descricao');
    return result.map((e) => Cadastro.fromMap(e)).toList();
  }
}