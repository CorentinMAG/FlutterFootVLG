import 'package:ffootvlg/login_screen.dart';
import 'package:ffootvlg/models/Member.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'HomeScreen.dart';
import 'RegisterScreen.dart';
import 'create_event.dart';
import 'list_users.dart';

void main() {
  runApp(StateContainer(child: MyApp()));
}

class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) =>
          MediaQuery(data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true), child: child),
      debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          // ... app-specific localization delegate[s] here
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      supportedLocales: [
        const Locale('en'),
        const Locale('fr')
      ],
      title: 'FootVLG',
      initialRoute: '/login',
      routes:{
        '/login':(context)=>LoginScreen(),
        '/register':(context) => RegisterScreen(),
        '/home':(context) => HomeScreen(),
        '/listUser':(context) => ListUsers(),
        '/forgotten_password':(context) => ForgottenPassword()
      }
    );
  }
}