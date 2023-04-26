class Like {
  final int postId;
  final String likedBy;

  Like({
    required this.postId,
    required this.likedBy,
  });

  factory Like.fromJson(Map<String, dynamic> json) {
    return Like(
      postId: json['postId'],
      likedBy: json['likedBy'],
    );
  }

  Map<String, dynamic> toJson() => {
        'postId': postId,
        'likedBy': likedBy,
      };
}
