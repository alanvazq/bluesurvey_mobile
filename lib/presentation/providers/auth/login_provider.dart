import 'package:bluesurvey_app/infrastructure/inputs/email.dart';
import 'package:bluesurvey_app/infrastructure/inputs/input.dart';
import 'package:bluesurvey_app/presentation/providers/auth/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

class LoginState {
  final Email email;
  final Input password;
  final bool isValid;
  final bool isPosting;
  final bool isFormPosted;

  LoginState({
    this.email = const Email.pure(),
    this.password = const Input.pure(),
    this.isValid = false,
    this.isPosting = false,
    this.isFormPosted = false,
  });

  LoginState copyWith({
    Email? email,
    Input? password,
    bool? isValid,
    bool? isPosting,
    bool? isFormPosted,
  }) =>
      LoginState(
          email: email ?? this.email,
          password: password ?? this.password,
          isValid: isValid ?? this.isValid,
          isPosting: isPosting ?? this.isPosting,
          isFormPosted: isFormPosted ?? this.isFormPosted);
}

class LoginNotifier extends StateNotifier<LoginState> {
  final Function(String, String) login;
  LoginNotifier({required this.login}) : super(LoginState());

  onEmailChanged(String value) {
    final newValue = Email.dirty(value);
    state = state.copyWith(email: newValue);
  }

  onPasswordChanged(String value) {
    final newValue = Input.dirty(value);
    state = state.copyWith(password: newValue);
  }

  onFormSubmit() async {
    _touchEveryField();
    if (!state.isValid) return;
    await login(state.email.value, state.password.value);
  }

  _touchEveryField() {
    final email = Email.dirty(state.email.value);
    final password = Input.dirty(state.password.value);

    state = state.copyWith(
        isFormPosted: true,
        email: email,
        password: password,
        isValid: Formz.validate([email, password]));
  }
}

final loginProvider =
    StateNotifierProvider.autoDispose<LoginNotifier, LoginState>((ref) {
  final login = ref.watch(authProvider.notifier).signinUser;
  return LoginNotifier(login: login);
});
