import 'package:ffootvlg/models/Group.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SingleGroupScreen extends StatelessWidget {
  final Group group;

  SingleGroupScreen({@required this.group});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed:() => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Text("Group : ${group.groupName}"),
      ),
    );
  }
}
