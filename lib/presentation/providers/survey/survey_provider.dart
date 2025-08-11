import 'package:bluesurvey_app/domain/entities/question.dart';
import 'package:bluesurvey_app/domain/entities/survey.dart';
import 'package:bluesurvey_app/infrastructure/datasources/survey_data.dart';
import 'package:bluesurvey_app/infrastructure/inputs/input.dart';
import 'package:bluesurvey_app/presentation/providers/auth/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SurveyState {
  final String? id;
  final Survey? survey;
  final List<dynamic> questions;
  final bool isLoading;
  final Input surveyTitle;
  final Input surveyDescription;
  final bool changesInSurvey;
  final bool isPosting;

  SurveyState(
      {this.id,
      this.survey,
      this.questions = const [],
      this.isLoading = false,
      this.surveyTitle = const Input.pure(),
      this.surveyDescription = const Input.pure(),
      this.changesInSurvey = false,
      this.isPosting = false});

  SurveyState copyWith({
    String? id,
    Survey? survey,
    List<dynamic>? questions,
    bool? isLoading,
    Input? surveyTitle,
    Input? surveyDescription,
    bool? changesInSurvey,
    bool? isPosting,
  }) =>
      SurveyState(
          id: id ?? this.id,
          survey: survey ?? this.survey,
          questions: questions ?? this.questions,
          isLoading: isLoading ?? this.isLoading,
          surveyTitle: surveyTitle ?? this.surveyTitle,
          surveyDescription: surveyDescription ?? this.surveyDescription,
          changesInSurvey: changesInSurvey ?? this.changesInSurvey,
          isPosting: isPosting ?? this.isPosting);
}

class SurveyNotifier extends StateNotifier<SurveyState> {
  final SurveyData surveyData;
  SurveyNotifier({required this.surveyData}) : super(SurveyState()) {
    loadSurvey();
  }

  loadSurvey() async {
    try {
      state = state.copyWith(isLoading: true);
      final survey = await surveyData.getSurvey();
      state = state.copyWith(
          survey: survey,
          isLoading: false,
          surveyTitle: Input.dirty(survey.title),
          questions: survey.questions,
          surveyDescription: Input.dirty(survey.description),
          changesInSurvey: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  onTitleSurveyChanged(String value) {
    final newValue = Input.dirty(value);
    state = state.copyWith(surveyTitle: newValue);
    updateChages();
  }

  onDescriptionChanged(String value) {
    final newValue = Input.dirty(value);
    state = state.copyWith(surveyDescription: newValue);
    updateChages();
  }

  saveChanges() async {
    try {
      state = state.copyWith(isPosting: true);
      final survey = await surveyData.updateTitleOrDescription(
          state.surveyTitle.value, state.surveyDescription.value);
      state = state.copyWith(
          surveyTitle: Input.dirty(survey.title),
          surveyDescription: Input.dirty(survey.description),
          isPosting: false,
          changesInSurvey: false);
    } catch (e) {
      state = state.copyWith(isPosting: false);
    }
  }

  addQuestion(Question question) {
    state = state.copyWith(questions: [...state.questions, question]);
  }

  deleteQuestion(String questionId) async {
    try {
      state = state.copyWith(isPosting: true);
      final survey = await surveyData.deleteQuestion(questionId);
      state = state.copyWith(
          isPosting: false, survey: survey, questions: survey.questions);
    } catch (e) {
      print(e);
    }
  }

  updateChages() {
    final hasChanges = state.surveyTitle.value != state.survey?.title ||
        state.surveyDescription.value != state.survey?.description;
    if (state.changesInSurvey != hasChanges) {
      state = state.copyWith(changesInSurvey: hasChanges);
    }
  }
}

final surveyProvider = StateNotifierProvider.autoDispose
    .family<SurveyNotifier, SurveyState, String>((ref, surveyId) {
  final accessToken = ref.watch(authProvider).user?.accessToken;
  final surveyData = SurveyData(accessToken: accessToken!, id: surveyId);
  return SurveyNotifier(surveyData: surveyData);
});
