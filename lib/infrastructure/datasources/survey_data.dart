import 'package:bluesurvey_app/config/constants/environment.dart';
import 'package:bluesurvey_app/domain/entities/answer.dart';
import 'package:bluesurvey_app/domain/entities/question.dart';
import 'package:bluesurvey_app/domain/entities/survey.dart';
import 'package:bluesurvey_app/domain/mappers/question_mapper.dart';
import 'package:bluesurvey_app/domain/mappers/survey_mapper.dart';
import 'package:bluesurvey_app/infrastructure/errors/custom_error.dart';
import 'package:dio/dio.dart';

class SurveyData {
  late final Dio dio;
  final String accessToken;
  final String? id;

  SurveyData({required this.accessToken, this.id})
      : dio = Dio(BaseOptions(
            baseUrl: Environment.apiUrl,
            headers: {'Authorization': 'Bearer $accessToken'}));

  Future<Survey> createSurvey(String title, String description) async {
    try {
      final response = await dio.post('/surveys', data: {
        'title': title,
        'description': description,
      });

      final survey = SurveyMapper.surveyFromEntity(response.data);
      return survey;
    } on DioException catch (error) {
      if (error.response?.statusCode == 400) {
        throw CustomError(
            error.response?.data['error'] ?? 'Todos los campos son requeridos');
      }
      if (error.type == DioExceptionType.connectionError) {
        throw CustomError('Revisar conexión a internet');
      }
      if (error.response?.statusCode == 500) {
        throw CustomError(
            error.response?.data['error'] ?? 'Error al crear la encuesta');
      }
      throw Exception();
    } catch (error) {
      throw Exception();
    }
  }

  Future<List> getSurveys() async {
    try {
      final response = await dio.get('/surveys');
      final List<Survey> surveys = [];
      for (final survey in response.data) {
        surveys.add(SurveyMapper.surveyFromEntity(survey));
      }
      return surveys;
    } on DioException catch (error) {
      if (error.response?.statusCode == 400) {
        throw CustomError(
            error.response?.data['error'] ?? 'Todos los campos son requeridos');
      }
      if (error.type == DioExceptionType.connectionError) {
        throw CustomError('Revisar conexión a internet');
      }
      if (error.response?.statusCode == 500) {
        throw CustomError(
            error.response?.data['error'] ?? 'Error al crear la encuesta');
      }
      throw Exception();
    } catch (error) {
      throw Exception();
    }
  }

  Future<Survey> getSurvey() async {
    try {
      final response = await dio.get('/surveys/$id');
      final survey = SurveyMapper.surveyFromEntity(response.data);
      return survey;
    } on DioException catch (error) {
      if (error.response?.statusCode == 400) {
        throw CustomError(
            error.response?.data['error'] ?? 'Todos los campos son requeridos');
      }
      if (error.type == DioExceptionType.connectionError) {
        throw CustomError('Revisar conexión a internet');
      }
      if (error.response?.statusCode == 500) {
        throw CustomError(
            error.response?.data['error'] ?? 'Error al crear la encuesta');
      }
      throw Exception();
    } catch (error) {
      throw Exception();
    }
  }

  Future<Survey> updateTitleOrDescription(
      String title, String description) async {
    try {
      final response = await dio.put('/surveys/$id', data: {
        "title": title,
        "description": description,
      });

      final survey = SurveyMapper.surveyFromEntity(response.data);
      return survey;
    } on DioException catch (error) {
      if (error.response?.statusCode == 400) {
        throw CustomError(
            error.response?.data['error'] ?? 'Todos los campos son requeridos');
      }
      if (error.type == DioExceptionType.connectionError) {
        throw CustomError('Revisar conexión a internet');
      }
      if (error.response?.statusCode == 500) {
        throw CustomError(
            error.response?.data['error'] ?? 'Error al crear la encuesta');
      }
      throw Exception();
    } catch (error) {
      throw Exception();
    }
  }

  Future<Question> createQuestion(
      String typeQuestion, String question, List<Answer> answers) async {
    try {
      final response = await dio.post('/surveys/$id/questions', data: {
        "typeQuestion": typeQuestion,
        "question": question,
        "answers": answers
      });

      final newQuestion = QuestionMapper.questionFromEntity(response.data);
      return newQuestion;
    } on DioException catch (error) {
      if (error.response?.statusCode == 400) {
        throw CustomError(
            error.response?.data['error'] ?? 'Todos los campos son requeridos');
      }
      if (error.type == DioExceptionType.connectionError) {
        throw CustomError('Revisar conexión a internet');
      }
      if (error.response?.statusCode == 500) {
        throw CustomError(
            error.response?.data['error'] ?? 'Error al crear la encuesta');
      }
      throw Exception();
    } catch (error) {
      throw Exception();
    }
  }

  Future<Question> updateQuestion(String questionId, List<Answer> answers,
      String titleQuestion, String typeQuestion) async {
    try {
      final response = await dio.put('/surveys/$id/questions', data: {
        "questionId": questionId,
        "answers": answers,
        "question": titleQuestion,
        "typeQuestion": typeQuestion,
      });

      final question = QuestionMapper.questionFromEntity(response.data);
      return question;
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) {
        throw CustomError(
            error.response?.data['error'] ?? 'Encuesta no encontrada');
      }
      if (error.response?.statusCode == 500) {
        throw CustomError(
            error.response?.data['error'] ?? 'Error al crear la encuesta');
      }
      if (error.type == DioExceptionType.connectionError) {
        throw CustomError('Revisar conexión a internet');
      }
      throw Exception();
    } catch (error) {
      throw Exception();
    }
  }

  Future<Survey> deleteQuestion(String questionId) async {
    try {
      final response = await dio.delete('/surveys/$id/questions', data: {
        "questionId": questionId,
      });

      final survey = SurveyMapper.surveyFromEntity(response.data);
      return survey;
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) {
        throw CustomError(
            error.response?.data['error'] ?? 'Pregunta no encontrada');
      }
      if (error.response?.statusCode == 500) {
        throw CustomError(
            error.response?.data['error'] ?? 'Error al eliminar la pregunta');
      }
      if (error.type == DioExceptionType.connectionError) {
        throw CustomError('Revisar conexión a internet');
      }
      throw Exception();
    } catch (error) {
      throw Exception();
    }
  }
}
