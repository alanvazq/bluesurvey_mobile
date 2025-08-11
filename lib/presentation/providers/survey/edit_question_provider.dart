import 'package:bluesurvey_app/domain/entities/answer.dart';
import 'package:bluesurvey_app/domain/entities/question.dart';
import 'package:bluesurvey_app/infrastructure/datasources/survey_data.dart';
import 'package:bluesurvey_app/infrastructure/inputs/input.dart';
import 'package:bluesurvey_app/presentation/providers/auth/auth_provider.dart';
import 'package:bluesurvey_app/presentation/providers/survey/survey_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:collection/collection.dart';

class EditQuestionState {
  final Input titleQuestion;
  final List<Answer> answers;
  final String typeQuestion;
  final bool changesInQuestion;
  final bool isPosting;

  EditQuestionState(
      {this.titleQuestion = const Input.pure(),
      this.answers = const [],
      this.typeQuestion = "open",
      this.changesInQuestion = false,
      this.isPosting = false});

  EditQuestionState copyWith({
    Input? titleQuestion,
    List<Answer>? answers,
    String? typeQuestion,
    bool? changesInQuestion,
    bool? isPosting,
  }) =>
      EditQuestionState(
          titleQuestion: titleQuestion ?? this.titleQuestion,
          answers: answers ?? this.answers,
          typeQuestion: typeQuestion ?? this.typeQuestion,
          changesInQuestion: changesInQuestion ?? this.changesInQuestion,
          isPosting: isPosting ?? this.isPosting);
}

class EditQuestionNotifier extends StateNotifier<EditQuestionState> {
  final Question question;
  final SurveyData surveyData;
  final SurveyNotifier surveyNotifier;
  EditQuestionNotifier(
      {required this.question,
      required this.surveyData,
      required this.surveyNotifier})
      : super(EditQuestionState(
            answers: question.answers,
            typeQuestion: question.typeQuestion,
            titleQuestion: Input.dirty(question.question)));

  onTypeQuestionChanged(String value) {
    if (question.typeQuestion == "open" &&
        (value == "singleOption" || value == "multipleOption")) {
      state = state.copyWith(
        typeQuestion: value,
        answers: [],
      );
    } else {
      state = state.copyWith(typeQuestion: value);
    }
    verifyChanges();
  }

  onTitleQuestionChanged(String value) {
    final newValue = Input.dirty(value);
    state = state.copyWith(titleQuestion: newValue);
    verifyChanges();
  }

  onAnswerChanged(String answerId, String value) {
    final updatedAnswers = state.answers.map((answer) {
      if (answer.id == answerId) {
        return answer.copyWith(answer: value);
      }
      return answer;
    }).toList();

    state = state.copyWith(answers: updatedAnswers);
    verifyChanges();
  }

  updateOrCreateQuestions(bool isNewQuestion) {
    if (isNewQuestion) {
      _createQuestion();
    } else {
      _updateQuestion();
    }
  }

  _createQuestion() async {
    try {
      final question = await surveyData.createQuestion(
          state.typeQuestion, state.titleQuestion.value, state.answers);
      surveyNotifier.addQuestion(question);
    } catch (e) {
      print(e);
    }
  }

  _updateQuestion() {}

  addNewAnswer() {
    final newAnswer = Answer(answer: "", count: 0, id: "n-${Uuid().v4()}");
    state = state.copyWith(answers: [...state.answers, newAnswer]);
  }

  removeAnswer(String answerId) {
    final updatedAnswers =
        state.answers.where((answer) => answer.id != answerId).toList();
    state = state.copyWith(answers: updatedAnswers);
    verifyChanges();
  }

  void verifyChanges() {
    final hasChangesInTitle = state.titleQuestion.value != question.question;
    final hasChangesInType = state.typeQuestion != question.typeQuestion;

    final listEquals = const DeepCollectionEquality.unordered().equals;
    final hasChangesInAnswers = !listEquals(state.answers, question.answers);

    final hasChanges =
        hasChangesInTitle || hasChangesInType || hasChangesInAnswers;

    if (state.changesInQuestion != hasChanges) {
      state = state.copyWith(changesInQuestion: hasChanges);
    }
  }
}

final editQuestionProvider = StateNotifierProvider.autoDispose
    .family<EditQuestionNotifier, EditQuestionState, Question>((ref, question) {
  final accessToken = ref.watch(authProvider).user!.accessToken;
  final surveyData =
      SurveyData(accessToken: accessToken, id: question.idSurvey);
  final surveyProv = ref.watch(surveyProvider(question.idSurvey).notifier);
  return EditQuestionNotifier(
      question: question, surveyData: surveyData, surveyNotifier: surveyProv);
});
