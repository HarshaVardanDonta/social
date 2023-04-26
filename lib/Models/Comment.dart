class Comment {
  final int id;
  final int postId;
  final String comment;
  final String userId;

  Comment(
      {required this.id,
      required this.postId,
      required this.comment,
      required this.userId});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      postId: json['postId'],
      comment: json['comment'],
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId': postId,
      'comment': comment,
      'userId': userId,
    };
  }
}
