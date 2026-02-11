import 'dart:convert';
import 'dart:io';

class UserDatabase {
  final String dbPath;
  late Map<String, Map<String, dynamic>> _users;

  UserDatabase(this.dbPath) {
    _users = {};
    _load();
  }

  void _load() {
    final file = File(dbPath);
    if (file.existsSync()) {
      final content = file.readAsStringSync();
      if (content.isNotEmpty) {
        final data = jsonDecode(content) as Map<String, dynamic>;
        _users = data.map((k, v) => MapEntry(k, Map<String, dynamic>.from(v)));
      }
    }
  }

  void _save() {
    final file = File(dbPath);
    file.writeAsStringSync(jsonEncode(_users));
  }

  bool usernameOrEmailExists(String username, String email) {
    return _users.values.any((user) =>
        user['username'] == username || user['email'] == email);
  }

  bool addUser(String username, String email, String password) {
    if (usernameOrEmailExists(username, email)) {
      return false;
    }
    _users[username] = {
      'username': username,
      'email': email,
      'password': password, // In production, hash this!
      'createdAt': DateTime.now().toIso8601String(),
    };
    _save();
    return true;
  }

  Map<String, dynamic>? getUser(String username) {
    return _users[username];
  }
}
