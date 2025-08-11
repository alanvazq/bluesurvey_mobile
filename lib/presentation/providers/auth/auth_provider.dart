import 'package:bluesurvey_app/domain/entities/user.dart';
import 'package:bluesurvey_app/infrastructure/datasources/auth_user.dart';
import 'package:bluesurvey_app/infrastructure/errors/custom_error.dart';
import 'package:bluesurvey_app/infrastructure/services/key_value_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthStatus { checking, authenticated, notAuthenticated, newUser, invited }

class AuthState {
  final AuthStatus authStatus;
  final User? user;
  final String errorMessage;
  final List? users;

  AuthState(
      {this.authStatus = AuthStatus.checking,
      this.user,
      this.errorMessage = '',
      this.users});

  AuthState copyWith({
    AuthStatus? authStatus,
    User? user,
    String? errorMessage,
    List? users,
  }) =>
      AuthState(
        authStatus: authStatus ?? this.authStatus,
        user: user ?? this.user,
        errorMessage: errorMessage ?? this.errorMessage,
        users: users ?? this.users,
      );
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthUser authUser;
  final KeyValueStorage keyValueStorage;

  AuthNotifier({required this.authUser, required this.keyValueStorage})
      : super(AuthState()) {
    checkAuthStatus();
  }

  Future<void> signinUser(String email, String password) async {
    try {
      final user = await authUser.signin(email, password);
      _setLoggedUser(user);
    } on CustomError catch (error) {
      logout(error.message);
    } catch (error) {
      print(error);
      logout('Ocurrió un error');
    }
  }

  Future<void> signUpUser(String name, String email, String password) async {
    try {
      final newUser = await authUser.signup(name, email, password);
      state = state.copyWith(
        errorMessage: newUser,
        authStatus: AuthStatus.newUser,
      );
    } on CustomError catch (error) {
      logout(error.message);
    } catch (error) {
      logout('Ocurrio un error');
    }
  }

  Future getUsers() async {
    try {
      final users = await authUser.getAllUsers(state.user!.accessToken);
      state = state.copyWith(
        users: users,
      );
    } on CustomError catch (error) {
      logout(error.message);
    } catch (error) {
      throw Exception(error);
    }
  }

  void checkAuthStatus() async {
    final accessToken = await keyValueStorage.getValue<String>('accessToken');
    if (accessToken != null) {
      //Usuaro autenticado
      try {
        final user = await authUser.checkAuthStatus(accessToken);
        if (user != null) {
          return _setLoggedUser(user);
        }
      } catch (e) {
        logout('Algo salió mal');
      }
    }
    // Usuario no autenticado
    final refreshToken = await keyValueStorage.getValue<String>("refreshToken");
    if (refreshToken != null) {
      try {
        final newAccessToken =
            await authUser.requestNewAccesToken(refreshToken);
        if (newAccessToken != null) {
          final user = await authUser.checkAuthStatus(newAccessToken);
          if (user) {
            return _setLoggedUser(user);
          }
        }
      } catch (e) {
        logout('Algo salió mal');
      }
    } else {
      logout('Algo salió mal');
    }
  }

  void _setLoggedUser(User user) async {
    await keyValueStorage.setKeyValue('accessToken', user.accessToken);
    await keyValueStorage.setKeyValue('refreshToken', user.refreshToken);
    state = state.copyWith(
      user: user,
      authStatus: AuthStatus.authenticated,
      errorMessage: '',
    );
  }

  Future<void> logout([String? errorMessage]) async {
    try {
      final refreshToken =
          await keyValueStorage.getValue<String>("refreshToken");
      if (refreshToken != null) {
        final tokenRemoved = await authUser.signout(refreshToken);
        if (tokenRemoved) {
          await keyValueStorage.removeKey('accessToken');
          await keyValueStorage.removeKey('refreshToken');
          state = state.copyWith(
            authStatus: AuthStatus.notAuthenticated,
            user: null,
            errorMessage: errorMessage,
          );
        }
      } else {
        state = state.copyWith(
          authStatus: AuthStatus.notAuthenticated,
          user: null,
          errorMessage: errorMessage,
        );
      }
    } catch (e) {
      state = state.copyWith(
        authStatus: AuthStatus.notAuthenticated,
        user: null,
        errorMessage: errorMessage,
      );
    }
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authUser = AuthUser();
  final keyValueStorage = KeyValueStorage();
  return AuthNotifier(authUser: authUser, keyValueStorage: keyValueStorage);
});
