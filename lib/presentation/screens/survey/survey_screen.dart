import 'package:bluesurvey_app/domain/entities/question.dart';
import 'package:bluesurvey_app/presentation/providers/survey/survey_provider.dart';
import 'package:bluesurvey_app/presentation/widgets/custom_text_field.dart';
import 'package:bluesurvey_app/presentation/widgets/edit_question.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class SurveyScreen extends ConsumerWidget {
  final String surveyId;
  const SurveyScreen({super.key, required this.surveyId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final surveyState = ref.watch(surveyProvider(surveyId));
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(),
        body: surveyState.isLoading
            ? Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
            : SurveyView(
                surveyId: surveyId,
              ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: "add",
              onPressed: () {
                final newQuestion = Question(
                    id: "n-${Uuid().v4()}",
                    idUser: surveyState.survey!.idUser,
                    idSurvey: surveyId,
                    typeQuestion: "open",
                    question: "",
                    answers: []);

                addNewQuestion(context, newQuestion);
              },
              backgroundColor: colors.primary,
              child: Icon(
                Icons.add,
                color: colors.onPrimary,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            FloatingActionButton(
              heroTag: "save",
              backgroundColor: colors.secondary,
              onPressed: surveyState.changesInSurvey
                  ? () {
                      ref.read(surveyProvider(surveyId).notifier).saveChanges();
                    }
                  : null,
              child: surveyState.isPosting
                  ? CircularProgressIndicator(
                      strokeWidth: 1,
                    )
                  : Icon(Icons.save,
                      color: surveyState.changesInSurvey
                          ? colors.onSecondary
                          : null),
            ),
            SizedBox(
              height: 10,
            ),
            FloatingActionButton(
              heroTag: "link",
              onPressed: () {},
              child: Icon(
                Icons.link,
                color: colors.onSecondary,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            FloatingActionButton(
              heroTag: "chart",
              onPressed: () {},
              child: Icon(
                Icons.bar_chart_rounded,
                color: colors.onSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  addNewQuestion(context, question) {
    showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return EditQuestion(question: question, isNewQuestion: true,);
        });
  }
}

class SurveyView extends ConsumerWidget {
  final String surveyId;
  const SurveyView({super.key, required this.surveyId});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        children: [
          TitleAndDescriptionView(
            surveyId: surveyId,
          ),
          SizedBox(
            height: 20,
          ),
          QuestionsView(
            surveyId: surveyId,
          )
        ],
      ),
    );
  }
}

class TitleAndDescriptionView extends ConsumerWidget {
  final String surveyId;
  const TitleAndDescriptionView({super.key, required this.surveyId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final surveyState = ref.watch(surveyProvider(surveyId));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Titulo",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: colors.primary),
        ),
        CustomTextField(
          isParagraph: true,
          initialValue: surveyState.surveyTitle.value,
          onChanged:
              ref.read(surveyProvider(surveyId).notifier).onTitleSurveyChanged,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "Descripción",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: colors.primary),
        ),
        CustomTextField(
          isParagraph: true,
          initialValue: surveyState.surveyDescription.value,
          onChanged:
              ref.read(surveyProvider(surveyId).notifier).onDescriptionChanged,
        )
      ],
    );
  }
}

class QuestionsView extends ConsumerWidget {
  final String surveyId;
  const QuestionsView({super.key, required this.surveyId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final surveyState = ref.watch(surveyProvider(surveyId));
    return Expanded(
      child: ListView.builder(
          padding: EdgeInsets.all(0),
          itemCount: surveyState.questions.length,
          itemBuilder: (context, index) {
            final Question question = surveyState.questions[index];
            return Container(
              margin: EdgeInsets.only(bottom: 10),
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: colors.primaryContainer),
              child: GestureDetector(
                onTap: () {
                  editQuestion(context, question);
                },
                child: ListTile(
                  title: Text(question.question),
                  subtitle: _getQuestionSubtitle(question),
                  leading: Icon(
                    _getQuestionIcon(question.typeQuestion),
                  ),
                ),
              ),
            );
          }),
    );
  }

  editQuestion(context, question) {
    showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return EditQuestion(question: question);
        });
  }

  IconData _getQuestionIcon(String type) {
    switch (type) {
      case 'open':
        return Icons.short_text_rounded;
      case 'multipleOption':
        return Icons.check_box;
      case 'singleOption':
        return Icons.radio_button_checked;
      default:
        return Icons.help_outline;
    }
  }

  Widget _getQuestionSubtitle(Question question) {
    if (question.typeQuestion == 'open') {
      return Text('Texto de respuesta');
    } else if (question.typeQuestion == 'multipleOption' ||
        question.typeQuestion == 'singleOption') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            question.answers.map((answer) => Text(answer.answer)).toList(),
      );
    } else {
      return Text('Tipo de pregunta desconocido');
    }
  }
}
