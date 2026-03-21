import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';


class UserDatabase {
  static const String _prefsKey = 'user_db';
  late Map<String, Map<String, dynamic>> _users;

  UserDatabase([String? _]) {
    _users = {};
  }

  /*FirebaseDatabase database = FirebaseDatabase.instance;
  await ref.set({
    "username" : ,
    "Email" : ,
    "Password" : ,
  });*/

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final content = prefs.getString(_prefsKey);
    if (content != null && content.isNotEmpty) {
      final data = jsonDecode(content) as Map<String, dynamic>;
      _users = data.map((k, v) => MapEntry(k, Map<String, dynamic>.from(v)));
    }
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, jsonEncode(_users));
  }


  bool usernameOrEmailExists(String username, String email) {
    return _users.values.any((user) =>
        user['username'] == username || user['email'] == email);
  }


  Future<bool> addUser(String username, String email, String password) async {
    if (usernameOrEmailExists(username, email)) {
      return false;
    }
    _users[username] = {
      'username': username,
      'email': email,
      'password': password, // In production, hash this!
      'createdAt': DateTime.now().toIso8601String(),
    };
    await save();
    return true;
  }

  Map<String, dynamic>? getUser(String username) {
    return _users[username];
  }

  // Helper for tests or clearing
  Future<void> clear() async {
    _users.clear();
    await save();
  }
}
