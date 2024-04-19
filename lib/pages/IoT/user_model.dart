class User {
  String? key;
  UserData? userData;

  User({this.key, this.userData});
}

class UserData {
  String? username;
  String? password;

  UserData({this.username, this.password});

  UserData.fromJson(Map<dynamic, dynamic> json) {
    username = json['username'];
    password = json['password'];
  }
}
