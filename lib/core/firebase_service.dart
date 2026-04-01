import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

/// Firebase Database Service for cloud operations
/// Provides methods to interact with both Firestore and Realtime Database
class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  
  late final FirebaseFirestore _firestore;
  late final FirebaseDatabase _realtimeDb;

  factory FirebaseService() {
    return _instance;
  }

  FirebaseService._internal() {
    _firestore = FirebaseFirestore.instance;
    _realtimeDb = FirebaseDatabase.instance;
  }

  // ============ FIRESTORE OPERATIONS ============

  /// Add a new user to Firestore
  Future<void> addUser({
    required String userId,
    required String username,
    required String email,
    required String password, // Hash in production!
  }) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'username': username,
        'email': email,
        'password': password,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error adding user: $e');
      rethrow;
    }
  }

  /// Get a user by ID from Firestore
  Future<Map<String, dynamic>?> getUser(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      return doc.data();
    } catch (e) {
      print('Error fetching user: $e');
      return null;
    }
  }

  /// Update user data in Firestore
  Future<void> updateUser(
    String userId,
    Map<String, dynamic> data,
  ) async {
    try {
      data['updatedAt'] = FieldValue.serverTimestamp();
      await _firestore.collection('users').doc(userId).update(data);
    } catch (e) {
      print('Error updating user: $e');
      rethrow;
    }
  }

  /// Delete a user from Firestore
  Future<void> deleteUser(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).delete();
    } catch (e) {
      print('Error deleting user: $e');
      rethrow;
    }
  }

  /// Get all users from a collection (streaming)
  Stream<QuerySnapshot> getUsersStream() {
    return _firestore.collection('users').snapshots();
  }

  /// Query users by email
  Future<QuerySnapshot> queryUserByEmail(String email) async {
    return _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
  }

  /// Add a user achievement
  Future<void> addAchievement({
    required String userId,
    required String achievementId,
    required String title,
    required String description,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('achievements')
          .doc(achievementId)
          .set({
        'title': title,
        'description': description,
        'unlockedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error adding achievement: $e');
      rethrow;
    }
  }

  /// Get user achievements
  Future<QuerySnapshot> getUserAchievements(String userId) async {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('achievements')
        .get();
  }

  /// Add leaderboard entry
  Future<void> addLeaderboardEntry({
    required String userId,
    required String username,
    required int score,
    required int stepsCount,
  }) async {
    try {
      await _firestore.collection('leaderboard').doc(userId).set({
        'username': username,
        'score': score,
        'stepsCount': stepsCount,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error adding leaderboard entry: $e');
      rethrow;
    }
  }

  /// Get leaderboard (top 100 by score)
  Future<QuerySnapshot> getLeaderboard() async {
    return _firestore
        .collection('leaderboard')
        .orderBy('score', descending: true)
        .limit(100)
        .get();
  }

  // ============ REALTIME DATABASE OPERATIONS ============

  /// Add data to Realtime Database
  Future<void> writeToRealtimeDb(String path, Map<String, dynamic> data) async {
    try {
      await _realtimeDb.ref(path).set(data);
    } catch (e) {
      print('Error writing to realtime db: $e');
      rethrow;
    }
  }

  /// Read data from Realtime Database
  Future<Map<dynamic, dynamic>?> readFromRealtimeDb(String path) async {
    try {
      final event = await _realtimeDb.ref(path).once();
      if (event.snapshot.value != null) {
        return event.snapshot.value as Map<dynamic, dynamic>;
      }
      return null;
    } catch (e) {
      print('Error reading from realtime db: $e');
      return null;
    }
  }

  /// Listen to Realtime Database changes (streaming)
  Stream<DatabaseEvent> listenToRealtimeDb(String path) {
    return _realtimeDb.ref(path).onValue;
  }

  /// Update data in Realtime Database
  Future<void> updateRealtimeDb(String path, Map<String, dynamic> data) async {
    try {
      await _realtimeDb.ref(path).update(data);
    } catch (e) {
      print('Error updating realtime db: $e');
      rethrow;
    }
  }

  /// Batch write to Firestore
  Future<void> batchWrite(
    List<Map<String, dynamic>> usersData,
  ) async {
    try {
      final batch = _firestore.batch();
      for (var userData in usersData) {
        final docRef = _firestore
            .collection('users')
            .doc(userData['userId'] as String);
        batch.set(docRef, userData);
      }
      await batch.commit();
    } catch (e) {
      print('Error in batch write: $e');
      rethrow;
    }
  }
}
