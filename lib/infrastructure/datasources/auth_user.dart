import 'package:bluesurvey_app/config/constants/environment.dart';
import 'package:bluesurvey_app/domain/entities/user.dart';
import 'package:bluesurvey_app/domain/mappers/user_mapper.dart';
import 'package:bluesurvey_app/infrastructure/errors/custom_error.dart';
import 'package:dio/dio.dart';

class AuthUser {
  final dio = Dio(BaseOptions(
    baseUrl: Environment.apiUrl,
  ));

  Future<User> signin(String email, String password) async {
    try {
      final response = await dio.post('/signin', data: {
        'email': email,
        'password': password,
      });

      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } on DioException catch (error) {
      if (error.response?.statusCode == 401) {
        throw CustomError(
            error.response?.data['error'] ?? 'Credenciales incorrectas');
      }
      if (error.type == DioExceptionType.connectionError) {
        throw CustomError('Revisar conexión a internet');
      }
      if (error.response?.statusCode == 404) {
        throw CustomError(
            error.response?.data['error'] ?? 'El usuario no existe');
      }
      throw Exception();
    } catch (error) {
      throw Exception();
    }
  }

  Future<String> signup(String name, String email, String password) async {
    try {
      final response = await dio.post('/signup', data: {
        'name': name,
        'email': email,
        'password': password,
      });

      final userCreated = response.data['message'];
      return userCreated;
    } on DioException catch (error) {
      if (error.response?.statusCode == 400) {
        throw CustomError(
            error.response?.data['error'] ?? 'Error al crear el usuario');
      }

      if (error.type == DioExceptionType.connectionError) {
        throw CustomError('Revisar conexión a internet');
      }

      throw Exception();
    } catch (error) {
      throw Exception();
    }
  }

  Future checkAuthStatus(String token) async {
    try {
      final response = await dio.get('/user',
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } on DioException catch (error) {
      if (error.response?.statusCode == 401) {
        throw CustomError(error.response?.data['message'] ?? 'No valido');
      }
      throw Exception();
    } catch (error) {
      throw Exception();
    }
  }

  Future getAllUsers(String token) async {
    try {
      final response = await dio.get('/users',
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      final users = response.data;
      return users;
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) {
        return CustomError(
            error.response?.data['message'] ?? 'Usuarios no encontrados');
      }
    } catch (error) {
      throw Exception();
    }
  }

  Future requestNewAccesToken(String refreshToken) async {
    try {
      final response = await dio.get('/refresh-token',
          options: Options(headers: {'Authorization': 'Bearer $refreshToken'}));

      final accessToken = response.data['accessToken'];
      return accessToken;
    } on DioException catch (error) {
      if (error.response?.statusCode == 401) {
        throw CustomError(error.response?.data['message'] ?? 'No valido');
      }
      throw Exception();
    } catch (error) {
      throw Exception();
    }
  }
}
