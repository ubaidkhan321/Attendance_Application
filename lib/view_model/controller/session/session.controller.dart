import 'package:attendance_system_app/model/login.model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SessionController {
  SessionController._internal();
  static final SessionController _instance = SessionController._internal();
  static SessionController get instance => _instance;

  LoginModel userSession = LoginModel();

  Future<void> setSession(
    String? id,
    String? name,
    String? type,
  ) async {
    userSession.data = Data(sId: id, name: name, type: type);

    const storage = FlutterSecureStorage();
    await storage.write(key: 'sid', value: id.toString());
    await storage.write(key: 'name', value: name.toString());
    await storage.write(key: 'type', value: type.toString());
  }

  Future<void> loadSession() async {
    const storage = FlutterSecureStorage();
    final id = await storage.read(key: 'sid');
    final name = await storage.read(key: 'name');
    final type = await storage.read(key: 'type');
    userSession.data = Data(sId: id, name: name, type: type);

    if (kDebugMode) {
      print("Session Loaded:");
      print("sid: ${userSession.data?.sId}");
      print("name: ${userSession.data?.name}");
      print("type: ${userSession.data?.type}");
    }
  }

  Future<void> clearSession() async {
    userSession = LoginModel();

    const storage = FlutterSecureStorage();
    await Future.wait([
      storage.delete(key: 'sid'),
      storage.delete(key: 'name'),
      storage.delete(key: 'type'),
    ]);
  }
}
