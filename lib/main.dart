import 'package:ffootvlg/login_screen.dart';
import 'package:flutter/material.dart';

import 'HomeScreen.dart';
import 'RegisterScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FootVLG',
      initialRoute: '/login',
      routes:{
        '/login':(context)=>LoginScreen(),
        '/register':(context) => RegisterScreen(),
      }
    );
  }
}