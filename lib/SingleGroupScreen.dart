import 'package:ffootvlg/models/Group.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SingleGroupScreen extends StatelessWidget {
  final Group group;

  SingleGroupScreen({@required this.group});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("${group.groupName}"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed:() => Navigator.of(context).pop(),
          ),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.event),
              ),
              Tab(
                icon: Icon(Icons.supervisor_account),
              )
            ],
          ),
        ),
        body: Center(
          child: Text("Group : ${group.groupName}"),
        ),
      ),
    );

  }
}
