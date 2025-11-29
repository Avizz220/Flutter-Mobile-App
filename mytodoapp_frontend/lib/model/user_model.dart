class UserModel {
  final String userID;
  final String name;
  final String email;
  final String password;
  final String fcmToken;

  UserModel({
    required this.userID,
    required this.name,
    required this.email,
    required this.password,
    required this.fcmToken,
  });

  Map<String, dynamic> toJason() {
    return {'userID': userID,
    'name':name,
    'email':email,
    'password':password,
    'fcmToken':fcmToken,
    };
  }
}
