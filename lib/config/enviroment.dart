import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' show dotenv;


class Enviroment {
  static String get file{
    if(kReleaseMode){
      return '.env.prod';
    } else if(kDebugMode){
      return '.env.dev';
    } else {
      return '.env';
    }
  }

  static String get apiSmartTollsURL{
    return dotenv.env['API_SMART_TOLLS_URL'] ?? '';
  }
}