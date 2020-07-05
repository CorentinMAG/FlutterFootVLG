import 'dart:convert';

import 'package:ffootvlg/models/Event.dart';
import 'package:ffootvlg/models/Member.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'models/Group.dart';
import 'models/createEvent.dart';

Future<Event> CreateOneEvent(CreateFirstEvent createevent) async {
  final http.Response response = await http.post(
    'https://foot.agenda-crna-n.com/createEvent.php',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: json.encode(createevent.toJson()),
  );
  if (response.statusCode == 200) {
    return Event.fromJson(json.decode(response.body));
  } else {
    throw Exception('Impossible de créer l\'évènement');
  }
}

Future<List<Event>> RetrieveEvent(Member user) async {
  final http.Response response = await http.post(
    'https://foot.agenda-crna-n.com/getUserEvent.php',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: json.encode(user.toJson()),
  );
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body) ?? [];
    return jsonResponse.map((event) => Event.fromJson(event)).toList();
  } else {
    throw Exception('Impossible de récupérer les évènements');
  }
}

class EvenementScreen extends StatelessWidget {

  Group group;
  bool is_admin;
  EvenementScreen({@required this.group,this.is_admin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: CreateEvent(group: group,is_admin:is_admin)
      );
  }
}
class CreateEvent extends StatefulWidget {

  Group group;
  bool is_admin;
  CreateEvent({@required this.group,this.is_admin});

  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {

  List<Event> events=<Event>[];

  final EventNameController = TextEditingController();
  final EventDescriptionController = TextEditingController();
  final _createFormkey = GlobalKey<FormState>();

  @override
  void dispose() {
    EventNameController.dispose();
    EventDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
      return Column(
          children: <Widget>[
           if(widget.is_admin)
            EventForm(),
            Expanded(
              child: _futurebuilder(),
            )
          ],
        );
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

  Widget _buildDescription(){
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      controller: EventDescriptionController,
      decoration: InputDecoration(
          border: InputBorder.none,
          labelText: 'Description de l\'évènement',
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

    var createevent = CreateFirstEvent(creator: StateContainer.of(context).user,name:EventNameController.text,id_group:widget.group.id,description: EventDescriptionController.text);
    CreateOneEvent(createevent).then((value) => {
      setState((){
        events.add(value);
      }),
    EventNameController.clear(),
      EventDescriptionController.clear(),
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text("Vous avez rejoins l\'évènement ${value.name}")))

    }).catchError((onError)=>{
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text(onError.toString())))
    });

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

  Widget EventForm(){
    return Form(
      key: _createFormkey,
      child:Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: Card(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: _buildCreateGroup(),
                  ),
                  Expanded(
                    child: _buildDescription(),
                  ),
                  _buildCreateBtn()
                ],
              ),
            ),
          )
        ],
      )
    );
  }

  Widget _futurebuilder(){
    var user = StateContainer.of(context).user;
    user.actual_group=widget.group.id;
    return FutureBuilder<List<Event>>(
      future: RetrieveEvent(user),
      builder: (context,snapshot){
        if(snapshot.hasData){
          events = snapshot.data;
          return ListEvent(events);
        }else if(snapshot.hasError){
          return Text("${snapshot.error}");
        }
        return Container(
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
                strokeWidth: 10,
              ),
            )
        );
      },
    );
  }

  Widget ListEvent(data) {
    return Container(
      child:ListView.builder(
          padding: EdgeInsets.all(16.0),
          itemCount: data.length,
          itemBuilder: (BuildContext context, int index) {

            return _tile(data[index]);
          }
      ) ,
    );

  }
  Widget _tile(event){
    return Column(
      children: <Widget>[
        Container(
          child: Card(
            child: Column(
                mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.public),
                  title: Text(event.name),
                  subtitle: Text(event.description),
                ),
                ButtonBar(
                  children: <Widget>[
                    FlatButton(
                      child: Text('Je participe',style: TextStyle(color: Colors.green),),
                      onPressed: ()=>{},
                    ),
                    FlatButton(
                      child: Text('Je ne participe pas',style: TextStyle(color: Colors.red),),
                      onPressed: ()=>{},
                    ),
                    FlatButton(
                      child: Text('Peut être',style: TextStyle(color: Colors.orange),),
                      onPressed: ()=>{},
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

