class Comment {
  final int id;
  final int postId;
  final String comment;
  final String userId;
  final String userName;
  final String avatar;
  final String createdDate;

  Comment(
      {required this.id,
      required this.postId,
      required this.comment,
      required this.userId,
      required this.userName,
      required this.avatar,
      required this.createdDate});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      postId: json['postId'],
      comment: json['comment'],
      userId: json['userId'],
      userName: json['userName'],
      avatar: json['avatar'],
      createdDate: json['createdDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId': postId,
      'comment': comment,
      'userId': userId,
      'userName': userName,
      'avatar': avatar,
      'createdDate': createdDate,
    };
  }
}
