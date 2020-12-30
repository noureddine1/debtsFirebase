import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';
import 'package:debts/models/debts.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    return await openDatabase(join(await getDatabasesPath(), 'debts.db'),
        onCreate: (db, version) async {
      await db.execute('''
          CREATE TABLE debts (
            id smallint PRIMARY KEY,fullname CHAR,amount int,duedate CHAR,startdate CHAR,type CHAR,status CHAR
          )
          ''');
    }, version: 1);
  }

  newDebt(Debt newDebt) async {
    final db = await database;
    var res = await db.rawInsert('''
    INSERT INTO debts(
      id,fullname,amount,duedate,startdate,type,status
    ) VALUES (?, ?, ?, ?, ?, ?, ?)
    ''', [
      newDebt.id,
      newDebt.fullname,
      newDebt.amount,
      newDebt.duedate,
      newDebt.startdate,
      newDebt.type,
      newDebt.status
    ]);

    return res;
  }

  Future<List> getDebt() async {
    final db = await database;
    var res = await db.query("debts");
    if (res.length == 0) {
      return null;
    } else {
      return res.isNotEmpty ? res : null;
    }
  }

  Future<List> getOwnedDebt() async {
    final db = await database;
    var res = await db.rawQuery('SELECT * FROM debts WHERE type=?', ['Owned']);
    if (res.length == 0) {
      return null;
    } else {
      return res.isNotEmpty ? res : null;
    }
  }

  Future<List> getOwnesDebt() async {
    final db = await database;
    var res = await db.rawQuery('SELECT * FROM debts WHERE type=?', ['Ownes']);
    if (res.length == 0) {
      return null;
    } else {
      return res.isNotEmpty ? res : null;
    }
  }

  Future<int> updateDebt(int id) async {
    final db = await database;
    int updateCount = await db.rawUpdate('''
    UPDATE debts 
    SET status = ?
    WHERE id = ?
    ''', ['Completed', id]);
    return updateCount;
  }

  Future<int> deleteDebt(int id) async {
    final db = await database;
    int updateCount = await db.rawDelete('''
    DELETE FROM debts 
    WHERE id = ?
    ''', [id]);
    return updateCount;
  }
}
