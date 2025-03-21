import 'package:bluesurvey_app/infrastructure/inputs/email.dart';
import 'package:bluesurvey_app/infrastructure/inputs/input.dart';
import 'package:bluesurvey_app/presentation/providers/auth/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

class SignupState {
  final Input name;
  final Email email;
  final Input password;
  final bool isValid;
  final bool isPosting;
  final bool isFormPosted;
  final String message;

  SignupState(
      {this.name = const Input.pure(),
      this.email = const Email.pure(),
      this.password = const Input.pure(),
      this.isValid = false,
      this.isPosting = false,
      this.isFormPosted = false,
      this.message = ""});

  SignupState copyWith({
    Input? name,
    Email? email,
    Input? password,
    bool? isValid,
    bool? isPosting,
    bool? isFormPosted,
    String? message,
  }) =>
      SignupState(
          name: name ?? this.name,
          email: email ?? this.email,
          password: password ?? this.password,
          isValid: isValid ?? this.isValid,
          isPosting: isPosting ?? this.isPosting,
          isFormPosted: isFormPosted ?? this.isFormPosted,
          message: message ?? this.message);
}

class SignupNotifier extends StateNotifier<SignupState> {
  final Function(String, String, String) signup;
  SignupNotifier({required this.signup}) : super(SignupState());

  onNameChanged(String value) {
    final newValue = Input.dirty(value);
    state = state.copyWith(name: newValue);
  }

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
    state = state.copyWith(isPosting: true);
    await signup(state.name.value, state.email.value, state.password.value);
    state = state.copyWith(isPosting: false);
  }

  _touchEveryField() {
    final name = Input.dirty(state.name.value);
    final email = Email.dirty(state.email.value);
    final password = Input.dirty(state.password.value);

    state = state.copyWith(
        isFormPosted: true,
        name: name,
        email: email,
        password: password,
        isValid: Formz.validate([name, email, password]));
  }
}

final signupProvider =
    StateNotifierProvider.autoDispose<SignupNotifier, SignupState>((ref) {
  final signup = ref.watch(authProvider.notifier).signUpUser;
  return SignupNotifier(signup: signup);
});
