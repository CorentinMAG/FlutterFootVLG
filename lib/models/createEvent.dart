import 'package:ffootvlg/models/Event.dart';

import 'Member.dart';

class CreateFirstEvent{
  Member creator;
  Event event;

  CreateFirstEvent({this.creator,this.event});

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
        },
        "event":{
          "name":event.name,
          "id_group":event.id_group,
          "description":event.description,
          "datetime":event.datetime,
          "endroit":event.endroit
        }
      };
}
