import 'package:bluesurvey_app/domain/entities/survey.dart';
import 'package:bluesurvey_app/infrastructure/datasources/survey_data.dart';
import 'package:bluesurvey_app/presentation/providers/auth/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SurveysState {
  final List surveys;
  final String message;
  final bool isLoading;

  SurveysState(
      {this.surveys = const [], this.message = '', this.isLoading = false});

  SurveysState copyWith({
    List? surveys,
    String? message,
    bool? isLoading,
  }) =>
      SurveysState(
          surveys: surveys ?? this.surveys,
          message: message ?? this.message,
          isLoading: isLoading ?? this.isLoading);
}

class SurveysNotifier extends StateNotifier<SurveysState> {
  final SurveyData surveyData;

  SurveysNotifier({required this.surveyData}) : super(SurveysState()) {
    loadSurveys();
  }

  loadSurveys() async {
    try {
      state = state.copyWith(isLoading: true);
      final surveys = await surveyData.getSurveys();
      state = state.copyWith(surveys: surveys, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
      print(e);
    }
  }

  addNewSurvey(Survey newSurvey) {
    state = state.copyWith(surveys: [...state.surveys, newSurvey]);
  }
}

final surveysProvider =
    StateNotifierProvider<SurveysNotifier, SurveysState>((ref) {
  final accessToken = ref.watch(authProvider).user?.accessToken;
  final surveyData = SurveyData(accessToken: accessToken!);
  return SurveysNotifier(surveyData: surveyData);
});
