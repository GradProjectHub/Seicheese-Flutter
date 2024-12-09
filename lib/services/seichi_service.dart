import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/seichi.dart';

class SeichiService {
  final String baseUrl =
      'http://${dotenv.env['LOCAL_IP_ADDR']}:1300/api/seichi';
  final String? authToken;

  SeichiService({this.authToken});

  Future<void> registerSeichi({
    required String name,
    required String description,
    required double latitude,
    required double longitude,
    required int contentId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'seichi_name': name,
          'comment': description,
          'latitude': latitude,
          'longitude': longitude,
          'content_id': contentId,
        }),
      );

      if (response.statusCode != 201) {
        final errorBody = jsonDecode(utf8.decode(response.bodyBytes));
        throw Exception(errorBody['error'] ?? '聖地の登録に失敗しました');
      }
    } catch (e) {
      throw Exception('聖地の登録に失敗しました: ${e.toString()}');
    }
  }

  Future<List<Seichi>> getSeichies() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/list'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Accept-Charset': 'utf-8',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        return data.map((json) => Seichi.fromJson(json)).toList();
      } else {
        throw Exception(
            'Failed to load seichies: ${utf8.decode(response.bodyBytes)}');
      }
    } catch (e) {
      print('Error in getSeichies: $e');
      rethrow;
    }
  }
}
