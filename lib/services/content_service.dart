// lib/services/content_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:seicheese/models/content.dart';

class ContentService {
  final String? authToken;
  late final String baseUrl;

  ContentService({this.authToken}) {
    final host = dotenv.env['LOCAL_IP_ADDR'];
    baseUrl = 'http://$host:1300/api/contents';
  }

  Future<List<Content>> searchContents(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/search?q=$query'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList =
            jsonDecode(utf8.decode(response.bodyBytes));
        return jsonList.map((json) => Content.fromJson(json)).toList();
      } else {
        return []; // エラー時や結果が空の場合は空リストを返す
      }
    } catch (e) {
      print('Error in searchContents: $e');
      return []; // エラー時は空リストを返す
    }
  }

  Future<Content> registerContent(Content content) async {
    try {
      print('Registering content at: $baseUrl/register');
      print('Content data: ${content.toJson()}');

      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode(content.toJson()),
      );

      if (response.statusCode == 201) {
        // デコード部分を確認
        final decodedBody = utf8.decode(response.bodyBytes);
        return Content.fromJson(jsonDecode(decodedBody));
      } else {
        final decodedBody = utf8.decode(response.bodyBytes);
        throw Exception('Failed to register content: $decodedBody');
      }
    } catch (e) {
      print('Error registering content: $e');
      rethrow;
    }
  }
}
