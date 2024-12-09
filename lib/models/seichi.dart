// lib/models/seichi.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Seichi {
  final int? id;
  final String name;
  final String? description;
  final double latitude;
  final double longitude;
  final int contentId;
  final String? contentName;
  final String? address;
  final String? postalCode;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Seichi({
    this.id,
    required this.name,
    this.description,
    required this.latitude,
    required this.longitude,
    required this.contentId,
    this.contentName,
    this.address,
    this.postalCode,
    this.createdAt,
    this.updatedAt,
  });

  factory Seichi.fromJson(Map<String, dynamic> json) {
    return Seichi(
      id: json['id'] as int?,
      name: json['name'] as String,
      description: json['description'] as String?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      contentId: json['content_id'] as int,
      contentName: (json['content_name'] as String).isEmpty
          ? null
          : json['content_name'] as String,
      address: json['address'] as String?,
      postalCode: json['postal_code'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'content_id': contentId,
      'content_name': contentName,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

// lib/services/seichi_service.dart
class SeichiService {
  final String baseUrl = '${dotenv.env['API_BASE_URL']}/api';
  final String? authToken;

  SeichiService({this.authToken});

  Future<Seichi> registerSeichi(Seichi seichi) async {
    final response = await http.post(
      Uri.parse('$baseUrl/seichi'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: jsonEncode(seichi.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to register seichi: ${response.body}');
    }

    return Seichi.fromJson(jsonDecode(response.body));
  }
}
