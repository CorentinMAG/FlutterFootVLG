import 'package:ffootvlg/models/Event.dart';

import 'Member.dart';

class Group{
  int id;
  String groupName;
  String joinCode;
  String creation_date;
  List<Member> members;
  List<Event> events;

  Group({
    this.id,
    this.groupName,
    this.joinCode,
    this.creation_date,
    this.members,
    this.events
});
  Group.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    groupName = json['groupName'];
    joinCode = json['joinCode'];
    creation_date = json['creation_date'];
    if (json['members'] != null) {
      members = new List<Member>();
      json['members'].forEach((v) {
        members.add(new Member.fromJson(v));
      });
    }
    if (json['events'] != null) {
      events = new List<Event>();
      json['events'].forEach((v) {
        events.add(new Event.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id']=this.id;
    data['groupName'] = this.groupName;
    data['joinCode'] = this.joinCode;
    data['creation_date'] = this.creation_date;
    if (this.members != null) {
      data['members'] = this.members.map((v) => v.toJson()).toList();
    }
    if(this.events!=null){
      data['events'] = this.events.map((e) => e.toJson()).toList();
    }
    return data;
  }
}