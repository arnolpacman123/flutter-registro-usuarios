import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:registro_de_usuarios/model/client_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class ClientDatabaseProvider {
  ClientDatabaseProvider._();

  static final ClientDatabaseProvider db = ClientDatabaseProvider._();
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await getDatabaseInstance();
    return _database!;
  }

  Future<Database> getDatabaseInstance() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'client.db');
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE Client (id integer primary key autoincrement, name text, address text, phone text, email text unique)');
    });
  }

  Future<List<Client>> getAllClients() async {
    final db = await database;
    var response = await db.query('Client');
    List<Client> list = response.map((c) => Client.fromMap(c)).toList();
    return list;
  }

  Future<Client?> getClientWithId(int id) async {
    final db = await database;
    var response = await db.query(
      'Client',
      where: 'id = ?',
      whereArgs: [id],
    );
    return response.isNotEmpty ? Client.fromMap(response.first) : null;
  }

  Future<Client?> getClientWithEmail(String email) async {
    final db = await database;
    var response = await db.query(
      'Client',
      where: 'email = ?',
      whereArgs: [email],
    );
    return response.isNotEmpty ? Client.fromMap(response.first) : null;
  }

  addClientToDatabase(Client client) async {
    final db = await database;
    // var table = await db.rawQuery('SELECT MAX(id)+1 as id FROM Client');
    // print(table);
    // dynamic id = table.first['id'];
    // client.id = id;
    var query = await getClientWithEmail(client.email);
    if (query != null) return -1;
    var raw = await db.insert('Client', client.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    print(raw);
    return raw;
  }

  deleteClientWithId(int? id) async {
    final db = await database;
    return db.delete('Client', where: 'id = ?', whereArgs: [id]);
  }

  deleteAllClients() async {
    final db = await database;
    db.delete('Client');
  }

  updateClient(Client client) async {
    final db = await database;
    var response = await db.update('Client', client.toMap(),
        where: 'id = ?', whereArgs: [client.id]);
    return response;
  }
}
