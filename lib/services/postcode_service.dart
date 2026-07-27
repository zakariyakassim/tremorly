import 'package:dio/dio.dart';
import '../models/postcode.dart';

/// Service for postcode-related operations using postcodes.io API
class PostcodeService {
  static const String baseUrl = 'https://api.postcodes.io';

  final Dio _dio;

  PostcodeService({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: baseUrl,
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
            ),
          );

  /// Validates and fetches postcode data from postcodes.io API
  Future<Postcode> validatePostcode(String postcode) async {
    try {
      final cleanedPostcode = postcode.replaceAll(' ', '').toUpperCase();

      if (cleanedPostcode.isEmpty) {
        throw Exception('Postcode cannot be empty');
      }

      final response = await _dio.get('/postcodes/$cleanedPostcode');

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data['result'] != null) {
          return Postcode.fromJson(data['result']);
        } else {
          throw Exception('Invalid postcode');
        }
      } else {
        throw Exception('Failed to validate postcode');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Postcode not found');
      }
      throw Exception('Error validating postcode: ${e.message}');
    } catch (e) {
      throw Exception('Error validating postcode: $e');
    }
  }

  /// Formats a postcode to standard format (e.g., "SW1A1AA" -> "SW1A 1AA")
  String formatPostcode(String postcode) {
    final cleaned = postcode.replaceAll(' ', '').toUpperCase();
    if (cleaned.length == 6) {
      return '${cleaned.substring(0, 2)} ${cleaned.substring(2)}';
    }
    if (cleaned.length == 7) {
      return '${cleaned.substring(0, 3)} ${cleaned.substring(3)}';
    }
    return postcode;
  }
}
