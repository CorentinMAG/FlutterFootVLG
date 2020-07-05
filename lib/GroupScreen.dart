import 'dart:convert';

import 'package:ffootvlg/SingleGroupScreen.dart';
import 'package:ffootvlg/models/Group.dart';
import 'package:ffootvlg/models/createGroup.dart';
import 'package:ffootvlg/models/joinGroup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'models/Member.dart';

Future<Group> CreateOneGroup(CreateGroup createGroup) async {
  final http.Response response = await http.post(
    'https://foot.agenda-crna-n.com/createGroup.php',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: json.encode(createGroup.toJson()),
  );
  if (response.statusCode == 200) {
    return Group.fromJson(json.decode(response.body));
  } else {
    throw Exception('Impossible de créer le groupe');
  }
}

Future<Group> JoinOneGroup(JoinGroup joinGroup) async {
  final http.Response response = await http.post(
    'https://foot.agenda-crna-n.com/joinGroup.php',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: json.encode(joinGroup.toJson()),
  );
  if (response.statusCode == 200) {
    return Group.fromJson(json.decode(response.body));
  } else {
    throw Exception('Impossible de rejoindre le groupe, vérifier le code');
  }
}


Future<List<Group>> RetrieveGroup(Member user) async {
  final http.Response response = await http.post(
    'https://foot.agenda-crna-n.com/getGroups.php',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: json.encode(user),
  );
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body) ?? [];
    return jsonResponse.map((group) => Group.fromJson(group)).toList();

  } else {
    throw Exception('Impossible de récupérer les groupes');
  }
}

class GroupScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FootVLG'),
      ),
      backgroundColor: Colors.blue,
      body: GroupPage(),
    );
  }
}


class GroupPage extends StatefulWidget {

  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {

  final _createFormkey = GlobalKey<FormState>();
  final _joinFormKey = GlobalKey<FormState>();

  List<Group> groups = <Group>[];

  final GroupNameController = TextEditingController();
  final JoinCodeController = TextEditingController();

  Widget _buildCreateGroup(){
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      controller: GroupNameController,
      decoration: InputDecoration(
          border: InputBorder.none,
          labelText: 'Nom du groupe',
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

  validateData(){
    final createGroup = CreateGroup(
      creator: StateContainer.of(context).user,
      groupName: GroupNameController.text
    );
    GroupNameController.clear();
    CreateOneGroup(createGroup).then((value) => {
    setState(() {
      groups.add(value);
    }),
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text("Le groupe ${value.groupName} a été créé")))
    }).catchError((onError)=>{
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text(onError.toString())))
    });
  }


  @override
  void dispose() {
    GroupNameController.dispose();
    JoinCodeController.dispose();
    super.dispose();
  }


  Widget _buildJoinBtn(){
    return FlatButton(
      child: Text('REJOINDRE'),
      onPressed: (){
        if(_joinFormKey.currentState.validate()){
          validateJoinForm();
        }
      },
    );
  }
  Widget _buildJoinGroup(){
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      controller: JoinCodeController,
      decoration: InputDecoration(
          border: InputBorder.none,
          labelText: 'Code',
          labelStyle: TextStyle(
              color: Colors.black
          ),
          prefixIcon: Icon(
            Icons.code,
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

  validateJoinForm(){
    final joinGroup = JoinGroup(
      user: StateContainer.of(context).user,
      code: JoinCodeController.text
    );
    JoinCodeController.clear();
    JoinOneGroup(joinGroup).then((value) => {
      setState((){
        groups.add(value);
      }),
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text("Vous avez rejoins le groupe ${value.groupName}")))

    }).catchError((onError) => {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text(onError.toString())))
    });

  }

  Widget JoinForm(){
    return Form(
      key: _joinFormKey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: Card(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: _buildJoinGroup(),
                  ),
                  _buildJoinBtn()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget CreateForm(){
      return Form(
          key: _createFormkey,
          child:Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child:Card(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child:_buildCreateGroup() ,
                      ),
                      _buildCreateBtn()
                    ],
                  ),
                ),
              ) //_joinJroup(),// _listGroup()
            ],
          )
      );
    }

  Widget ListGroup(data) {
    return Container(
      child:ListView.builder(
          padding: EdgeInsets.all(16.0),
          itemCount: groups.length,
          itemBuilder: (BuildContext context, int index) {

            return _tile(data[index]);
          }
      ) ,
    );

  }
  Widget _tile(group){
    bool is_admin;
    group.members.forEach((member) {
      if(member.id==StateContainer.of(context).user.id){
        is_admin=member.is_group_admin;
      }
    });
    return Column(
      children: <Widget>[
          ListTile(
              title: RichText(
                text: TextSpan(
                    text: group.groupName,
                    style: TextStyle(color: Colors.white,fontSize: 20),
                ),
              ),
            onTap: ()=>{
                FocusScope.of(context).requestFocus(new FocusNode()),
                Navigator.push(context, MaterialPageRoute(builder: (context) => SingleGroupScreen(group:group,is_admin:is_admin)))
            },
          ),
        Divider(),
      ],
    );
  }

  Widget _futurebuilder(){
    return FutureBuilder<List<Group>>(
      future: RetrieveGroup(StateContainer.of(context).user),
      builder: (context,snapshot){
        if(snapshot.hasData){
          groups = snapshot.data;
          return ListGroup(groups);
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



  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CreateForm(),
        JoinForm(),
        Expanded(
          child: _futurebuilder(),
        )
      ],
    );
  }
}
