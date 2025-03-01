import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static initEnvirontment() async {
    await dotenv.load(fileName: ".env");
  }

  static String apiUrl = dotenv.env["API_URL"] ?? "API_URL No configurada";
  static String webBlueSurvey = dotenv.env["WEB_BLUESURVEY_URL"] ?? "WEB_BLUESURVEY_URL No configurada";
}
