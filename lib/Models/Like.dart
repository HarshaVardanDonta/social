class Like {
  final int postId;
  final String likedBy;
  final String userName;

  Like({
    required this.postId,
    required this.likedBy,
    required this.userName,
  });

  factory Like.fromJson(Map<String, dynamic> json) {
    return Like(
      postId: json['postId'],
      likedBy: json['likedBy'],
      userName: json['userName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'postId': postId,
        'likedBy': likedBy,
        'userName': userName,
      };
}
