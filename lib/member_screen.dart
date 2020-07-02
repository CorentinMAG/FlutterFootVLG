import 'dart:convert';

import 'package:ffootvlg/profilPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'models/Group.dart';
import 'models/Member.dart';
import 'models/deleteUser.dart';

Future<List<Member>> RetrieveGroupUsers(Group group) async {
  final http.Response response = await http.post(
    'https://foot.agenda-crna-n.com/getGroupUsers.php',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: json.encode(group.toJson()),
  );
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((user) => Member.fromJson(user)).toList();

  } else {
    throw Exception('Impossible de récupérer les utilisateurs');
  }
}

Future<String> _deleteuserFromGroup(DelUser deleteuser) async {
  final http.Response response = await http.post(
    'https://foot.agenda-crna-n.com/deleteUserFromGroup.php',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: json.encode(deleteuser.toJson()),
  );
  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Impossible de récupérer les utilisateurs');
  }
}

class MemberScreen extends StatelessWidget {
  Group group;

  MemberScreen({@required this.group});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Container(
        child: UserList(group: group)
      ),
    );
  }
}
class UserList extends StatefulWidget {
  Group group;

  List<Member> users = List<Member>();
  UserList({@required this.group});

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
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
  Widget ListUsers(){
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount:widget.users.length,
        itemBuilder: (context,index){
          return ListViewItem(widget.users[index]);
        },
      ),
    );
  }

  Widget _futurebuilder(){
    return FutureBuilder<List<Member>>(
      future: RetrieveGroupUsers(widget.group),
      builder: (context,snapshot){
        if(snapshot.hasData){
          widget.users = snapshot.data;
          return ListUsers();
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
  DeleteUser(Member user,Group group){
    final deleteuser = DelUser(user:user, group:group);
    _deleteuserFromGroup(deleteuser).then((value) => {
      setState((){
        widget.users.remove(user);
      }),
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text(value.toString())))
    }).catchError((onError)=>{
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text(onError.toString())))
    });
  }

  Widget ListViewItem(user) {
    if(widget.group.is_group_admin){
      return  Column(
        children: <Widget>[
          ListTile(
            title: RichText(
              text: TextSpan(
                text: "${user.last_name} ${user.first_name}",
                style: TextStyle(color: Colors.white,fontSize: 20),
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              color: Colors.red,
              onPressed: ()=>DeleteUser(user,widget.group),
            ),
            onTap:()=> Navigator.push(context,MaterialPageRoute(builder: (context)=>ProfilPage(user:user))),
          ),
          Divider(),
        ],
      );

    }else{
      return  Column(
        children: <Widget>[
          ListTile(
            title: RichText(
              text: TextSpan(
                text: "${user.last_name} ${user.first_name}",
                style: TextStyle(color: Colors.white,fontSize: 20),
              ),
            ),
            onTap:()=> Navigator.push(context,MaterialPageRoute(builder: (context)=>ProfilPage(user:user))),
          ),
          Divider(),
        ],
      );
    }

  }
}

