import 'package:bluesurvey_app/presentation/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class SurveyScreen extends StatelessWidget {
  const SurveyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SurveyView(),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {},
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
              onPressed: () {},
              child: Icon(Icons.save),
            ),
            SizedBox(
              height: 10,
            ),
            FloatingActionButton(
              onPressed: () {},
              child: Icon(Icons.link),
            ),
            SizedBox(
              height: 10,
            ),
            FloatingActionButton(
              onPressed: () {},
              child: Icon(Icons.bar_chart_rounded),
            ),
          ],
        ),
      ),
    );
  }
}

class SurveyView extends StatelessWidget {
  const SurveyView({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
      child: Column(
        children: [
          TitleAndDescriptionView(),
          SizedBox(
            height: 20,
          ),
          QuestionsView()
        ],
      ),
    );
  }
}

class TitleAndDescriptionView extends StatelessWidget {
  const TitleAndDescriptionView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Titulo",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colors.onSurfaceVariant),
        ),
        CustomTextField(
          isParagraph: true,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "Descripción",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colors.onSurfaceVariant),
        ),
        CustomTextField(
          isParagraph: true,
        )
      ],
    );
  }
}

class QuestionsView extends StatelessWidget {
  const QuestionsView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Expanded(
      child: ListView.builder(
          padding: EdgeInsets.all(0),
          itemCount: 5,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(bottom: 10),
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: colors.primaryContainer),
              child: ListTile(
                title: Text("Encuesta"),
                leading: Text(
                  "${index + 1}",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: colors.primary),
                ),
              ),
            );
          }),
    );
  }
}
