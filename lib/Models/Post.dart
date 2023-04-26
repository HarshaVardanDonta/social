// ignore_for_file: file_names

class Post {
  final String title;
  final String desc;
  final String imageUrl;
  final String byUser;
  final int? id;
  final String byUserName;

  Post({
    required this.title,
    required this.desc,
    required this.imageUrl,
    required this.byUser,
    this.id,
    required this.byUserName,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      title: json['title'],
      desc: json['desc'],
      imageUrl: json['imageUrl'],
      byUser: json['byUser'],
      id: json['id'],
      byUserName: json['byUserName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'desc': desc,
      'imageUrl': imageUrl,
      'byUser': byUser,
      'id': id,
      'byUserName': byUserName,
    };
  }
}
