import 'package:dio/dio.dart';
import 'package:tremorly/models/crime.dart';

/// Service for fetching crime data from UK Police API
class CrimeService {
  static const String baseUrl = 'https://data.police.uk/api';

  final Dio _dio;

  CrimeService({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: baseUrl,
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
            ),
          );

  /// Fetch crimes for specific coordinates
  Future<List<Crime>> getCrimesByCoordinates(
    double latitude,
    double longitude,
  ) async {
    if (latitude == 0.0 && longitude == 0.0) {
      throw Exception(
        'Invalid coordinates: postcode validation may have failed',
      );
    }

    try {
      final response = await _dio.get(
        '/crimes-street/all-crime',
        queryParameters: {'lat': latitude, 'lng': longitude},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Crime.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load crimes');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('No crimes found for the given coordinates');
      }
      throw Exception('Error fetching crimes: ${e.message}');
    } catch (e) {
      throw Exception('Error fetching crimes: $e');
    }
  }

  /// Get crime summary statistics
  Future<Map<String, int>> getCrimeSummary(
    double latitude,
    double longitude,
  ) async {
    try {
      final crimes = await getCrimesByCoordinates(latitude, longitude);
      final summary = <String, int>{};

      for (final crime in crimes) {
        summary[crime.category] = (summary[crime.category] ?? 0) + 1;
      }

      return summary;
    } catch (e) {
      throw Exception('Error fetching crime summary: $e');
    }
  }
}
