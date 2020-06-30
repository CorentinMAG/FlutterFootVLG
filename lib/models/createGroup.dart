import 'package:ffootvlg/models/Member.dart';

class CreateGroup{
  final Member creator;
  final String groupName;

  CreateGroup({
    this.creator,
    this.groupName
  });

  Map<String, dynamic> toJson() =>
      {
        "creator":{
          "id":creator.id,
          "last_name":creator.last_name,
          "first_name":creator.first_name,
          "phone_number":creator.phone_number,
          "email":creator.email,
          "birthday":creator.birthday,
          "inscription_date":creator.inscription_date,
          "password":creator.password,
          "is_admin":creator.is_admin,
          "is_superuser":creator.is_superuser
        },
        "groupName":groupName
      };


}