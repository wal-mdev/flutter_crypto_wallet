import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static final AppConfig _instance = AppConfig._internal();
  factory AppConfig() => _instance;
  AppConfig._internal();

  String get baseUrl => dotenv.env['COINGECKO_BASE_URL'] ?? '';
  String get apiKey => dotenv.env['COINGECKO_API_KEY'] ?? '';

  Map<String, String> get headers => {
    'x-cg-demo-api-key': apiKey,
    'Accept': 'application/json',
  };
}
