import 'Member.dart';

class Group{
  String groupName;
  String joinCode;
  String creation_date;
  bool is_group_admin;
  List<Member> members;

  Group({
    this.groupName,
    this.joinCode,
    this.creation_date,
    this.is_group_admin,
    this.members
});
  Group.fromJson(Map<String, dynamic> json) {
    groupName = json['groupName'];
    joinCode = json['joinCode'];
    creation_date = json['creation_date'];
    is_group_admin = json['is_group_admin'];
    if (json['members'] != null) {
      members = new List<Member>();
      json['members'].forEach((v) {
        members.add(new Member.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['groupName'] = this.groupName;
    data['joinCode'] = this.joinCode;
    data['creation_date'] = this.creation_date;
    data['is_group_admin'] = this.is_group_admin;
    if (this.members != null) {
      data['members'] = this.members.map((v) => v.toJson()).toList();
    }
    return data;
  }
}