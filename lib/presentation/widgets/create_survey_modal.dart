import 'package:bluesurvey_app/presentation/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class CreateSurveyModal extends StatelessWidget {
  const CreateSurveyModal({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
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
          ),
          SizedBox(
            height: 10,
          ),
          CustomTextField(
            label: "Descripción",
            isParagraph: true,
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
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
