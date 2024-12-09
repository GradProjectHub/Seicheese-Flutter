import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/genre.dart';

class GenreService {
  final String authToken;
  final String baseUrl = 'http://192.168.1.23:1300';

  GenreService({required this.authToken});

  Future<List<Genre>> getGenres() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/genres'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Accept': 'application/json; charset=utf-8',
          'Content-Type': 'application/json; charset=utf-8',
        },
      );

      print('Genre response status: ${response.statusCode}'); // デバッグ用
      print('Genre response body: ${response.body}'); // デバッグ用

      if (response.statusCode == 200) {
        final List<dynamic> jsonList =
            json.decode(utf8.decode(response.bodyBytes));
        return jsonList.map((json) => Genre.fromJson(json)).toList();
      } else {
        throw Exception('ジャンルの取得に失敗しました: ${response.statusCode}');
      }
    } catch (e) {
      print('ジャンル取得エラー: $e');
      rethrow;
    }
  }
}
