import 'package:bluesurvey_app/domain/entities/question.dart';
import 'package:bluesurvey_app/domain/mappers/answer_mapper.dart';

class QuestionMapper {
  static Question questionFromEntity(Map<String, dynamic> json) => Question(
        id: json['_id'],
        idUser: json['idUser'],
        idSurvey: json['idSurvey'],
        typeQuestion: json['typeQuestion'],
        question: json['question'],
        answers: (json['answers'] as List)
            .map((a) => AnswerMapper.answerFromEntity(a))
            .toList(),
      );
}
