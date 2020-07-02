import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'models/Member.dart';

class ProfilPage extends StatelessWidget {
  final Member user;
  ProfilPage({@required this.user});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${user.last_name.toUpperCase()} ${user.first_name}"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        padding:EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        top: 50.0
                    ),
                  ),
                  Icon(Icons.account_circle,size: 200,)
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: 50.0
                ),
              ),
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text("Nom : ",style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold
                                ),),
                                Text(user.last_name,style: TextStyle(
                                    fontSize: 25
                                ))
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 10.0
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Text("Prénom : ",style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold
                                ),),
                                Text(user.first_name,style: TextStyle(
                                    fontSize: 25
                                ))
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 10.0
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Text("Email : ",style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold
                                ),),
                                Text(user.email,style: TextStyle(
                                    fontSize: 25
                                ))
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 10.0
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Text("Téléphone : ",style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold
                                ),),
                                Text(user.phone_number,style: TextStyle(
                                    fontSize: 25
                                ))
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 10.0
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Text("Date de naissance : ",style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold
                                ),),
                                Text(user.birthday,style: TextStyle(
                                    fontSize: 25
                                ))
                              ],
                            ),
                          ],
                        )
                      ],
                    )
                  ]
              ),

            ],
          )
      )

    );
  }
}

