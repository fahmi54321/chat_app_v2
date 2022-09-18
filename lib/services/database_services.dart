import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

const String USER_COLLECTION = 'Users';
const String CHAT_COLLECTION = 'Chats';
const String MESSAGE_COLLECTION = 'messages';

class DatabaseServices {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  DatabaseServices() {}

  Future<void> createUser(
    String uid,
    String email,
    String name,
    String imageUrl,
  ) async {
    try {
      await _db.collection(USER_COLLECTION).doc(uid).set({
        'email': email,
        'image': imageUrl,
        'last_active': DateTime.now().toUtc(),
        'name': name,
      });
    } catch (e) {
      print(e);
    }
  }

  Future<DocumentSnapshot> getUser(String uid) {
    return _db.collection(USER_COLLECTION).doc(uid).get();
  }

  Future<void> updateUserLastSeenTime(String uid) async {
    try {
      await _db.collection(USER_COLLECTION).doc(uid).update(
        {
          'last_active': DateTime.now().toUtc(),
        },
      );
    } catch (e) {
      log(e.toString());
    }
  }

  //todo 1
  Stream<QuerySnapshot> getChatsForUser(String uid) {
    return _db
        .collection(CHAT_COLLECTION)
        .where('members', arrayContains: uid)
        .snapshots();
  }

  //todo 2 (chat_page_provider)
  Future<QuerySnapshot> getLastMessageForChat(String chatId) {
    return _db
        .collection(CHAT_COLLECTION)
        .doc(chatId)
        .collection(MESSAGE_COLLECTION)
        .orderBy('sent_time', descending: true)
        .limit(1)
        .get();
  }
}
