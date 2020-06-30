import 'Member.dart';

class JoinGroup{
  final Member user;
  final String code;

  JoinGroup({
    this.user,
    this.code
  });

  Map<String, dynamic> toJson() =>
      {
        "user":{
          "id":user.id,
          "last_name":user.last_name,
          "first_name":user.first_name,
          "phone_number":user.phone_number,
          "email":user.email,
          "birthday":user.birthday,
          "inscription_date":user.inscription_date,
          "password":user.password,
          "is_admin":user.is_admin,
          "is_superuser":user.is_superuser
        },
        "code":code
      };


}