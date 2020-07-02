import 'dart:convert';

import 'package:ffootvlg/models/Event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'models/Group.dart';

Future<Event> CreateOneEvent(Event createGroup) async {
  final http.Response response = await http.post(
    'https://foot.agenda-crna-n.com/createGroup.php',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: json.encode(createGroup.toJson()),
  );
  if (response.statusCode == 200) {
    return Event.fromJson(json.decode(response.body));
  } else {
    throw Exception('Impossible de créer l\'évènement');
  }
}

class EvenementScreen extends StatelessWidget {

  Group group;
  EvenementScreen({@required this.group});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Container(
        child: Column(
          children: <Widget>[
            CreateEvent(group:group)
          ],
        ),
      ),
    );
  }
}
class CreateEvent extends StatefulWidget {

  Group group;
  CreateEvent({@required this.group});

  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {

  final EventNameController = TextEditingController();
  final _createFormkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    if(widget.group.is_group_admin){
      return Container(
        child:Form(
          key: _createFormkey,
          child:Card(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: _buildCreateGroup(),
                ),
                _buildCreateBtn()
              ],
            ),
          ),
        ),
      );
    }else{
      return Container();
    }

  }

  Widget _buildCreateGroup(){
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      controller: EventNameController,
      decoration: InputDecoration(
          border: InputBorder.none,
          labelText: 'Nom de l\'évènement',
          labelStyle: TextStyle(
              color: Colors.black
          ),
          prefixIcon: Icon(
            Icons.create,
            color: Colors.black,
          )
      ),
      style: TextStyle(
          color: Colors.black,
          fontFamily: 'OpenSans'
      ),
      obscureText: false,
      autofocus: false,
      validator: (value) {
        if (value.isEmpty) {
          return 'Ce champ ne peut pas être vide';
        }
        return null;
      },
    );
  }

  validateData(){
    EventNameController.clear();

  }

  Widget _buildCreateBtn(){
    return FlatButton(
      child: Text('CREER'),
      onPressed: (){
        if(_createFormkey.currentState.validate()){
          validateData();
        }
      },
    );
  }
}

