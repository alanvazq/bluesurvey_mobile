import 'package:bluesurvey_app/domain/entities/role.dart';

class User {
  final String id;
  final String email;
  final String name;
  final String accessToken;
  final String refreshToken;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.accessToken,
    required this.refreshToken
  });
}
