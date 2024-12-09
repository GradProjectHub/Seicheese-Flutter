class ApiConfig {
  static const String baseUrl = const String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:1300',
  );

  // APIのエンドポイントを定数として定義
  static const String registerSeichi = '/api/seichi/register';
  static const String listSeichi = '/api/seichi/list';
}
