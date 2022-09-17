import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

const String USER_COLLECTION = 'Users';

class CloudStorageServices {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  CloudStorageServices() {}

  //todo 1
  Future<String?> saveUserImageToStorage(
    String uid,
    PlatformFile file,
  ) async {
    try {
      Reference ref =
          _storage.ref().child('images/users/$uid/profile.${file.extension}');

      UploadTask task = ref.putFile(
        File(file.path ?? ""),
      );

      return await task.then(
        (ressult) => ressult.ref.getDownloadURL(),
      );
    } catch (e) {
      print(e);
    }
  }

  //todo 2 (next database_services)
  Future<String?> saveChatImageToStorage(
    String chatId,
    String userId,
    PlatformFile file,
  ) async {
    try {
      Reference _ref = _storage.ref().child(
            'images/chats/$chatId/${userId}_${Timestamp.now().millisecondsSinceEpoch}.${file.extension}',
          );

      UploadTask task = _ref.putFile(
        File(file.path ?? ""),
      );

      return await task.then(
        (ressult) => ressult.ref.getDownloadURL(),
      );
    } catch (e) {
      print(e);
    }
  }
}
