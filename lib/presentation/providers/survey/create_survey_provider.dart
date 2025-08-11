import 'package:bluesurvey_app/infrastructure/datasources/survey_data.dart';
import 'package:bluesurvey_app/infrastructure/inputs/input.dart';
import 'package:bluesurvey_app/presentation/providers/auth/auth_provider.dart';
import 'package:bluesurvey_app/presentation/providers/survey/surveys_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

class CreateSurveyState {
  final Input title;
  final Input description;
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;

  CreateSurveyState(
      {this.title = const Input.pure(),
      this.description = const Input.pure(),
      this.isFormPosted = false,
      this.isPosting = false,
      this.isValid = false});

  CreateSurveyState copyWith({
    Input? title,
    Input? description,
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
  }) =>
      CreateSurveyState(
          title: title ?? this.title,
          description: description ?? this.description,
          isPosting: isPosting ?? this.isPosting,
          isFormPosted: isFormPosted ?? this.isFormPosted,
          isValid: isValid ?? this.isValid);
}

class CreateSurveyNotifier extends StateNotifier<CreateSurveyState> {
  final SurveyData surveyData;
  final SurveysNotifier surveysProvider;
  CreateSurveyNotifier(
      {required this.surveyData, required this.surveysProvider})
      : super(CreateSurveyState());

  onTitleChanged(String value) {
    final newValue = Input.dirty(value);
    state = state.copyWith(title: newValue);
  }

  onDescriptionChanged(String value) {
    final newValue = Input.dirty(value);
    state = state.copyWith(description: newValue);
  }

  onFormSubmit() async {
    _touchEveryField();
    if (!state.isValid) return;
    try {
      state = state.copyWith(isPosting: true);
      final newSurvey = await surveyData.createSurvey(
          state.title.value, state.description.value);
      surveysProvider.addNewSurvey(newSurvey);
      state = state.copyWith(isPosting: false);
    } catch (e) {
      print(e);
      state = state.copyWith(isPosting: false);
    }
  }

  _touchEveryField() {
    final title = Input.dirty(state.title.value);
    final description = Input.dirty(state.description.value);

    state = state.copyWith(
        isFormPosted: true,
        title: title,
        description: description,
        isValid: Formz.validate([title, description]));
  }
}

final createSurveyProvider =
    StateNotifierProvider.autoDispose<CreateSurveyNotifier, CreateSurveyState>(
        (ref) {
  final accessToken = ref.watch(authProvider).user?.accessToken;
  final surveyData = SurveyData(accessToken: accessToken!);
  final surveys = ref.watch(surveysProvider.notifier);
  return CreateSurveyNotifier(surveyData: surveyData, surveysProvider: surveys);
});
