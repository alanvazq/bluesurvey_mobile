import 'package:bluesurvey_app/config/themes/theme_provider.dart';
import 'package:bluesurvey_app/domain/entities/survey.dart';
import 'package:bluesurvey_app/presentation/providers/auth/auth_provider.dart';
import 'package:bluesurvey_app/presentation/providers/survey/surveys_provider.dart';
import 'package:bluesurvey_app/presentation/widgets/create_survey_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colors.surface,
      body: HomeView(),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            createSurveyModal(context);
          },
          backgroundColor: colors.primary,
          child: Icon(
            Icons.add,
            color: colors.onPrimary,
          )),
    );
  }

  createSurveyModal(context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return CreateSurveyModal();
        });
  }
}

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;

    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
        ref.read(surveysProvider.notifier).loadSurveys();
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderView(),
            SizedBox(
              height: 20,
            ),
            Text(
              "Mis encuestas",
              style: TextStyle(
                  color: colors.onSurface,
                  fontSize: 24,
                  fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 20,
            ),
            SurveysView()
          ],
        ),
      ),
    );
  }
}

class SurveysView extends ConsumerWidget {
  const SurveysView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final surveysState = ref.watch(surveysProvider);
    return surveysState.isLoading
        ? Expanded(
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
          )
        : Expanded(
            child: surveysState.surveys.isEmpty
                ? Center(
                    child: Text(
                    'No hay encuestas creadas',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ))
                : ListView.builder(
                    padding: EdgeInsets.all(0),
                    itemCount: surveysState.surveys.length,
                    itemBuilder: (context, index) {
                      final Survey survey = surveysState.surveys[index];
                      return GestureDetector(
                        onTap: () {
                          context.push('/survey/${survey.id}');
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 10),
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: colors.primaryContainer),
                          child: ListTile(
                            title: Text(survey.title),
                            leading: Text(
                              "${index + 1}",
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: colors.primary),
                            ),
                          ),
                        ),
                      );
                    }),
          );
  }
}

class HeaderView extends ConsumerWidget {
  const HeaderView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final isDarkMode = ref.watch(isDarkModeProvider);
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: colors.primaryContainer,
          borderRadius: BorderRadius.circular(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(8)),
                child: Icon(
                  Icons.person,
                  size: 30,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Bienvenido",
                    style: TextStyle(
                        fontSize: 16,
                        color: colors.onPrimaryContainer,
                        fontWeight: FontWeight.normal),
                  ),
                  Text(
                    "Alan Gómez",
                    style: TextStyle(
                        fontSize: 18,
                        color: colors.onSurface,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              FloatingActionButton(
                  backgroundColor: colors.secondary,
                  heroTag: "theme_color",
                  mini: true,
                  elevation: 1,
                  onPressed: () {
                    ref
                        .read(isDarkModeProvider.notifier)
                        .update((state) => !state);
                  },
                  child: Icon(
                    isDarkMode ? Icons.sunny : Icons.dark_mode,
                    color: colors.primary,
                  )),
              SizedBox(
                width: 2,
              ),
              FloatingActionButton(
                  backgroundColor: colors.secondary,
                  heroTag: "exit",
                  mini: true,
                  elevation: 1,
                  onPressed: () {
                    ref.read(authProvider.notifier).logout();
                  },
                  child: Icon(
                    Icons.exit_to_app_rounded,
                    color: colors.primary,
                  )),
            ],
          )
        ],
      ),
    );
  }
}
