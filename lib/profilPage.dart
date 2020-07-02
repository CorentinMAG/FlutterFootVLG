import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'models/Member.dart';

class ProfilPage extends StatelessWidget {
  final Member user;
  ProfilPage({@required this.user});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text(user.last_name),
            Text(user.first_name),
            Text(user.email),
            Text(user.phone_number),
            Text(user.birthday)
          ],
        ),
      )
    );
  }
}

