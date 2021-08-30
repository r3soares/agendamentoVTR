import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  static bool _inicializado = false;
  static initDatabase() async {
    if (_inicializado) return;
    // Web.
    await FirebaseFirestore.instance.enablePersistence();
    _inicializado = true;

    // The default value is 40 MB. The threshold must be set to at least 1 MB,
    // and can be set to Settings.CACHE_SIZE_UNLIMITED to disable garbage collection.

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    print(firestore.settings.cacheSizeBytes);
  }
}
