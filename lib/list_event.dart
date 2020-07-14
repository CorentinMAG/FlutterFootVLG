import 'dart:convert';
import 'dart:ui';

import 'package:ffootvlg/models/Event.dart';
import 'package:ffootvlg/models/Member.dart';
import 'package:ffootvlg/models/sheet.dart';
import 'package:ffootvlg/participe_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smooth_star_rating/smooth_star_rating.dart';

Future<Sheet> GETTeamA(Sheet sheet) async {
  final http.Response response = await http.post(
    'https://foot.agenda-crna-n.com/teamASheet.php',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(sheet),
  );
  if (response.statusCode == 200) {
    return Sheet.fromJson(json.decode(response.body));
  } else {
    throw Exception('pas de données');
  }
}

Future<Sheet> GETTeamB(Sheet sheet) async {
  final http.Response response = await http.post(
    'https://foot.agenda-crna-n.com/teamBSheet.php',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(sheet),
  );
  if (response.statusCode == 200) {
    return Sheet.fromJson(json.decode(response.body));
  } else {
    throw Exception('pas de données');
  }
}

Future<String> POSTTeam(Sheet sheet) async {
  final http.Response response = await http.post(
    'https://foot.agenda-crna-n.com/postTeamSheet.php',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(sheet),
  );
  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('pas de données');
  }
}

class ListEventMember extends StatefulWidget {
  final Event event;
  final bool is_admin;
  ListEventMember({@required this.event,this.is_admin});

  @override
  _ListEventMemberState createState() => _ListEventMemberState();
}

class _ListEventMemberState extends State<ListEventMember> {
  final _TeamAFormKey = GlobalKey<FormState>();
  final _TeamBFormKey = GlobalKey<FormState>();
  double rating=0;

  Sheet sheet;

  TextEditingController AdverseTeamAController;
  TextEditingController ScoreTeamA;

  TextEditingController AdverseTeamBController;
  TextEditingController ScoreTeamB;


  @override
  void initState() {
    super.initState();
    sheet= Sheet(id_event: widget.event.id);
    if(widget.is_admin){
      GETTeamA(sheet).then((value) => {
        AdverseTeamAController = TextEditingController(text: value.adverse_team),
        ScoreTeamA =TextEditingController(text: value.score),
      }).catchError((onError)=>{
        print(onError),
        AdverseTeamAController = TextEditingController(),
        ScoreTeamA =TextEditingController(),
      });
      GETTeamB(sheet).then((value) => {
        AdverseTeamBController =TextEditingController(text: value.adverse_team),
        ScoreTeamB =TextEditingController(text: value.score),
      }).catchError((onError)=>{
        AdverseTeamBController =TextEditingController(),
        ScoreTeamB =TextEditingController(),
      });

    }
  }


