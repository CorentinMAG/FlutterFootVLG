import 'dart:convert';
import 'package:ffootvlg/models/Member.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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



class ListUsers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed:() => Navigator.pop(context),
        ),
      ),
      body: Center(
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
        _futurebuilder()
      ],
    );
  }

  Widget ListUsers(users){
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemBuilder: (context,index){
          return _buildRow(users[index]);
        },
      ),
    );
  }

  Widget _buildRow(user){
    return Column(
      children: <Widget>[
        ListTile(
          title: RichText(
            text: TextSpan(
              text: user.last_name,
              style: TextStyle(color: Colors.white,fontSize: 20),
            ),
          ),
        ),
        Divider(),
      ],
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


