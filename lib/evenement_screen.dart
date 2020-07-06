import 'dart:convert';

import 'package:ffootvlg/list_event.dart';
import 'package:ffootvlg/models/Event.dart';
import 'package:ffootvlg/models/Member.dart';
import 'package:ffootvlg/models/updateEvent.dart';
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

Future<String> Voted(UpdateVote vote) async {
  final http.Response response = await http.post(
    'https://foot.agenda-crna-n.com/updateUserChoice.php',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: json.encode(vote.toJson()),
  );
  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Impossible pour l\'utilisateur de voter');
  }
}

Future<String> deleteEvent(Event event) async {
  final http.Response response = await http.post(
    'https://foot.agenda-crna-n.com/deleteEvent.php',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: json.encode(event.toJson()),
  );
  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Impossible de supprimer l\'event');
  }
}

class EvenementScreen extends StatelessWidget {

  Group group;
  bool is_admin;
  EvenementScreen({@required this.group,this.is_admin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: ListEvent(),
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
        widget.group.events.add(value);
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

  Widget ListEvent() {
    return Container(
      child:ListView.builder(
          itemCount: widget.group.events.length,
          itemBuilder: (BuildContext context, int index) {
            return _tile(widget.group.events[index]);
          }
      ) ,
    );
  }

  CheckUpdate(String vote,Member user,Event event){
    UpdateVote myVote = UpdateVote(user:user,event:event,vote:vote);
    if(vote!=event.vote){
      Voted(myVote).then((value) => {
        if(vote=='participe'){
          setState((){
            event.participe++;
          }),
          if(event.vote=="participe_pas"){
            setState((){
              event.participe_pas--;
            })
          }else if(event.vote=="peut_etre"){
            setState((){
              event.peut_etre--;
            })
          },
          event.vote='participe'
        }else if(vote=='participe_pas'){
          setState((){
            event.participe_pas++;
          }),
          if(event.vote=="participe"){
            setState((){
              event.participe--;
            })
          }else if(event.vote=="peut_etre"){
            setState((){
              event.peut_etre--;
            })
          },
          event.vote='participe_pas'
        }else{
          setState((){
            event.peut_etre++;
          }),
          if(event.vote=="participe_pas"){
            setState((){
              event.participe_pas--;
            })
          }else if(event.vote=="participe"){
            setState((){
              event.participe--;
            })
          },
          event.vote='peut_etre'
        },
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text(value.toString())))
      }).catchError((onError)=>{
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text(onError.toString())))
      });

    }
  }

  deleteevent(event){
    deleteEvent(event).then((value) => {
      setState((){
        widget.group.events.remove(event);
      }),
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(value.toString()))),
    }).catchError((onError)=>{
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(onError.toString()))),
    });
  }

  Widget _tile(Event event){
    var user = event.members.firstWhere((element) => element.email==StateContainer.of(context).user.email);
    var is_admin=user.is_event_admin;
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
                  onTap: ()=>{
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => ListEventMember(event:event))),
                  },
                  trailing: Column(
                    children: <Widget>[
                      if(is_admin)
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: ()=>{
                            deleteevent(event)
                          },
                        ),
                    ],
                  ),
                ),
                ButtonBar(
                  children: <Widget>[
                    FlatButton(
                      child: Text('Je participe ${event.participe}',style: TextStyle(color: Colors.green),),
                      onPressed: ()=>{
                        CheckUpdate('participe',StateContainer.of(context).user,event)
                      },
                    ),
                    FlatButton(
                      child: Text('Je ne participe pas ${event.participe_pas}',style: TextStyle(color: Colors.red),),
                      onPressed: ()=>{
                        CheckUpdate('participe_pas',StateContainer.of(context).user,event)
                      },
                    ),
                    FlatButton(
                      child: Text('Peut être ${event.peut_etre}',style: TextStyle(color: Colors.orange),),
                      onPressed: ()=>{
                        CheckUpdate('peut_etre',StateContainer.of(context).user,event)
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

