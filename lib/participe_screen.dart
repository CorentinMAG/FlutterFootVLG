import 'dart:convert';

import 'package:ffootvlg/models/Event.dart';
import 'package:ffootvlg/models/createEvent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'models/Member.dart';


Future<String> _joinequipeA(CreateFirstEvent member) async {
  final http.Response response = await http.post(
    'https://foot.agenda-crna-n.com/joinTeam.php',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: json.encode(member.toJson()),
  );
  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Impossible pour l\'utilisateur de rejoindre l\'équipe');
  }
}

Future<String> _joinequipeB(CreateFirstEvent member) async {
  final http.Response response = await http.post(
    'https://foot.agenda-crna-n.com/joinTeam.php',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: json.encode(member.toJson()),
  );
  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Impossible pour l\'utilisateur de rejoindre l\'équipe');
  }
}


class ParticipeScreen extends StatefulWidget {
  final Event event;
  final bool is_admin;
  ParticipeScreen({@required this.event,this.is_admin});
  @override
  _ParticipeScreenState createState() => _ParticipeScreenState();
}

class _ParticipeScreenState extends State<ParticipeScreen> {

  @override
  Widget build(BuildContext context) {
    var participe = widget.event.members.where((element) => element.status=="participe").toList();
    return Container(
      child: ListView.builder(
          padding: EdgeInsets.all(16.0),
          itemCount: participe.length,
          itemBuilder: (BuildContext context, int index) {
            return _tile(member:participe[index],event: widget.event,is_admin:widget.is_admin);
          }
      ),
    );
  }

}
class _tile extends StatefulWidget {
  final Member member;
  final Event event;
  final bool is_admin;

  _tile({this.member,this.event,this.is_admin});
  @override
  __tileState createState() => __tileState();
}

class __tileState extends State<_tile> {
  bool teamA;
  bool teamB;


  @override
  void initState() {
    teamA = widget.member.is_teamA ?? false;
    teamB = widget.member.is_teamB ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
            title: Text("${widget.member.last_name.toUpperCase()} ${widget.member.first_name}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                InkWell(
                  onTap: (){
                    if(widget.is_admin)
                    setState(() {
                      teamA = !teamA;
                      widget.member.is_teamA = teamA;
                      final joinEquipeA = CreateFirstEvent(creator: widget.member,event: widget.event);
                      _joinequipeA(joinEquipeA);
                    });
                  },
                  child: Column(
                    children: <Widget>[
                      teamA  ? Icon(Icons.flag,color: Colors.blue,) : Icon(Icons.flag,),
                      teamA  ? Text('Equipe A',style: TextStyle(color: Colors.blue),) : Text('Equipe A'),
                    ],
                  ),
                ),
                SizedBox(width: 24.0,),
                InkWell(
                  onTap: (){
                    if(widget.is_admin)
                    setState(() {
                      teamB = !teamB;
                      widget.member.is_teamB = teamB;
                      final joinEquipeA = CreateFirstEvent(creator: widget.member,event: widget.event);
                      _joinequipeB(joinEquipeA);
                    });
                  },
                  child: Column(
                    children: <Widget>[
                      teamB  ? Icon(Icons.flag,color: Colors.red,):Icon(Icons.flag,),
                      teamB  ? Text('Equipe B',style: TextStyle(color: Colors.red),):Text('Equipe B'),
                    ],
                  ),
                ),
              ],
            )

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




