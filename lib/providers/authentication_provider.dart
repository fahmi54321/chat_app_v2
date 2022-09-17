import 'package:chat_app/models/chat_user.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/database_services.dart';
import '../services/navigation_services.dart';

class AuthenticationProvider extends ChangeNotifier {
  late FirebaseAuth _auth;
  late NavigatorServices _navigatorServices;
  late DatabaseServices _databaseServices;

  ChatUser? chatUser;

  AuthenticationProvider() {
    _auth = FirebaseAuth.instance;
    _navigatorServices = GetIt.instance.get<NavigatorServices>();
    _databaseServices = GetIt.instance.get<DatabaseServices>();

    _auth.authStateChanges().listen((user) {
      if (user != null) {
        print('logged in');

        _databaseServices.updateUserLastSeenTime(user.uid);
        _databaseServices.getUser(user.uid).then((snapshot) {
          Map<String, dynamic> userData =
              snapshot.data() as Map<String, dynamic>;
          chatUser = ChatUser.fromJSON({
            'uid': user.uid,
            'name': userData['name'],
            'email': userData['email'],
            'last_active': userData['last_active'],
            'image': userData['image'],
          });

          print(chatUser);

          //go to home page
          _navigatorServices.removeAndNavigateToRoute('/home');
        });
      } else {
        print('Not Authenticated');
        _navigatorServices.removeAndNavigateToRoute('/login');
      }
    });
  }

  Future<void> loginUsingEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      print(_auth.currentUser);
    } on FirebaseAuthException {
      print('error logging user into firebase');
    } catch (e) {
      print(e);
    }
  }

  //todo 4 (next register_page)
  Future<String?> registerUserUsingEmailAndPassword(
    String email,
    String password,
  ) async {
    print('$email $password');

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user?.uid ?? '';
    } on FirebaseAuthException catch (e) {
      print(e);
      print('error registering user');
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> logout() async {
    try {
      _auth.signOut();
    } catch (e) {
      print(e);
    }
  }
}
