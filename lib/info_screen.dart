import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'models/Group.dart';

class InfoScreen extends StatelessWidget {
  Group group;
  InfoScreen({@required this.group});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Text("Code pour rejoindre le groupe : ${group.joinCode}"),
      ),
    );
  }
}
