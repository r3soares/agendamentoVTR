import 'package:firebase_core/firebase_core.dart';

class ConnectionDatabase {
  static initConnection() async {
    await Firebase.initializeApp();
  }
}
