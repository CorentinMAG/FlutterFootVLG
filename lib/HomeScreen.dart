import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'models/Member.dart';

class HomeScreen extends StatelessWidget {
  final Member user;

  HomeScreen(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('FootVLG'),
      ),
      body: Center(
        child: Text('Bienvenue ${user.last_name.toUpperCase()} ${user.first_name}'),
      ),
    );
  }
}
