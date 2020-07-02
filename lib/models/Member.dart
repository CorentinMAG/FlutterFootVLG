import 'dart:core';

import 'package:flutter/cupertino.dart';

class Member{
  final int id;
  String last_name;
  String first_name;
  String phone_number;
  String email;
  String birthday;
  String password;
  final String inscription_date;
  bool is_admin;
  bool is_superuser;
  String status;

  Member({
    this.id=0,
    this.last_name,
    this.first_name,
    this.phone_number,
    this.email,
    this.birthday,
    this.inscription_date="",
    this.password,
    this.is_admin=false,
    this.is_superuser=false,
    this.status=""
  }
  );

  Map<String, dynamic> toJson() =>
      {
        "id":id,
        "last_name":last_name,
        "first_name":first_name,
        "phone_number":phone_number,
        "email":email,
        "birthday":birthday,
        "inscription_date":inscription_date,
        "password":password,
        "is_admin":is_admin,
        "is_superuser":is_superuser,
        if(status!="") "status":status,
      };

  factory Member.fromJson(Map<String, dynamic> json) {
    var user = Member(
      id:json['id'],
      last_name: json['last_name'],
      first_name: json['first_name'],
      phone_number: json['phone_number'],
      email: json['email'],
      birthday: json['birthday'],
      inscription_date: json['inscription_date'],
      password: json['password'],
      is_admin: json['is_admin'],
      is_superuser: json['is_superuser'],
    );
    if(json['status']!=null){
      user.status = json['status'];
    }
    return user;
  }
}

class _InheritedStateContainer extends InheritedWidget{
  final StateContainerState data;

  _InheritedStateContainer({
    Key key,
    @required this.data,
    @required Widget child,
}):super(key:key,child:child);

  @override
  bool updateShouldNotify(_InheritedStateContainer oldWidget) =>true;
}

class StateContainer extends StatefulWidget{
  final Widget child;
  final Member user;

  StateContainer({
    @required this.child,
    this.user
});

  static StateContainerState of(BuildContext context){
    return (context.inheritFromWidgetOfExactType(_InheritedStateContainer) as _InheritedStateContainer).data;
  }

  @override
  StateContainerState createState() => new StateContainerState();
}

class StateContainerState extends State<StateContainer>{
  Member user;

  void updateUserInfo({Member Member}){
    if(user ==null){
      setState(() {
        user = Member;
      });
    }else{
      setState(() {
        user = Member;
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return new _InheritedStateContainer(
      data:this,
      child: widget.child,
    );

  }
}