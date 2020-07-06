import 'package:ffootvlg/login_screen.dart';
import 'package:ffootvlg/models/Member.dart';
import 'package:flutter/material.dart';

import 'HomeScreen.dart';
import 'RegisterScreen.dart';
import 'list_event.dart';
import 'list_users.dart';

void main() {
  runApp(StateContainer(child: MyApp()));
}

class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FootVLG',
      initialRoute: '/login',
      routes:{
        '/login':(context)=>LoginScreen(),
        '/register':(context) => RegisterScreen(),
        '/home':(context) => HomeScreen(),
        '/listUser':(context) => ListUsers(),
      }
    );
  }
}