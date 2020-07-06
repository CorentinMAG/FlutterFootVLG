import 'package:ffootvlg/models/Event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'models/Member.dart';

class ParticipeScreen extends StatelessWidget {
  final Event event;
  ParticipeScreen({@required this.event});
  @override
  Widget build(BuildContext context) {
    var participe = event.members.where((element) => element.status=="participe").toList();
    return Container(
      child: ListView.builder(
          padding: EdgeInsets.all(16.0),
          itemCount: participe.length,
          itemBuilder: (BuildContext context, int index) {
            return _tile(participe[index]);
          }
      ),
    );
  }
  Widget _tile(Member member){
    return Column(
      children: <Widget>[
        ListTile(
          title: Text("${member.last_name.toUpperCase()} ${member.first_name}"),
        ),
        Divider()
      ],
    );
  }
}

class ParticipePasScreen extends StatelessWidget {
  final Event event;
  ParticipePasScreen({@required this.event});
  @override
  Widget build(BuildContext context) {
    var participe_pas = event.members.where((element) => element.status=="participe_pas").toList();
    return Container(
      child: ListView.builder(
          padding: EdgeInsets.all(16.0),
          itemCount: participe_pas.length,
          itemBuilder: (BuildContext context, int index) {
            return _tile(participe_pas[index]);
          }
      ),
    );
  }
  Widget _tile(Member member){
    return Column(
      children: <Widget>[
        ListTile(
          title: Text("${member.last_name.toUpperCase()} ${member.first_name}"),
        ),
        Divider()
      ],
    );
  }
}

class PeutEtreScreen extends StatelessWidget {
  final Event event;
  PeutEtreScreen({@required this.event});
  @override
  Widget build(BuildContext context) {
    var peut_etre = event.members.where((element) => element.status=="peut_etre").toList();
    return Container(
      child: ListView.builder(
          padding: EdgeInsets.all(16.0),
          itemCount: peut_etre.length,
          itemBuilder: (BuildContext context, int index) {
            return _tile(peut_etre[index]);
          }
      ),
    );
  }
  Widget _tile(Member member){
    return Column(
      children: <Widget>[
        ListTile(
          title: Text("${member.last_name.toUpperCase()} ${member.first_name}"),
        ),
        Divider()
      ],
    );
  }
}




