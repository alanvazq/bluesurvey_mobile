import 'package:bluesurvey_app/domain/entities/role.dart';
import 'package:bluesurvey_app/domain/entities/user.dart';
import 'package:bluesurvey_app/domain/mappers/role_mapper.dart';

class UserMapper {
  static User userJsonToEntity(Map<String, dynamic> json) => User(
        id: json['id'],
        email: json['email'],
        username: json['username'],
        roles:
            List<Role>.from(json["roles"].map((x) => RoleMapper.fromJson(x))),
        token: json['token'],
      );
}
