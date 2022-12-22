import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Store {
  final storage = FlutterSecureStorage();
  Future<void> storeData(String loggedinUser) async {
    await storage.write(key: 'user', value: loggedinUser);
  }

  Future<String?> getData() async {
    return await storage.read(key: 'user');
  }

  Future<void> logOut() async {
    try {
      await storage.delete(key: 'user');
    } catch (e) {
      print(e);
    }
  }
}
