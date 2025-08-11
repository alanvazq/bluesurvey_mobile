import 'package:bluesurvey_app/domain/entities/answer.dart';

class Question {
  final String id;
  final String idUser;
  final String idSurvey;
  final String typeQuestion;
  final String question;
  final List<Answer> answers;

  Question({
    required this.id,
    required this.idUser,
    required this.idSurvey,
    required this.typeQuestion,
    required this.question,
    required this.answers,
  });
}
