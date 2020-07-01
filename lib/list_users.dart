import 'dart:convert';
import 'package:ffootvlg/models/Member.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'models/updateMember.dart';

Future<List<Member>> RetrieveUsers(Member user) async {
  final http.Response response = await http.post(
    'https://foot.agenda-crna-n.com/getAllUsers.php',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: json.encode(user),
  );
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((user) => Member.fromJson(user)).toList();

  } else {
    throw Exception('Impossible de récupérer les utilisateurs');
  }
}

Future<String> UpdateUserAdmin(UpdateMember updateMember) async {
  final http.Response response = await http.post(
    'https://foot.agenda-crna-n.com/changeUserAdmin.php',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: json.encode(updateMember.toJson()),
  );
  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Impossible de changer les droits de l\'utilisateur');
  }
}



class ListUsers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Text('Liste utilisateurs'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed:() => Navigator.pop(context),
        ),
      ),
      body: Container(
        child: UsersList(),
      ),
    );
  }
}

class UsersList extends StatefulWidget {
  @override
  _UsersListState createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: _futurebuilder(),
        )
      ],
    );
  }

  Widget ListUsers(users){
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: users.length,
        itemBuilder: (context,index){
          return ListViewItem(user:users[index]);
        },
      ),
    );
  }

  Widget _futurebuilder(){
    return FutureBuilder<List<Member>>(
      future: RetrieveUsers(StateContainer.of(context).user),
      builder: (context,snapshot){
        if(snapshot.hasData){
          List<Member> data = snapshot.data;
          return ListUsers(data);
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
}
class ListViewItem extends StatefulWidget {

  Member user;
  ListViewItem({@required this.user});

  @override
  _ListViewItemState createState() => _ListViewItemState(user:user);
}

class _ListViewItemState extends State<ListViewItem> {

  Member user;
  _ListViewItemState({@required this.user});
  bool _value;
  @override
  void initState() {
    _value = user.is_admin;
    super.initState();
  }

  _updateField(Member user,Member admin){
    final updateMember = UpdateMember(admin:admin,user:user);
    UpdateUserAdmin(updateMember).then((value) => {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text(value.toString())))
    }).catchError((onError)=>{
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text(onError.toString())))
    });

  }

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: <Widget>[
        ListTile(
            title: RichText(
              text: TextSpan(
                text: "${user.last_name} ${user.first_name}",
                style: TextStyle(color: Colors.white,fontSize: 20),
              ),
            ),
            trailing: Switch(
              value: _value,
              onChanged: (value){
                setState(() {
                  _value=value;
                  user.is_admin=_value;
                  _updateField(user,StateContainer.of(context).user);
                });
              },
              activeTrackColor: Colors.lightGreenAccent,
              activeColor: Colors.green,
            )
        ),
        Divider(),
      ],
    );
  }
}



