import 'package:formz/formz.dart';

enum AnswerError { empty, format }

class AnswerInput extends FormzInput<String, AnswerError> {
  const AnswerInput.pure() : super.pure('');

  const AnswerInput.dirty(String value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == AnswerError.empty) return 'El campo es requerido';

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  AnswerError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return AnswerError.empty;

    return null;
  }
}
