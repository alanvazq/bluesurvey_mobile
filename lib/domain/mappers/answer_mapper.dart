import 'package:bluesurvey_app/domain/entities/answer.dart';

class AnswerMapper {
  static Answer answerFromEntity(Map<String, dynamic> json) =>
      Answer(answer: json['answer'], count: json['count'], id: json['_id']);
}
