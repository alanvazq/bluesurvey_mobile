import 'package:bluesurvey_app/domain/entities/question.dart';
import 'package:bluesurvey_app/presentation/providers/survey/edit_question_provider.dart';
import 'package:bluesurvey_app/presentation/providers/survey/survey_provider.dart';
import 'package:bluesurvey_app/presentation/widgets/custom_text_field.dart';
import 'package:bluesurvey_app/presentation/widgets/select_type_question.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditQuestion extends ConsumerWidget {
  final Question question;
  final bool isNewQuestion;
  const EditQuestion(
      {super.key, required this.question, this.isNewQuestion = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final questionState = ref.watch(editQuestionProvider(question));
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          top: 30,
          left: 30,
          right: 30,
          bottom: MediaQuery.of(context).viewInsets.bottom > 0
              ? MediaQuery.of(context).viewInsets.bottom + 10
              : 30,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              isTitleQuestion: true,
              isParagraph: true,
              initialValue: question.question,
              hint: 'Título de pregunta',
              onChanged: ref
                  .read(editQuestionProvider(question).notifier)
                  .onTitleQuestionChanged,
            ),
            SizedBox(height: 10),
            if (questionState.typeQuestion == 'multipleOption' ||
                questionState.typeQuestion == 'singleOption') ...[
              Text(
                "Respuestas:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Column(
                children: questionState.answers.map((answer) {
                  return Padding(
                    key: ValueKey(answer.id),
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            initialValue: answer.answer,
                            key: ValueKey(answer.id),
                            onChanged: (value) {
                              ref
                                  .read(editQuestionProvider(question).notifier)
                                  .onAnswerChanged(answer.id, value);
                            },
                            hint: "Título respuesta",
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.highlight_remove),
                          onPressed: () {
                            ref
                                .read(editQuestionProvider(question).notifier)
                                .removeAnswer(answer.id);
                          },
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 5),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ref
                        .read(editQuestionProvider(question).notifier)
                        .addNewAnswer();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(16),
                    backgroundColor: colors.secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    "Añadir",
                    style: TextStyle(
                      color: colors.onSecondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
            SizedBox(height: 10),
            SelectTypeQuestion(
              question: question,
            ),
            SizedBox(height: 10),
            if (questionState.typeQuestion != "open") ...[],
            Row(
              children: [
                ElevatedButton(
                  onPressed: questionState.changesInQuestion
                      ? () {
                          ref
                              .read(editQuestionProvider(question).notifier)
                              .updateOrCreateQuestions(isNewQuestion);
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(16),
                    backgroundColor: colors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    "Guardar",
                    style: TextStyle(
                      color: colors.onPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    ref
                        .read(surveyProvider(question.idSurvey).notifier)
                        .deleteQuestion(question.id);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(16),
                    backgroundColor: colors.tertiary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    "Eliminar",
                    style: TextStyle(
                      color: colors.onPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
