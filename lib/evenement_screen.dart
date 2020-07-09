import 'dart:convert';
import 'dart:ui';

import 'package:ffootvlg/create_event.dart';
import 'package:ffootvlg/list_event.dart';
import 'package:ffootvlg/models/Event.dart';
import 'package:ffootvlg/models/Member.dart';
import 'package:ffootvlg/models/updateEvent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'models/Group.dart';

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

  @override
  Widget build(BuildContext context) {
      return Column(
        mainAxisSize: MainAxisSize.max,
          children: <Widget>[
           if(widget.is_admin)
             _buildCreateBtn() ,
            Expanded(
              child: ListEvent(),
            )
          ],
        );
  }

  Widget _buildCreateBtn(){
    Intl.defaultLocale ='fr_FR';
    return Container(
      width: double.infinity,
      child:FlatButton(
          child: Text('CREER'),
          onPressed: (){
            _displayResult(context);
          }
      ),
    );

  }
  _displayResult(BuildContext context) async{
    final newEvent = await Navigator.push(context,
    MaterialPageRoute(builder: (context)=>CreateEventForm(group: widget.group,)));
    if(newEvent!=null){
      setState(() {
        widget.group.events.add(newEvent);
      });
    }
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

  CheckUpdate(String vote,Member user,Event event,List<bool> isSelected){
    UpdateVote myVote = UpdateVote(user:user,event:event,vote:vote);
    if(vote!=event.vote){
      Voted(myVote).then((value) => {
        if(vote=='participe'){
          setState((){
            event.participe++;
            isSelected=[true,false,false];
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
            isSelected=[false,true,false];
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
            isSelected=[false,false,true];
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
    List<bool> isSelected;
    event.vote=='participe'? isSelected=[true, false, false] : event.vote=='participe_pas'? isSelected=[false, true, false] :isSelected=[false, false, true];
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
                  title: Text(event.name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0),),
                  subtitle: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 8.0,),
                      Text("${DateFormat.yMMMMd().format(DateTime.parse(event.datetime))} ${event.datetime.split(" ")[1].split(".")[0]}",style: TextStyle(fontWeight: FontWeight.bold),),
                      Text("${event.endroit}",style: TextStyle(fontWeight: FontWeight.bold),),
                      SizedBox(height: 8.0,),
                      Text("${event.description}")
                    ],
                  ),
                  onTap: ()=>{
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => ListEventMember(event:event,is_admin:is_admin))),
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
                    ToggleButtons(
                      children: <Widget>[
                          FlatButton(
                              child: Text('Je participe ${event.participe}',style: TextStyle(color: Colors.green),),
                              onPressed: ()=>{
                              CheckUpdate('participe',StateContainer.of(context).user,event,isSelected)
                              },
                          ),
                          FlatButton(
                              child: Text('Je ne participe pas ${event.participe_pas}',style: TextStyle(color: Colors.red),),
                              onPressed: ()=>{
                              CheckUpdate('participe_pas',StateContainer.of(context).user,event,isSelected)
                              },
                          ),
                          FlatButton(
                              child: Text('Peut être ${event.peut_etre}',style: TextStyle(color: Colors.orange),),
                              onPressed: ()=>{
                              CheckUpdate('peut_etre',StateContainer.of(context).user,event,isSelected)
                              },
                          ),

                      ],
                      renderBorder: false,
                      onPressed: (int index) {
                        setState(() {
                          isSelected[index] = !isSelected[index];
                        });
                      },
                      isSelected: isSelected,
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

