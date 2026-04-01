import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDatabase {
  static const String _prefsKey = 'user_db';
  late Map<String, Map<String, dynamic>> _users;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserDatabase([String? _]) {
    _users = {};
  }

  /// Load users from local cache (SharedPreferences)
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final content = prefs.getString(_prefsKey);
    if (content != null && content.isNotEmpty) {
      final data = jsonDecode(content) as Map<String, dynamic>;
      _users = data.map((k, v) => MapEntry(k, Map<String, dynamic>.from(v)));
    }
  }

  /// Save users to local cache
  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, jsonEncode(_users));
  }

  /// Check if username or email already exists in Firestore
  Future<bool> usernameOrEmailExists(String username, String email) async {
    try {
      final usernameDoc = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();
      final emailDoc = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      return usernameDoc.docs.isNotEmpty || emailDoc.docs.isNotEmpty;
    } catch (e) {
      print('Error checking existence: $e');
      // Fall back to local check
      return _users.values.any((user) =>
          user['username'] == username || user['email'] == email);
    }
  }

  /// Add a new user to both local cache and Firestore
  Future<bool> addUser(String username, String email, String password) async {
    try {
      // Check if user already exists
      final exists = await usernameOrEmailExists(username, email);
      if (exists) {
        return false;
      }

      final userData = {
        'username': username,
        'email': email,
        'password': password, // IMPORTANT: Hash this in production!
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      };

      // Add to Firestore
      await _firestore.collection('users').doc(email).set(userData);

      // Also add to local cache
      _users[username] = userData;
      await save();
      return true;
    } catch (e) {
      print('Error adding user: $e');
      return false;
    }
  }

  /// Get a user by username from local cache
  Map<String, dynamic>? getUser(String username) {
    return _users[username];
  }

  /// Get a user from Firestore by email
  Future<Map<String, dynamic>?> getUserFromFirebase(String email) async {
    try {
      final doc = await _firestore.collection('users').doc(email).get();
      return doc.data();
    } catch (e) {
      print('Error fetching user from Firebase: $e');
      return null;
    }
  }

  /// Update user data in Firestore
  Future<bool> updateUserInFirebase(
    String email,
    Map<String, dynamic> updates,
  ) async {
    try {
      updates['updatedAt'] = DateTime.now().toIso8601String();
      await _firestore.collection('users').doc(email).update(updates);
      return true;
    } catch (e) {
      print('Error updating user: $e');
      return false;
    }
  }

  /// Get all users from Firestore (streaming)
  Stream<QuerySnapshot> getAllUsersStream() {
    return _firestore.collection('users').snapshots();
  }

  /// Helper for clearing local cache
  Future<void> clear() async {
    _users.clear();
    await save();
  }
}
