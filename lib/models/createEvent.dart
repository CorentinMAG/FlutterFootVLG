import 'Member.dart';

class CreateFirstEvent{
  Member creator;
  String name;
  int id_group;
  String description;

  CreateFirstEvent({this.creator,this.name,this.id_group,this.description});

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
          "is_superuser":creator.is_superuser,
          if(creator.status!="") "status":creator.status,
          "is_group_admin":creator.is_group_admin
        },
        "event":{
          "name":name,
          "id_group":id_group,
          "description":description
        }
      };
}
