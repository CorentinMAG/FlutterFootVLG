import 'dart:core';

class Member{
  final int id;
  final String last_name;
  final String first_name;
  final String phone_number;
  final String email;
  final String birthday;
  String password;
  final String inscription_date;
  final bool is_admin;
  final bool is_superuser;

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
    this.is_superuser=false
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
        "is_superuser":is_superuser
      };

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id:json['id'],
      last_name: json['last_name'],
      first_name: json['first_name'],
      phone_number: json['phone_number'],
      email: json['email'],
      birthday: json['birthday'],
      inscription_date: json['inscription_date'],
      password: json['password'],
      is_admin: json['is_admin'],
      is_superuser: json['is_superuser']
    );
  }
}