// ignore_for_file: file_names

class UserObj {
  final String name;
  final String email;
  final String password;
  final String firebaseUid;

  UserObj(
      {required this.name,
      required this.email,
      required this.password,
      required this.firebaseUid});

  factory UserObj.fromJson(Map<String, dynamic> json) {
    return UserObj(
        name: json['name'],
        email: json['email'],
        password: json['password'],
        firebaseUid: json['firebaseUid']);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'firebaseUid': firebaseUid,
    };
  }
}
