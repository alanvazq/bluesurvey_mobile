import 'package:bluesurvey_app/domain/entities/question.dart';
import 'package:bluesurvey_app/presentation/providers/survey/edit_question_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectTypeQuestion extends ConsumerWidget {
  final Question question;
  const SelectTypeQuestion({super.key, required this.question});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editQuestionState = ref.watch(editQuestionProvider(question));
    return SegmentedButton(
      segments: [
        ButtonSegment(value: "open", label: Text('Texto')),
        ButtonSegment(value: "singleOption", label: Text("Opción única")),
        ButtonSegment(value: "multipleOption", label: Text("Opción multiple"))
      ],
      selected: {editQuestionState.typeQuestion},
      onSelectionChanged: (value) {
        ref
            .read(editQuestionProvider(question).notifier)
            .onTypeQuestionChanged(value.first);
      },
    );
  }
}
