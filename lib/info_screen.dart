import 'dart:convert';
import 'dart:ui';

import 'package:ffootvlg/models/Member.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'models/Group.dart';
import 'models/deleteUser.dart';
import 'package:http/http.dart' as http;

Future<String> DeleteOneGroup(DelUser deleteGroup) async {
  final http.Response response = await http.post(
    'https://foot.agenda-crna-n.com/deleteGroup.php',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: json.encode(deleteGroup.toJson()),
  );
  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Impossible de supprimer le groupe');
  }
}

class InfoScreen extends StatelessWidget {
  Group group;
  bool is_admin;
  InfoScreen({@required this.group,this.is_admin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Center(
              child: Column(
                children: <Widget>[
                  Text("Code pour rejoindre le groupe :",style: TextStyle(fontSize: 25.0),),
                  Text("${group.joinCode}",style: TextStyle(fontSize: 25.0),)
                ],
              ),
            ),
            DelButton(group,is_admin)
          ],
        )

      )

    );
  }
}

class DelButton extends StatefulWidget {
  final Group group;
  final bool is_admin;
  DelButton(this.group,this.is_admin);
  @override
  _DelButtonState createState() => _DelButtonState();
}


class _DelButtonState extends State<DelButton> {
  @override
  Widget build(BuildContext context) {
    if(widget.is_admin){
      return Container(
        child: FlatButton(
          child: Text('SUPPRIMER GROUPE',style: TextStyle(color: Colors.red,fontSize: 25,fontWeight: FontWeight.bold),),
          onPressed: ()=> deleteGroup(),
        ),
      );
    }else{
      return Container();
    }
  }

  deleteGroup(){
    DeleteOneGroup(DelUser(user:StateContainer.of(context).user,group:widget.group)).then((value) => {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text(value.toString()))),
      Navigator.pop(context)
    }).catchError((onError)=>{
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text(onError.toString())))
    });
  }
}

