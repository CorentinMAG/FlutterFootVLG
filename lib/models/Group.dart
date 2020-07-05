import 'Member.dart';

class Group{
  int id;
  String groupName;
  String joinCode;
  String creation_date;
  List<Member> members;

  Group({
    this.id,
    this.groupName,
    this.joinCode,
    this.creation_date,
    this.members
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
    return data;
  }
}