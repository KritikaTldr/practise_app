import 'package:sembast/sembast.dart';
import 'package:sembast_web/sembast_web.dart';

class TokenService {
  static final _store = StoreRef<String, String>('auth');
  static final _dbFuture = databaseFactoryWeb.openDatabase('practise_app.db');

  static Future<void> saveToken(String token) async {
    final db = await _dbFuture;
    await _store.record('access_token').put(db, token);
  }

  static Future<String?> getToken() async {
    final db = await _dbFuture;
    return await _store.record('access_token').get(db);
  }

  static Future<void> clearToken() async {
    final db = await _dbFuture;
    await _store.record('access_token').delete(db);
  }
}
