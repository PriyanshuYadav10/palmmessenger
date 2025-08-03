import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../data/model/message_model.dart';
import '../data/model/user_model.dart';

class DBService {
  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _init();
    return _db!;
  }

  Future<Database> _init() async {
    final path = join(await getDatabasesPath(), 'chat_secure.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE messages (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            senderId TEXT,
            receiverId TEXT,
            content TEXT,
            encrypted TEXT,
            timestamp TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE users (
            id TEXT PRIMARY KEY,
            name TEXT,
            publicKey TEXT,
            avatarPath TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion == 1 && newVersion == 2) {
          await db.execute('ALTER TABLE users ADD COLUMN avatarPath TEXT');
        }
      },
    );
  }

  Future<void> insertMessage(MessageModel msg) async {
    final database = await db;
    await database.insert('messages', msg.toMap());
  }

  Future<List<MessageModel>> getMessages(String userId1, String userId2) async {
    final database = await db;
    final result = await database.query(
      'messages',
      where: '(senderId = ? AND receiverId = ?) OR (senderId = ? AND receiverId = ?)',
      whereArgs: [userId1, userId2, userId2, userId1],
      orderBy: 'timestamp ASC',
    );
    return result.map((m) => MessageModel.fromMap(m)).toList();
  }

  Future<void> insertUser(UserModel user) async {
    final database = await db;
    await database.insert('users', user.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<UserModel?> getUser(String id) async {
    final database = await db;
    final result = await database.query('users', where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return UserModel.fromMap(result.first);
    }
    return null;
  }

  Future<List<MessageModel>> getLatestMessagesGroupedByPeer(String localUserId) async {
    final database = await db;
    final result = await database.rawQuery('''
      SELECT * FROM messages
      WHERE id IN (
        SELECT MAX(id) FROM messages
        WHERE senderId = ? OR receiverId = ?
        GROUP BY 
          CASE 
            WHEN senderId = ? THEN receiverId 
            ELSE senderId 
          END
      )
      ORDER BY timestamp DESC
    ''', [localUserId, localUserId, localUserId]);

    return result.map((m) => MessageModel.fromMap(m)).toList();
  }
}
