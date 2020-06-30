import 'dart:convert';

import 'package:ffootvlg/SingleGroupScreen.dart';
import 'package:ffootvlg/models/Group.dart';
import 'package:ffootvlg/models/createGroup.dart';
import 'package:ffootvlg/models/joinGroup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'models/Member.dart';

Future<String> CreateOneGroup(CreateGroup createGroup) async {
  final http.Response response = await http.post(
    'https://foot.agenda-crna-n.com/createGroup.php',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: json.encode(createGroup.toJson()),
  );
  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Impossible de créer le groupe');
  }
}

Future<String> JoinOneGroup(JoinGroup joinGroup) async {
  final http.Response response = await http.post(
    'https://foot.agenda-crna-n.com/joinGroup.php',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: json.encode(joinGroup.toJson()),
  );
  if (response.statusCode == 200) {
    return response.body;
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
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((group) => Group.fromJson(group)).toList();

  } else {
    throw Exception('Impossible de récupérer les groupes');
  }
}

class GroupScreen extends StatelessWidget {

  final Member user;

  GroupScreen({@required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: GroupPage(user:user),
    );
  }
}


class GroupPage extends StatefulWidget {

  final Member user;

  GroupPage({@required this.user});


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
      creator: widget.user,
      groupName: GroupNameController.text
    );
    GroupNameController.clear();
    CreateOneGroup(createGroup).then((value) => {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text(value.toString())))
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
      user: widget.user,
      code: JoinCodeController.text
    );
    JoinCodeController.clear();
    JoinOneGroup(joinGroup).then((value) => {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text(value.toString())))

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
    return ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {

          return _tile(data[index]);
        }
    );
  }
  Widget _tile(group){
    return ListTile(
      title: Text(group.groupName),
      onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => SingleGroupScreen(group:group))),
    );
  }

  Widget _futurebuilder(){
    return FutureBuilder<List<Group>>(
      future: RetrieveGroup(widget.user),
      builder: (context,snapshot){
        if(snapshot.hasData){
          List<Group> data = snapshot.data;
          return ListGroup(data);
        }else if(snapshot.hasError){
          return Text("${snapshot.error}");
        }
        return Container(
          child: Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.black,
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
