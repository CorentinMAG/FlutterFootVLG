import 'models/Group.dart';
import 'models/Member.dart';

class UpdateMemberFromGroup{
  final Member admin;
  final Member user;
  final Group group;

  UpdateMemberFromGroup({this.admin, this.user, this.group});

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
          "is_superuser":user.is_superuser,
          "is_group_admin":user.is_group_admin
        },
        "admin":{
          "id":admin.id,
          "last_name":admin.last_name,
          "first_name":admin.first_name,
          "phone_number":admin.phone_number,
          "email":admin.email,
          "birthday":admin.birthday,
          "inscription_date":admin.inscription_date,
          "password":admin.password,
          "is_admin":admin.is_admin,
          "is_superuser":admin.is_superuser
        },
        "group":{
          "id":group.id,
          "name":group.groupName
        }
      };
}