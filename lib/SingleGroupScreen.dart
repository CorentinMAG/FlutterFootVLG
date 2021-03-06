import 'package:ffootvlg/models/Group.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'evenement_screen.dart';
import 'info_screen.dart';
import 'member_screen.dart';

class SingleGroupScreen extends StatelessWidget {
  final Group group;
  final bool is_admin;

  SingleGroupScreen({@required this.group,this.is_admin});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
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
                icon: Icon(Icons.info),
              ),
              Tab(
                icon: Icon(Icons.event),
              ),
              Tab(
                icon: Icon(Icons.supervisor_account),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            InfoScreen(group: group,is_admin:is_admin),
            EvenementScreen(group:group,is_admin:is_admin),
            MemberScreen(group: group,is_admin:is_admin),
          ],
        ),
      ),
    );

  }
}
