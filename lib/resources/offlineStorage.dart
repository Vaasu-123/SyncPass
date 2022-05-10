import 'dart:async';
import 'dart:core';

import 'package:passwordmanager/resources/passwords.dart';
import '../models/passmodel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class PasswordDatabase {
  PasswordDatabase._init();
  static final PasswordDatabase instance = PasswordDatabase._init();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('passwords.db');
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
    final idType = 'TEXT NOT NULL PRIMARY KEY';
    final websiteNameType = 'TEXT NOT NULL';
    final passwordType = 'TEXT NOT NULL';
    await db.execute(''' 
      CREATE TABLE $tablePasses(
        ${passFields.uid} $idType,
        ${passFields.password} $passwordType,
        ${passFields.websiteName} $websiteNameType
      )
      ''');
  }

  Future create({required passModel pass}) async {
    // print("Iam here");
    final db = await instance.database;
    // print("Iam here");
    final id = await db.insert(tablePasses, pass.toJson());
    // print("Iam here");
    print(await db.rawQuery(
        'SELECT * FROM $tablePasses ORDER BY ${passFields.websiteName} ASC'));
  }

  Future<List<Map>> getAll() async {
    final db = await instance.database;
    return await db.rawQuery(
        'SELECT * FROM $tablePasses ORDER BY ${passFields.websiteName} ASC');
  }

  Future update({required id, required password, required website}) async {
    passModel pass =
        new passModel(password: password, websiteName: website, uid: id);

    final db = await instance.database;
    db.update(
      tablePasses,
      pass.toJson(),
      where: '${passFields.uid} = ?',
      whereArgs: [id],
    );
  }

  Future delete({required id}) async {
    final db = await instance.database;
    db.delete(
      tablePasses,
      where: '${passFields.uid} = ?',
      whereArgs: [id],
    );
  }

  Future deleteAll()async{
    final db = await instance.database;
    db.delete(tablePasses);
  }

  // Future readPass(String id) async {
  //   final db = await instance.database;
  //   final maps = await db.query(
  //     tablePasses,
  //     columns: passFields.values,
  //     where: '${passFields.id} = ?',
  //     whereArgs: [id],
  //   );
  // }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
