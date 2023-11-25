import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uasapp/model/transactiondetails.dart';
import 'package:uasapp/model/userData.dart';

class DatabaseHelper {
  Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), 'bankingsystem.db'),
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE userdetails(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          userName TEXT,
          cardNumber VARCHAR,
          cardExpiry TEXT,
          totalAmount DOUBLE
        )
      ''');

        await db.execute('''
        CREATE TABLE transactionsData(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          transactionId INTEGER,
          userName TEXT,
          senderName TEXT,
          transactionAmount DOUBLE
        )
      ''');
      },
      version: 1,
    );
  }

  // Future<Database> database() async {
  //   return openDatabase(
  //     join(await getDatabasesPath(), 'bankingsystem.db'),
  //     onCreate: (db, version) async {
  //       await db.execute(
  //           "CREATE TABLE userdetails(id INTEGER PRIMARY KEY, userName TEXT,cardNumber VARCHAR,cardExpiry TEXT,totalAmount DOUBLE)");

  //       await db.execute(
  //           "CREATE TABLE transactionsData(id INTEGER PRIMARY KEY,transactionId INTEGER,userName TEXT,senderName TEXT,transactionAmount DOUBLE)");

  //       return db;
  //     },
  //     version: 1,
  //   );
  // }

  Future<void> insertUserDetails(UserData userdata) async {
    final Database _db = await database();
    await _db.insert('userdetails', userdata.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertTransactionHistroy( TransactionDetails transactionDetails) async {
    final Database _db = await database();
    await _db.insert('transactionsData', transactionDetails.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateTotalAmount(int id, double totalAmount) async {
    Database _db = await database();
    await _db.rawUpdate(
        "UPDATE userdetails SET totalAmount = '$totalAmount' WHERE id = '$id'");
  }

  Future<List<UserData>> getUserDetails() async {
    final Database _db = await database();
    final List<Map<String, dynamic>> userMap = await _db.query('userdetails');
    return List.generate(
      userMap.length,
      (index) {
        return UserData(
          id: userMap[index]['id'],
          userName: userMap[index]['userName'],
          cardNumber: userMap[index]['cardNumber'],
          cardExpiry: userMap[index]['cardExpiry'],
          totalAmount: userMap[index]['totalAmount'],
        );
      },
    );
  }

  Future<List<UserData>> getUserDetailsList(int userId) async {
    final Database _db = await database();
    List<Map<String, dynamic>> userMap =
        await _db.rawQuery("SELECT * FROM userdetails WHERE id != $userId");
    return List.generate(userMap.length, (index) {
      return UserData(
        id: userMap[index]['id'],
        userName: userMap[index]['userName'],
        cardNumber: userMap[index]['cardNumber'],
        cardExpiry: userMap[index]['cardExpiry'],
        totalAmount: userMap[index]['totalAmount'],
      );
    });
  }

  Future<List<TransactionDetails>> getTransactionDetatils() async {
    Database _db = await database();
    final List<Map<String, dynamic>> transactionMap =
        await _db.rawQuery("SELECT * FROM transactionsData");
    return List.generate(transactionMap.length, (index) {
      return TransactionDetails(
        id: transactionMap[index]['id'],
        userName: transactionMap[index]['userName'],
        senderName: transactionMap[index]['senderName'],
        transactionId: transactionMap[index]['transactionId'],
        transactionAmount: transactionMap[index]["transactionAmount"],
      );
    });
  }

  Future<void> updateTransactionIsDone(int id, int transactionDone) async {
    Database _db = await database();
    await _db.rawUpdate(
        "UPDATE transactionsData SET transactionDone = '$transactionDone' WHERE id = '$id'");
  }
}
