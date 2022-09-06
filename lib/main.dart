import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/pages/splash_page.dart';
import 'package:chat_app/providers/authentication_provider.dart';
import 'package:chat_app/services/navigation_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async{
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashPage(onInitializationComplete: () {
        runApp(const MainApp());
      }),
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: AuthenticationProvider(),
        ),
      ],
      child: MaterialApp(
        navigatorKey: NavigatorServices.navigatorKey,
        initialRoute: '/login',
        routes: {
          '/login': (BuildContext context) => LoginPage(),
          '/home': (BuildContext context) => HomePage(),
        },
      ),
    );
  }
}
