import 'package:dio/dio.dart';
import 'package:tremorly/models/crime.dart';
import 'api_exception.dart';

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
      throw const ApiException(
        'The postcode did not provide usable coordinates.',
      );
    }

    try {
      final response = await _dio.get<List<dynamic>>(
        '/crimes-street/all-crime',
        queryParameters: {'lat': latitude, 'lng': longitude},
      );
      final data = response.data;
      if (response.statusCode == 200 && data != null) {
        return data
            .whereType<Map>()
            .map((json) => Crime.fromJson(Map<String, dynamic>.from(json)))
            .toList(growable: false);
      }
      throw const ApiException('Crime data is unavailable right now.');
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw const ApiException(
          'The Police API could not search this location.',
        );
      }
      throw const ApiException(
        'We could not load nearby incidents. Please try again.',
      );
    } on ApiException {
      rethrow;
    } catch (_) {
      throw const ApiException(
        'We could not read the crime data returned for this area.',
      );
    }
  }

  /// Builds category totals from a fetched crime list without another request.
  Map<String, int> summarize(List<Crime> crimes) {
    final summary = <String, int>{};
    for (final crime in crimes) {
      summary.update(crime.category, (count) => count + 1, ifAbsent: () => 1);
    }
    return summary;
  }
}
