import 'package:socail/Network/UserService.dart';

class Friend {
  final int id;
  final String friendUserId;
  final String userId;
  final int status;
  final String userName;
  final String friendUserName;

  Friend({
    required this.id,
    required this.friendUserId,
    required this.userId,
    required this.status,
    required this.userName,
    required this.friendUserName,
  });

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
        id: json['id'],
        friendUserId: json['friendUserId'],
        userId: json['userId'],
        status: json['status'],
        userName: json['userName'],
        friendUserName: json['friendUserName']);
  }

  String toJson() {
    return '{'
        '"id": "$id",'
        '"friendUserId": "$friendUserId",'
        '"userId": "$userId",'
        '"status": "$status"'
        '"userName": "$userName"'
        '"friendUserName": "$friendUserName"'
        '}';
  }
}
