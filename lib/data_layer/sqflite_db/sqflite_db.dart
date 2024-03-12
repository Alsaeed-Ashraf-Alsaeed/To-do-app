import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/task_model.dart';

class MyLocalDatabase {
   Database? myDataBase;

  Future<Database?> initializeDB() async {
    String dBPath = await getDatabasesPath();
    String path = join(dBPath, 'todo.db');

    myDataBase = await openDatabase(
      path,
      onCreate: onCreate,
      version: 3,
      onOpen: onOpened,
      onUpgrade: (database, i,j){print('onUpgrade called');}
    );

    return myDataBase;
  }

  onCreate(Database dB, int version) async {
    print('on created called');
    await dB
        .execute('''
    CREATE TABLE "tasks" (
    id INTEGER  PRIMARY KEY AUTOINCREMENT,   
    taskID INTEGER ,
    title TEXT , 
    description , 
    date TEXT, 
    startTime TEXT, 
    endTime TEXT,
    wasCompleted TEXT,
    repeat TEXT , 
    remind INTEGER ,
    dayPeriod TEXT
      ) 
   ''')
        .then((value) => debugPrint('table created'))
        .catchError((error) => print('error while creating a table'));
  }

  void onOpened(Database database) {
    print('data base opened');
  }

  Future<Database?> get initDB async {
    if (myDataBase == null) {
      myDataBase = await initializeDB();
      return myDataBase;
    } else {
      return myDataBase;
    }
  }

  Future<List<Map>> readData(String sql) async {
    Database? myDB = await initDB;
    List<Map> response = await myDB!.rawQuery(sql);
    return response;
  }

  Future<int>   insertData(String sql) async {
    Database? myDB = await initDB;
    int response = await myDB!.rawInsert(sql);
    return response;
  }

  Future<int> updateData(String sql) async {
    Database? myDB = await initDB;
    int response = await myDB!.rawUpdate(sql);
    return response;
  }

  Future<int> deleteData(String sql) async {
    Database? myDB = await initDB;
    int response = await myDB!.rawDelete(sql);
    return response;
  }

  //==================================================

  Future<int> insert(Task task) async {
    Database? myDB = await initDB;
    int res = await myDB!.insert('tasks', task.toJson());
    return res;
  }
   Future<int> delete(String table ,String where) async {
     Database? myDB = await initDB;
     int res = await myDB!.delete(table,where: where);
     return res;
   }
   Future<List<Map>> read(String table) async {
     Database? myDB = await initDB;
     List<Map> res = await myDB!.query(table);
     return res;
   }
   Future<int> update(String table,Task task,String where) async {
     Database? myDB = await initDB;
     int res = await myDB!.update(table, task.toJson(),where:where);
     return res;
   }


   void dBDelete() {
    deleteDatabase(myDataBase!.path);
    print('database deleted');
  }

}
