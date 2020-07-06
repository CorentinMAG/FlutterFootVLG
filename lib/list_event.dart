import 'package:ffootvlg/models/Event.dart';
import 'package:ffootvlg/participe_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListEventMember extends StatelessWidget {
  final Event event;

  ListEventMember({@required this.event});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("${event.name}"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed:() => Navigator.of(context).pop(),
          ),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.supervisor_account),
                text: "participe",
              ),
              Tab(
                icon: Icon(Icons.supervisor_account),
                text: "ne participe pas",
              ),
              Tab(
                icon: Icon(Icons.supervisor_account),
                text: "peut être",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            ParticipeScreen(event:event),
            ParticipePasScreen(event:event),
            PeutEtreScreen(event:event),
          ],
        ),
      ),
    );;
  }
}