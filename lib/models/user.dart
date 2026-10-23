import 'package:flutter/foundation.dart';

@immutable
class FullUser {
  const FullUser({
    this.firstName,
    this.lastName,
    required this.nickname,
    this.photo,
    required this.userId,
    required this.role,
    required this.classId,
    required this.login,
    required this.schoolId,
  });

  final String? firstName;
  final String? lastName;
  final String nickname;
  final String? photo;
  final int userId;
  final String role;
  final int classId;
  final String login;
  final int schoolId;

  String get fullName => [firstName, lastName].whereType<String>().join(' ');

  factory FullUser.fromJson(Map<String, dynamic> json) => FullUser(
        firstName: json['first_name'] as String?,
        lastName: json['last_name'] as String?,
        nickname: json['nickname'] as String,
        photo: json['photo'] as String?,
        userId: json['user_id'] as int,
        role: json['role'] as String,
        classId: json['class_id'] as int,
        login: json['login'] as String,
        schoolId: json['school_id'] as int,
      );

  Map<String, dynamic> toJson() => {
        'first_name': firstName,
        'last_name': lastName,
        'nickname': nickname,
        'photo': photo,
        'user_id': userId,
        'role': role,
        'class_id': classId,
        'login': login,
        'school_id': schoolId,
      };
}

@immutable
class SmallUser {
  const SmallUser({
    this.firstName,
    this.lastName,
    required this.login,
    this.photo,
    required this.userId,
    required this.role,
  });

  final String? firstName;
  final String? lastName;
  final String login;
  final String? photo;
  final int userId;
  final String role;

  String get fullName {
    final name = [firstName, lastName].whereType<String>().join(' ');
    return name.isEmpty ? login : name;
  }

  factory SmallUser.fromJson(Map<String, dynamic> json) => SmallUser(
        firstName: json['first_name'] as String?,
        lastName: json['last_name'] as String?,
        login: json['login'] as String,
        photo: json['photo'] as String?,
        userId: json['user_id'] as int,
        role: json['role'] as String,
      );

  Map<String, dynamic> toJson() => {
        'first_name': firstName,
        'last_name': lastName,
        'login': login,
        'photo': photo,
        'user_id': userId,
        'role': role,
      };
}

@immutable
class AuthData {
  const AuthData({required this.token, required this.user});

  final String token;
  final FullUser user;

  factory AuthData.fromJson(Map<String, dynamic> json) => AuthData(
        token: json['token'] as String,
        user: FullUser.fromJson(json['user'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {'token': token, 'user': user.toJson()};
}

enum AccountBindType { vk, def }

@immutable
class AccountBind {
  const AccountBind({
    required this.type,
    required this.uuid,
    required this.token,
  });

  final AccountBindType type;
  final int uuid;
  final String token;

  factory AccountBind.fromJson(Map<String, dynamic> json) => AccountBind(
        type: json['type'] == 'VK' ? AccountBindType.vk : AccountBindType.def,
        uuid: json['uuid'] as int,
        token: json['token'] as String,
      );

  Map<String, dynamic> toJson() => {
        'type': type == AccountBindType.vk ? 'VK' : 'DEFAULT',
        'uuid': uuid,
        'token': token,
      };
}

@immutable
class SignUpRequest {
  const SignUpRequest({
    required this.login,
    required this.password,
    required this.session,
    required this.regionId,
    this.accountsBind = const [],
  });

  final String login;
  final String password;
  final String session;
  final int regionId;
  final List<AccountBind> accountsBind;

  Map<String, dynamic> toJson() => {
        'login': login,
        'password': password,
        'session': session,
        'region_id': regionId,
        'accounts_bind': accountsBind.map((e) => e.toJson()).toList(),
      };
}
