import 'Member.dart';

class Event{
  int id;
  int id_group;
  String name;
  String creation_date;
  String description;
  int participe;
  int participe_pas;
  int peut_etre;
  String vote;
  String endroit;
  String datetime;
  List<Member> members;

  Event({this.id=0,
    this.id_group=0,
    this.name,
    this.creation_date="",
    this.description="",
    this.participe=0,
    this.participe_pas=0,
    this.peut_etre=0,
    this.vote="",
    this.datetime="",
    this.endroit="",
    this.members});

  Event.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    id_group=json['id_group'];
    name = json['name'];
    creation_date = json['creation_date'];
    description = json['description'];
    participe=json['participe'];
    participe_pas=json['participe_pas'];
    peut_etre=json['peut_etre'];
    vote=json['vote'];
    datetime=json['datetime'];
    endroit=json['endroit'];
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
    data['id_group'] = this.id_group;
    data['name'] = this.name;
    data['creation_date'] = this.creation_date;
    data['description'] = this.description;
    data['participe']=this.participe;
    data['participe_pas']=this.participe_pas;
    data['peut_etre']=this.peut_etre;
    data['datetime']=this.datetime;
    data['endroit']=this.endroit;
    data['vote']=this.vote;
    if (this.members != null) {
      data['members'] = this.members.map((v) => v.toJson()).toList();
    }
    return data;
  }
}