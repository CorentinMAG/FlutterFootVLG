import 'Group.dart';
import 'Member.dart';

class DelUser{
   Member user;
   Group group;
  DelUser({this.user,this.group});

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
        "group":{
          "id":group.id,
          "groupName":group.groupName,
          "is_group_admin":group.is_group_admin
        }
      };
}