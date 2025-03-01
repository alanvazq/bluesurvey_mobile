import 'package:bluesurvey_app/domain/entities/role.dart';

class RoleMapper {
  static Role fromJson(Map<String, dynamic> json) {
    return Role(
      id: json["_id"],
      name: json["name"],
    );
  }
}
