import 'package:bluesurvey_app/presentation/widgets/create_survey_modal.dart';
import 'package:flutter/material.dart';

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
    showModalBottomSheet(context: context, builder: (context) {
      return CreateSurveyModal();
    });
    // showDialog(
    //     context: context,
    //     builder: (context) {
    //       return CreateSurveyModal();
    //     });
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
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
    );
  }
}

class SurveysView extends StatelessWidget {
  const SurveysView({super.key});

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

class HeaderView extends StatelessWidget {
  const HeaderView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

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
              Container(
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.secondary,
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.dark_mode),
                  color: colors.onPrimary,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.secondary,
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.exit_to_app_rounded),
                  color: colors.onPrimary,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
