import 'dart:convert';

import 'package:ffootvlg/profilPage.dart';
import 'package:ffootvlg/updateMemberFromGroup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'models/Group.dart';
import 'models/Member.dart';
import 'models/deleteUser.dart';

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
Future<String> UpdateUserGroupAdmin(UpdateMemberFromGroup updateMember) async {
  final http.Response response = await http.post(
    'https://foot.agenda-crna-n.com/updateUserGroupAdmin.php',
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

class MemberScreen extends StatelessWidget {
  Group group;
  bool is_admin;

  MemberScreen({@required this.group,this.is_admin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: UserList(group: group,is_admin:is_admin)
      ),
    );
  }
}
class UserList extends StatefulWidget {
  Group group;
  bool is_admin;
  UserList({@required this.group,this.is_admin});

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {


  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListUsers(),
        )
      ],
    );
  }
  Widget ListUsers(){
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount:widget.group.members.length,
        itemBuilder: (context,index){
          return ListViewItem(widget.group.members[index]);
        },
      ),
    );
  }

  DeleteUser(Member user,Group group){
    final deleteuser = DelUser(user:user, group:group);
    _deleteuserFromGroup(deleteuser).then((value) => {
      setState((){
        widget.group.members.remove(user);
      }),
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text(value.toString())))
    }).catchError((onError)=>{
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text(onError.toString())))
    });
  }
  _updateField(Member user,Member admin){
    final updateMember = UpdateMemberFromGroup(admin:admin,user:user,group:widget.group);
    UpdateUserGroupAdmin(updateMember).then((value) => {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text(value.toString())))
    }).catchError((onError)=>{
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text(onError.toString())))
    });

  }

  Widget ListViewItem(user) {
    bool _value = user.is_group_admin;
      return Card(
        child:
          ListTile(
            title: RichText(
              text: TextSpan(
                text: "${user.last_name} ${user.first_name}",
                style: TextStyle(color: Colors.black87, fontSize: 20),
              ),
            ),
            leading: Container(
              child: Icon(Icons.account_circle,size: 35,),
            ),
            trailing: Wrap(
              spacing: 5,
              children: <Widget>[
                if(widget.is_admin)
                IconButton(
                  icon: Icon(Icons.delete),
                  color: Colors.red,
                  onPressed: () => DeleteUser(user, widget.group),
                ),
                if(widget.is_admin)
                Switch(
                  value: _value,
                  onChanged: (value) =>
                  {
                    setState(() {
                      _value = value;
                      user.is_group_admin = value;
                      _updateField(user, StateContainer
                          .of(context)
                          .user);
                    })
                  },
                  activeTrackColor: Colors.lightGreenAccent,
                  activeColor: Colors.green,
                )
              ],
            ),
            onTap: () =>
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => ProfilPage(user: user))),
          ),
      );
  }
}


