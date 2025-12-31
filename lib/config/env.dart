class Env {
  // 環境変数から読み込む想定だが、現在は定数定義
  static const bool useMock = true;
  
  // 将来的には dotenv.env['API_URL'] など
  static const String apiUrl = 'https://api.example.com';
}
