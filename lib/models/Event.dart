import 'Member.dart';

class Event{
  int id;
  String name;
  String creation_date;
  String description;
  bool is_event_admin;
  List<Member> members;

  Event({this.id,
    this.name,
    this.creation_date="",
    this.description="",
    this.is_event_admin=false,
    this.members});

  Event.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    creation_date = json['creation_date'];
    description = json['description'];
    is_event_admin=json['is_event_admin'];
    if (json['members'] != null) {
      members = new List<Member>();
      json['members'].forEach((v) {
        members.add(new Member.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['creation_date'] = this.creation_date;
    data['description'] = this.description;
    data['is_event_admin'] = this.is_event_admin;
    if (this.members != null) {
      data['members'] = this.members.map((v) => v.toJson()).toList();
    }
    return data;
  }
}