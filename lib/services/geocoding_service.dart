import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeocodingService {
  final String baseUrl = 'https://maps.googleapis.com/maps/api/geocode/json';
  final String apiKey = dotenv.env['GOOGLE_MAPS_API_KEY']!;

  Future<Map<String, String>> getAddressFromLatLng(
      double lat, double lng) async {
    final response = await http.get(
      Uri.parse(
          '$baseUrl?latlng=$lat,$lng&key=$apiKey&language=ja&result_type=street_address'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final results = data['results'] as List<dynamic>;
      if (results.isNotEmpty) {
        final addressComponents =
            results[0]['address_components'] as List<dynamic>;
        String postalCode = '';
        String address = '';

        for (var component in addressComponents) {
          final types = component['types'] as List<dynamic>;
          if (types.contains('postal_code')) {
            postalCode = component['long_name'];
          } else if (types.contains('route') ||
              types.contains('locality') ||
              types.contains('administrative_area_level_1')) {
            address += component['long_name'] + ' ';
          }
        }

        return {
          'postalCode': postalCode,
          'address': address.trim(),
        };
      }
    }

    throw Exception('Failed to get address from latlng');
  }
}
