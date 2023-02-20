class Account {
  int? id;
  String? username;
  String? role;
  String? token;

  Account.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    role = json['role'];
    token = json['token'];
  }
}