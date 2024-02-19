import 'package:firebase_database/firebase_database.dart';

class DBService {
  final FirebaseDatabase _dbInstance = FirebaseDatabase.instance;
}

void convertMap(Map<dynamic, dynamic> oldMap, Map<String, dynamic> newMap) {
  oldMap.forEach((key, value) {
    newMap[key as String] = value;
  });
}