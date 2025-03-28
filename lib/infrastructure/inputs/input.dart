import 'package:formz/formz.dart';

enum InputError { empty, format }

class Input extends FormzInput<String, InputError> {
  const Input.pure() : super.pure('');
  const Input.dirty(String value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == InputError.empty) return 'El campo es requerido';

    return null;
  }

  @override
  InputError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return InputError.empty;
    return null;
  }
}
