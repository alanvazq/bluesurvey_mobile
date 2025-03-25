import 'package:bluesurvey_app/domain/entities/user.dart';

class UserMapper {
  static User userJsonToEntity(Map<String, dynamic> json) => User(
        id: json['user']['id'],
        email: json['user']['email'],
        name: json['user']['name'],
        accessToken: json['accessToken'],
        refreshToken: json['refreshToken']
      );
}
