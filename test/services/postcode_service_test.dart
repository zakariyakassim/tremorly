import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tremorly/services/postcode_service.dart';

void main() {
  test('returns matching postcode suggestions with coordinates', () async {
    final adapter = _JsonAdapter({
      'status': 200,
      'result': [
        {
          'postcode': 'SW1A 1AA',
          'outcode': 'SW1A',
          'incode': '1AA',
          'region': 'London',
          'admin_district': 'Westminster',
          'latitude': 51.501009,
          'longitude': -0.141588,
        },
        {
          'postcode': 'SW1A 2AA',
          'outcode': 'SW1A',
          'incode': '2AA',
          'region': 'London',
          'admin_district': 'Westminster',
          'latitude': 51.50354,
          'longitude': -0.127695,
        },
      ],
    });
    final dio = Dio(BaseOptions(baseUrl: PostcodeService.baseUrl))
      ..httpClientAdapter = adapter;

    final results = await PostcodeService(
      dio: dio,
    ).searchPostcodes('sw1a', limit: 8);

    expect(adapter.lastOptions?.path, '/postcodes');
    expect(adapter.lastOptions?.queryParameters, {'query': 'SW1A', 'limit': 8});
    expect(results.map((postcode) => postcode.postcode), [
      'SW1A 1AA',
      'SW1A 2AA',
    ]);
  });

  test('validates a normalized postcode and parses its coordinates', () async {
    final adapter = _JsonAdapter({
      'status': 200,
      'result': {
        'postcode': 'SW1A 1AA',
        'outcode': 'SW1A',
        'incode': '1AA',
        'region': 'London',
        'admin_district': 'Westminster',
        'msoa': null,
        'latitude': 51.501009,
        'longitude': -0.141588,
      },
    });
    final dio = Dio(BaseOptions(baseUrl: PostcodeService.baseUrl))
      ..httpClientAdapter = adapter;

    final result = await PostcodeService(dio: dio).validatePostcode('sw1a 1aa');

    expect(adapter.lastOptions?.path, '/postcodes/SW1A1AA');
    expect(result.postcode, 'SW1A 1AA');
    expect(result.latitude, 51.501009);
    expect(result.longitude, -0.141588);
  });
}

class _JsonAdapter implements HttpClientAdapter {
  final Object payload;
  RequestOptions? lastOptions;

  _JsonAdapter(this.payload);

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastOptions = options;
    return ResponseBody.fromString(
      jsonEncode(payload),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
