import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uasapp/model/transactiondetails.dart';
import 'package:uasapp/model/userData.dart';
import 'package:uasapp/model/member.dart';

class DatabaseHelper {
  Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), 'bankingsystem.db'),
      onCreate: (db, version) async {
  await db.execute('''
    CREATE TABLE member (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nik TEXT,
      nama TEXT,
      email VARCHAR,
      password VARCHAR
    )
  ''');

  await db.execute('''
    CREATE TABLE card (
      cardNumber VARCHAR PRIMARY KEY,
      id INTEGER,
      nama TEXT,
      totalAmount DOUBLE,
      cardExpiry TEXT,
      FOREIGN KEY (id) REFERENCES member(id),
    )
  ''');

  await db.execute('''
    CREATE TABLE transactionsData(
      id INTEGER,
      transactionId INTEGER PRIMARY KEY AUTOINCREMENT,
      nama TEXT,
      senderName TEXT,
      transactionAmount DOUBLE,
      FOREIGN KEY (id) REFERENCES member(id),
    )
  ''');
},
      onUpgrade: (db, oldVersion, newVersion) async {
    // Add migration logic here
    if (oldVersion < 6) {
      // Add statements to update the database structure
      await db.execute('''
        CREATE TABLE IF NOT EXISTS transactionsData (
          id INTEGER,
          transactionId INTEGER PRIMARY KEY,
          nama TEXT,
          senderName TEXT,
          transactionAmount DOUBLE,
          FOREIGN KEY (id) REFERENCES member(id),
        )
      ''');
    }
      },
      version: 9,
    );
  }

  Future<int> insertMember(Member member) async {
    final Database _db = await database();
    return await _db.insert('member', member.toMap());
  }

  Future<List<Member>> getMembers() async {
    final Database _db = await database();
    final List<Map<String, dynamic>> memberMap = await _db.query('member');
    return List.generate(
      memberMap.length,
      (index) {
        return Member(
          id: memberMap[index]['id'],
          nama: memberMap[index]['nama'],
          nik: memberMap[index]['nik'],
          email: memberMap[index]['email'],
          password: memberMap[index]['password'],
        );
      },
    );
  }

  Future<Member?> getMemberById(int id) async {
    final Database _db = await database();
    List<Map<String, dynamic>> memberMap =
        await _db.rawQuery("SELECT * FROM member WHERE id = $id");
    if (memberMap.isNotEmpty) {
      return Member(
        id: memberMap[0]['id'],
        nama: memberMap[0]['nama'],
        nik: memberMap[0]['nik'],
        email: memberMap[0]['email'],
        password: memberMap[0]['password'],
      );
    }
    return null;
  }

  Future<Member?> logIn(Map<String, dynamic> credentials) async {
    Database _db = await database();
    List<Map<String, dynamic>> memberMap = await _db.rawQuery(
      "SELECT * FROM member WHERE email = ? AND password = ?",
      [credentials['email'], credentials['password']],
    );

    if (memberMap.isNotEmpty) {
      return Member.fromMap(memberMap[0]);
    } else {
      return null; // Return null explicitly if no member is found
    }
  }

  Future<Member?> saveUser(Map<String, dynamic> user) async {
    final Database _db = await database();
    int userId = await _db.insert('member', user,
        conflictAlgorithm: ConflictAlgorithm.replace);

    // Fetch the inserted user from the database
    List<Map<String, dynamic>> memberMap =
        await _db.rawQuery("SELECT * FROM member WHERE id = $userId");

    if (memberMap.isNotEmpty) {
      return Member.fromMap(memberMap[0]);
    } else {
      throw Exception("Failed to fetch user after insertion");
    }
  }

  Future<void> insertUserDetails(UserData userdata) async {
    final Database _db = await database();
    await _db.insert('card', userdata.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertTransactionHistroy( TransactionDetails transactionDetails) async {
    final Database _db = await database();
    await _db.insert('transactionsData', transactionDetails.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateTotalAmount(int id, double totalAmount) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE card SET totalAmount = ? WHERE id = ?",
        ['$totalAmount', '$id']);
  }

  Future<List<UserData>> getUserDetails() async {
    final Database _db = await database();
    final List<Map<String, dynamic>> userMap = await _db.query('card');
    return List.generate(
      userMap.length,
      (index) {
        return UserData(
          id: userMap[index]['id'],
          nama: userMap[index]['nama'],
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
        await _db.rawQuery("SELECT * FROM card WHERE id != $userId");
    return List.generate(userMap.length, (index) {
      return UserData(
        id: userMap[index]['id'],
        nama: userMap[index]['nama'],
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
        nama: transactionMap[index]['nama'],
        senderName: transactionMap[index]['senderName'],
        transactionId: transactionMap[index]['transactionId'] ?? 0,
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
