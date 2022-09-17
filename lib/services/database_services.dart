import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

const String USER_COLLECTION = 'Users';
const String CHAT_COLLECTION = 'Chats';
const String MESSAGE_COLLECTION = 'Messages';

class DatabaseServices {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  DatabaseServices() {}

  //todo 3 (next authentication_provider)
  Future<void> createUser(
    String uid,
    String email,
    String name,
    String imageUrl,
  ) async {

    try{
      await _db.collection(USER_COLLECTION).doc(uid).set({
        'email' : email,
        'image' : imageUrl,
        'last_active' : DateTime.now().toUtc(),
        'name' : name,
      });
    }catch(e){
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
}
