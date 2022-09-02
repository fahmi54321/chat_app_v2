import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/database_services.dart';
import '../services/navigation_services.dart';

class AuthenticationProvider extends ChangeNotifier {

  late FirebaseAuth _auth;
  late NavigatorServices _navigatorServices;
  late DatabaseServices _databaseServices;

  AuthenticationProvider() {
    _auth = FirebaseAuth.instance;
    _navigatorServices = GetIt.instance.get<NavigatorServices>();
    _databaseServices = GetIt.instance.get<DatabaseServices>();

    //todo 1 (finish)
    _auth.authStateChanges().listen((user) {
      if(user!=null){
        print('logged in');
      }else{
        print('Not Authenticated');
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
}
