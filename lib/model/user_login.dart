import 'dart:convert';

class User {
  String id;
  String role;
  List<String> following;
  List<String> follower;
  List<String> saved;
  bool notificationEnabled;
  String picture;
  String aboutMe;
  String name;
  String email;
  String password;
  String createdAt;
  String updatedAt;

  User(
      {this.id,
        this.role,
        this.following,
        this.notificationEnabled,
        this.picture,
        this.aboutMe,
        this.name,
        this.email,
        this.password,
        this.createdAt,
        this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    role = json['role'];
    following =
    json['following'] != null ? json['following'].cast<String>() : [];
    follower =
    json['follower'] != null ? json['follower'].cast<String>() : [];
    saved = json['saved'] != null ? json['saved'].cast<String>() : [];
    notificationEnabled = json['notificationEnabled'];
    picture = json['picture'];
    aboutMe = json['aboutMe'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['role'] = this.role;
    data['following'] = this.following;
    data['follower'] = this.follower;
    data['saved'] = this.saved;
    data['notificationEnabled'] = this.notificationEnabled;
    data['picture'] = this.picture;
    data['aboutMe'] = this.aboutMe;
    data['name'] = this.name;
    data['email'] = this.email;
    data['password'] = this.password;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
