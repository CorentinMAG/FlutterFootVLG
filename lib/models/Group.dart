import 'Member.dart';

class Group{
  final String groupName;
  final String joinCode;
  final String is_group_admin;
  final List<Member> members;

  Group({
    this.groupName,
    this.joinCode,
    this.is_group_admin,
    this.members
});
  factory Group.fromJson(Map<String, dynamic> json){

    return Group(
      groupName: json['groupName'],
      joinCode: json['joinCode'],
      is_group_admin: json['is_group_admin'],
      members: json['members']
    );
  }
}