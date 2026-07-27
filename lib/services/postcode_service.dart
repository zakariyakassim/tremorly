import 'package:dio/dio.dart';
import '../models/postcode.dart';
import 'api_exception.dart';

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

  /// Returns postcode matches for a partial, case-insensitive query.
  Future<List<Postcode>> searchPostcodes(String query, {int limit = 8}) async {
    final normalized = query
        .trim()
        .replaceAll(RegExp(r'\s+'), ' ')
        .toUpperCase();
    if (normalized.length < 2) {
      return const [];
    }

    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/postcodes',
        queryParameters: {'query': normalized, 'limit': limit},
      );
      final results = response.data?['result'];
      if (response.statusCode != 200 || results is! List) {
        throw const ApiException('Postcode suggestions are unavailable.');
      }

      final postcodes = <Postcode>[];
      for (final result in results.whereType<Map>()) {
        try {
          postcodes.add(Postcode.fromJson(Map<String, dynamic>.from(result)));
        } on FormatException {
          // Some territories can have postcode records without coordinates.
        }
      }
      return postcodes;
    } on DioException {
      throw const ApiException(
        'We could not load postcode suggestions. Keep typing or try again.',
      );
    } on ApiException {
      rethrow;
    } catch (_) {
      throw const ApiException(
        'We could not read the postcode suggestions returned.',
      );
    }
  }

  /// Validates and fetches postcode data from postcodes.io API
  Future<Postcode> validatePostcode(String postcode) async {
    final cleanedPostcode = postcode
        .replaceAll(RegExp(r'\s+'), '')
        .toUpperCase();

    if (cleanedPostcode.isEmpty) {
      throw const ApiException('Enter a UK postcode to continue.');
    }

    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/postcodes/${Uri.encodeComponent(cleanedPostcode)}',
      );
      final result = response.data?['result'];
      if (response.statusCode == 200 && result is Map) {
        return Postcode.fromJson(Map<String, dynamic>.from(result));
      }
      throw const ApiException('That postcode could not be validated.');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw const ApiException('Postcode not found. Check it and try again.');
      }
      throw const ApiException(
        'We could not validate that postcode. Please try again.',
      );
    } on FormatException {
      throw const ApiException(
        'The postcode service returned incomplete location data.',
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw const ApiException(
        'We could not validate that postcode. Please try again.',
      );
    }
  }

  /// Formats a postcode to standard format (e.g., "SW1A1AA" -> "SW1A 1AA")
  String formatPostcode(String postcode) {
    final cleaned = postcode.replaceAll(RegExp(r'\s+'), '').toUpperCase();
    if (cleaned.length > 3) {
      final split = cleaned.length - 3;
      return '${cleaned.substring(0, split)} ${cleaned.substring(split)}';
    }
    return cleaned;
  }
}
