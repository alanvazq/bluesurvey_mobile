import 'package:bluesurvey_app/domain/entities/survey.dart';
import 'package:bluesurvey_app/domain/mappers/question_mapper.dart';

class SurveyMapper {
  static Survey surveyFromEntity(Map<String, dynamic> json) => Survey(
        id: json['_id'],
        idUser: json['idUser'],
        title: json['title'],
        description: json['description'],
        questions: (json['questions'] as List)
            .map((q) => q is String ? q : QuestionMapper.questionFromEntity(q))
            .toList(),
      );
}