  @override
  Widget build(BuildContext context) {
    final Member user = widget.event.members.firstWhere((member) => member.id == StateContainer.of(context).user.id);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            title: Text("${widget.event.name}"),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed:() => Navigator.of(context).pop(),
            ),
            bottom: TabBar(
              tabs: <Widget>[
                Tab(
                  icon: Icon(Icons.supervisor_account),
                  text: "participe",
                ),
                Tab(
                  icon: Icon(Icons.supervisor_account),
                  text: "ne participe pas",
                ),
                Tab(
                  icon: Icon(Icons.supervisor_account),
                  text: "peut être",
                ),
              ],
            ),
          ),
          body: Stack(
              children:<Widget>[
                SizedBox.expand(
                  child:TabBarView(
                    children: <Widget>[
                      ParticipeScreen(event:widget.event,is_admin:widget.is_admin),
                      ParticipePasScreen(event:widget.event),
                      PeutEtreScreen(event:widget.event),
                    ],
                  ),
                ),
                if(widget.is_admin)
                  _buildDraggableScrollableSheetAB()
                else if(user?.is_teamA)
                  _buildDraggableScrollableSheetA()
                else if(user?.is_teamB)
                    _buildDraggableScrollableSheetB()
              ]
          )
      ),
    );
  }
  DraggableScrollableSheet _buildDraggableScrollableSheetA(){
    var teamA_members = widget.event.members.where((element) => element.is_teamA==true).toList();
    return DraggableScrollableSheet(
      initialChildSize: 0.1,
      minChildSize: 0.1,
      maxChildSize: 0.9,
      builder: (BuildContext context,ScrollController scrollController){
        return Container(
          decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8)
              )
          ),
          child: ListView.builder(
            controller: scrollController,
            itemCount: 1,
            itemBuilder: (BuildContext context, int index){
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 43.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 14.0,),
                    Text('Mon Equipe',style: TextStyle(color: Colors.white,fontSize: 34.0),),
                    SizedBox(height: 50.0,),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text('Equipe A ',style: TextStyle(color: Colors.white,fontSize: 24.0),),
                        Text('${widget.event.sheetA.score.replaceFirst("-"," - ") ?? "0 - 0" }',style: TextStyle(color: Colors.white,fontSize: 24.0),),
                        Text("${widget.event.sheetA.adverse_team ?? "Pas de données..."}",style: TextStyle(color: Colors.white,fontSize: 24.0),)
                      ],
                    ),
                    Container(
                        width: 800,
                        height: 400,
                        child:ListView.builder(
                            controller: scrollController,
                            itemCount: teamA_members.length,
                            itemBuilder: (BuildContext context, int index){
                              return ListTile(
                                title: Text('${teamA_members[index].last_name.toUpperCase()} ${teamA_members[index].first_name}',style: TextStyle(color: Colors.white),),
                                trailing: SmoothStarRating(
                                  isReadOnly: false,
                                  size: 30,
                                  filledIconData: Icons.star,
                                  halfFilledIconData: Icons.star_half,
                                  defaultIconData: Icons.star_border,
                                  starCount: 5,
                                  allowHalfRating: true,
                                  color: Colors.red,
                                  borderColor: Colors.red,
                                  spacing: 2.0,
                                  onRated: (value) {
                                    //TODO : connecter à la base de données et récupérer les stats des joueurs
                                    print("rating value -> $value");
                                  },
                                ),
                              );
                            }
                        )
                    )
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
  DraggableScrollableSheet _buildDraggableScrollableSheetB(){
    var teamB_members = widget.event.members.where((element) => element.is_teamB==true).toList();
    return DraggableScrollableSheet(
      initialChildSize: 0.1,
      minChildSize: 0.1,
      maxChildSize: 0.9,
      builder: (BuildContext context,ScrollController scrollController){
        return Container(
          decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8)
              )
          ),
          child: ListView.builder(
            controller: scrollController,
            itemCount: 1,
            itemBuilder: (BuildContext context, int index){
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 43.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 14.0,),
                    Text('Mon Equipe',style: TextStyle(color: Colors.white,fontSize: 34.0),),
                    SizedBox(height: 50.0,),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text('Equipe B ',style: TextStyle(color: Colors.white,fontSize: 24.0),),
                        Text('${widget.event.sheetB.score.replaceFirst("-"," - ") ?? "0 - 0" }',style: TextStyle(color: Colors.white,fontSize: 24.0),),
                        Text("${widget.event.sheetB.adverse_team ?? "Pas de données..."}",style: TextStyle(color: Colors.white,fontSize: 24.0),)
                      ],
                    ),
                    Container(
                      width: 800,
                      height: 400,
                      child:ListView.builder(
                        controller: scrollController,
                        itemCount: teamB_members.length,
                        itemBuilder: (BuildContext context, int index){
                          return ListTile(
                            title: Text('${teamB_members[index].last_name.toUpperCase()} ${teamB_members[index].first_name}',style: TextStyle(color: Colors.white),),
                            trailing: SmoothStarRating(
                              isReadOnly: false,
                              size: 30,
                              filledIconData: Icons.star,
                              halfFilledIconData: Icons.star_half,
                              defaultIconData: Icons.star_border,
                              starCount: 5,
                              allowHalfRating: true,
                              spacing: 2.0,
                              onRated: (value) {
                                //TODO : connecter à la base de données et récupérer les stats des joueurs
                                print("rating value -> $value");
                              },
                            ),
                          );
                        }
                      )
                    )
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
  DraggableScrollableSheet _buildDraggableScrollableSheetAB(){
    return DraggableScrollableSheet(
      initialChildSize: 0.1,
      minChildSize: 0.1,
      maxChildSize: 0.9,
      builder: (BuildContext context,ScrollController scrollController){
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8)
            ),
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                stops: [0.1, 0.5, 0.7, 0.9],
                colors: [
                  Colors.indigo[600],
                  Colors.indigo[400],
                  Colors.red[300],
                  Colors.red[200],
                ],
              )
          ),
          child: ListView.builder(
            controller: scrollController,
            itemCount: 1,
            itemBuilder: (BuildContext context, int index){
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 43.0),
                child: Column(
                  children: <Widget>[
                    Form(
                      key: _TeamAFormKey,
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 14.0,),
                          Text("Feuille de match",style: TextStyle(color: Colors.white,fontSize: 34.0),),
                          SizedBox(height: 14.0,),
                          Text("Equipe A",style: TextStyle(color: Colors.white,fontSize: 24.0),),
                          SizedBox(height: 24.0,),
                          _buildRegisterAdverseTeamA(),
                          SizedBox(height: 24.0,),
                          _buildRegisterScoreTeamA(),
                          SizedBox(height: 12.0,),
                          _buildRegisterBtnA()
                        ],
                      ),
                    ),
                    Form(
                      key: _TeamBFormKey,
                      child: Column(
                        children: <Widget>[
                          Text("Equipe B",style: TextStyle(color: Colors.white,fontSize: 24.0),),
                          SizedBox(height: 24.0,),
                          _buildRegisterAdverseTeamB(),
                          SizedBox(height: 24.0,),
                          _buildRegisterScoreTeamB(),
                          SizedBox(height: 12.0,),
                          _buildRegisterBtnB()
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
  Widget _buildRegisterAdverseTeamA(){
    return TextFormField(
      controller: AdverseTeamAController,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
          filled: true,
          border: UnderlineInputBorder(),
          labelText: 'Equipe adverse',
          labelStyle: TextStyle(
              color: Colors.white
          ),
          prefixIcon: Icon(
            Icons.flag,
            color: Colors.white,
          )
      ),
      style: TextStyle(
          color: Colors.white,
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
  Widget _buildRegisterScoreTeamA(){
    return TextFormField(
      controller: ScoreTeamA,
      decoration: InputDecoration(
        hintText: "5-3",
          filled: true,
          border: UnderlineInputBorder(),
          labelText: 'score',
          labelStyle: TextStyle(
              color: Colors.white
          ),
          prefixIcon: Icon(
            Icons.score,
            color: Colors.white,
          )
      ),
      keyboardType: TextInputType.datetime,
      style: TextStyle(
          color: Colors.white,
          fontFamily: 'OpenSans'
      ),
      obscureText: false,
      autofocus: false,
      validator: (value) {
        RegExp regex = RegExp(r"^[0-9]{1,}-[0-9]{1,}$");
        if(regex.hasMatch(value)){
          return null;
        }else{
          return "le format doit être 5-3";
        }
      },
    );
  }
  Widget _buildRegisterBtnA(){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: (){
          if(_TeamAFormKey.currentState.validate()){
            ValidationFormA();
          }
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'METTRE A JOUR EQUIPE A',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }


  ValidationFormA(){
    final Sheet sheet= Sheet(
      id_event: widget.event.id,
      adverse_team: AdverseTeamAController.text,
      score: ScoreTeamA.text=="" ? null : ScoreTeamA.text,
      nb_sheet: "A"
    );
    POSTTeam(sheet).then((value) => {
    }).catchError((onError)=>{
      print(onError)
    });

  }

  ValidationFormB(){
    final Sheet sheet= Sheet(
        id_event: widget.event.id,
        adverse_team: AdverseTeamBController.text,
        score: ScoreTeamB.text=="" ? null : ScoreTeamB.text,
        nb_sheet: "B"
    );
    POSTTeam(sheet).then((value) => {
    }).catchError((onError)=>{
      print(onError)
    });

  }

  Widget _buildRegisterAdverseTeamB(){
    return TextFormField(
      controller:AdverseTeamBController ,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
          filled: true,
          border: UnderlineInputBorder(),
          labelText: 'Equipe adverse',
          labelStyle: TextStyle(
              color: Colors.white
          ),
          prefixIcon: Icon(
            Icons.flag,
            color: Colors.white,
          )
      ),
      style: TextStyle(
          color: Colors.white,
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
  Widget _buildRegisterScoreTeamB(){
    return TextFormField(
      controller: ScoreTeamB,
      decoration: InputDecoration(
          filled: true,
          hintText: "5-3",
          border: UnderlineInputBorder(),
          labelText: 'score',
          labelStyle: TextStyle(
              color: Colors.white
          ),
          prefixIcon: Icon(
            Icons.score,
            color: Colors.white,
          )
      ),
      keyboardType: TextInputType.datetime,
      style: TextStyle(
          color: Colors.white,
          fontFamily: 'OpenSans'
      ),
      obscureText: false,
      autofocus: false,
      validator: (value) {
        RegExp regex = RegExp(r"^[0-9]{1,}-[0-9]{1,}$");
        if(regex.hasMatch(value)){
          return null;
        }else{
          return "le format doit être 5-3";
        }
      },
    );
  }
  Widget _buildRegisterBtnB(){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: (){
          if(_TeamBFormKey.currentState.validate()){
            ValidationFormB();
          }
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'METTRE A JOUR EQUIPE B',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }
}

