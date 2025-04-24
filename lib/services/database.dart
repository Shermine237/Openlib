// Dart imports:
import 'dart:io';

// Package imports:
import 'package:sqflite/sqflite.dart';

// Project imports:
import 'package:openlib/services/files.dart';

class MyBook {
  final String id;
  final String title;
  final String? author;
  final String? thumbnail;
  final String link;
  final String? publisher;
  final String? info;
  final String? description;
  final String? format;

  MyBook(
      {required this.id,
      required this.title,
      this.author,
      this.thumbnail,
      required this.link,
      this.publisher,
      this.info,
      this.format,
      this.description});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'thumbnail': thumbnail,
      'link': link,
      'publisher': publisher,
      'info': info,
      'format': format,
      'description': description
    };
  }

  @override
  String toString() {
    return 'MyBook{id: $id,title: $title,author: $author,thumbnail: $thumbnail,link: $link,publisher: $publisher,info: $info,format: $format,description:$description}';
  }
}

class MyLibraryDb {
  static final MyLibraryDb instance = MyLibraryDb._internal();
  static Database? _database;
  MyLibraryDb._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = '$databasePath/mylibrary.db';
    final bool isMobile = Platform.isAndroid || Platform.isIOS;

    return await openDatabase(
      path,
      version: 5,
      onCreate: (Database db, int version) async {
        await db.execute(
            'CREATE TABLE mybooks (id TEXT PRIMARY KEY, title TEXT,author TEXT,thumbnail TEXT,link TEXT,publisher TEXT,info TEXT,format TEXT,description TEXT)');
        await db.execute(
            'CREATE TABLE preferences (name TEXT PRIMARY KEY,value TEXT)');
        if (isMobile || true) {
          // TODO: Breaks getBrowserOptions() on Mac
          await db.execute(
              'CREATE TABLE bookposition (fileName TEXT PRIMARY KEY,position TEXT)');
          await db.execute(
              'CREATE TABLE browserOptions (name TEXT PRIMARY KEY,value TEXT)');
        }
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        List<dynamic> isTableExist = await db.query('sqlite_master',
            where: 'name = ?', whereArgs: ['bookposition']);
        List<dynamic> isPreferenceTableExist = await db.query('sqlite_master',
            where: 'name = ?', whereArgs: ['preferences']);
        List<dynamic> isbrowserOptionsExist = await db.query('sqlite_master',
            where: 'name = ?', whereArgs: ['browserOptions']);
        if (isPreferenceTableExist.isEmpty) {
          await db.execute(
              'CREATE TABLE preferences (name TEXT PRIMARY KEY,value TEXT)');
        }
        if (isMobile && isTableExist.isEmpty) {
          await db.execute(
              'CREATE TABLE bookposition (fileName TEXT PRIMARY KEY,position TEXT)');
        }
        if (isMobile && isbrowserOptionsExist.isEmpty) {
          await db.execute(
              'CREATE TABLE browserOptions (name TEXT PRIMARY KEY,value TEXT)');
        }
      },
      onOpen: (db) async {
        final bookStorageDefaultDirectory =
            await getBookStorageDefaultDirectory;
        await db.execute(
            "INSERT OR IGNORE INTO preferences (name, value) VALUES ('darkMode', 0)");
        await db.execute(
            "INSERT OR IGNORE INTO preferences (name, value) VALUES ('openPdfwithExternalApp', 0)");
        await db.execute(
            "INSERT OR IGNORE INTO preferences (name, value) VALUES ('openEpubwithExternalApp', 0)");
        await db.execute(
            "INSERT OR IGNORE INTO preferences (name, value) VALUES ('bookStorageDirectory', '$bookStorageDefaultDirectory')");
      },
    );
  }

  // Database dbInstance;
  String tableName = 'mybooks';

  Future<void> insert(MyBook book) async {
    final dbInstance = await instance.database;
    await dbInstance.insert(
      tableName,
      book.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> delete(String id) async {
    final dbInstance = await instance.database;
    await dbInstance.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<MyBook?> getId(String id) async {
    final dbInstance = await instance.database;
    List<Map<String, dynamic>> data =
        await dbInstance.query(tableName, where: 'id = ?', whereArgs: [id]);
    List<MyBook> book = listMapToMyBook(data);
    if (book.isNotEmpty) {
      return book.first;
    }
    return null;
  }

  Future<bool> checkIdExists(String id) async {
    final dbInstance = await instance.database;
    List<Map<String, dynamic>> data =
        await dbInstance.query(tableName, where: 'id = ?', whereArgs: [id]);
    List<MyBook> book = listMapToMyBook(data);
    if (book.isNotEmpty) {
      return true;
    }
    return false;
  }

  Future<List<MyBook>> getAll() async {
    final dbInstance = await instance.database;
    final List<Map<String, dynamic>> maps = await dbInstance.query(tableName);
    return listMapToMyBook(maps);
  }

  List<MyBook> listMapToMyBook(List<Map<String, dynamic>> maps) {
    List<MyBook> myBookList = List.generate(maps.length, (i) {
      return MyBook(
          id: maps[i]['id'],
          title: maps[i]['title'],
          author: maps[i]['author'],
          thumbnail: maps[i]['thumbnail'],
          link: maps[i]['link'],
          publisher: maps[i]['publisher'],
          info: maps[i]['info'],
          format: maps[i]['format'],
          description: maps[i]['description']);
    });
    return myBookList.reversed.toList();
  }

  Future<void> saveBookState(String fileName, String position) async {
    final dbInstance = await instance.database;
    await dbInstance.insert(
      'bookposition',
      {'fileName': fileName, 'position': position},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteBookState(String fileName) async {
    final dbInstance = await instance.database;
    await dbInstance.delete(
      'bookposition',
      where: 'fileName = ?',
      whereArgs: [fileName],
    );
  }

  Future<String?> getBookState(String fileName) async {
    final dbInstance = await instance.database;
    List<Map<String, dynamic>> data = await dbInstance
        .query('bookposition', where: 'fileName = ?', whereArgs: [fileName]);
    List<dynamic> dataList = List.generate(data.length, (i) {
      return {'fileName': data[i]['fileName'], 'position': data[i]['position']};
    });
    if (dataList.isNotEmpty) {
      return dataList[0]['position'];
    } else {
      return null;
    }
  }

  Future<void> savePreference(String name, dynamic value) async {
    final db = await database;
    dynamic dbValue;
    
    switch (value.runtimeType) {
      case _ when value is String:
        dbValue = value;
        break;
      case _ when value is int:
        dbValue = value;
        break;
      case _ when value is bool:
        dbValue = value ? 1 : 0;
        break;
      default:
        throw 'Invalid type';
    }

    await db.insert(
      'preferences',
      {'name': name, 'value': dbValue.toString()},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<dynamic> getPreference(String name) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'preferences',
      where: 'name = ?',
      whereArgs: [name],
    );

    if (maps.isEmpty) return null;
    
    final value = maps.first['value'];
    if (value == null) return null;

    // Essayer de convertir en int d'abord
    try {
      return int.parse(value.toString());
    } catch (_) {
      // Si ce n'est pas un int, retourner la valeur telle quelle
      return value;
    }
  }

  Future<void> setBrowserOptions(String name, String value) async {
    final dbInstance = await instance.database;
    await dbInstance.insert(
      'browserOptions',
      {'name': name, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String> getBrowserOptions(String name) async {
    final dbInstance = await instance.database;
    List<Map<String, dynamic>> data = await dbInstance
        .query('browserOptions', where: 'name = ?', whereArgs: [name]);
    List<dynamic> dataList = List.generate(data.length, (i) {
      return {'name': data[i]['name'], 'value': data[i]['value']};
    });
    if (dataList.isNotEmpty) {
      return dataList[0]['value'];
    } else {
      return "";
    }
  }
}
