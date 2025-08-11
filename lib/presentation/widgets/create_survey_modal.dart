import 'package:bluesurvey_app/presentation/providers/survey/create_survey_provider.dart';
import 'package:bluesurvey_app/presentation/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateSurveyModal extends ConsumerWidget {
  const CreateSurveyModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final createSurveyState = ref.watch(createSurveyProvider);
    return Padding(
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
          Text(
            "Nueva encuesta",
            style: TextStyle(
                color: colors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 24),
          ),
          SizedBox(
            height: 20,
          ),
          CustomTextField(
            label: "Titulo",
            isParagraph: true,
            onChanged: ref.read(createSurveyProvider.notifier).onTitleChanged,
            errorMessage: createSurveyState.isFormPosted
                ? createSurveyState.title.errorMessage
                : null,
          ),
          SizedBox(
            height: 10,
          ),
          CustomTextField(
            label: "Descripción",
            isParagraph: true,
            onChanged:
                ref.read(createSurveyProvider.notifier).onDescriptionChanged,
            errorMessage: createSurveyState.isFormPosted
                ? createSurveyState.description.errorMessage
                : null,
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: createSurveyState.isPosting
                    ? null
                    : () {
                        ref.read(createSurveyProvider.notifier).onFormSubmit();
                      },
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(16),
                    backgroundColor: colors.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15))),
                child: Text(
                  "Crear",
                  style: TextStyle(
                      color: colors.onPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ))
        ],
      ),
    );
  }
}
