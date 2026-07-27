/// Postcode model for API responses from postcodes.io
class Postcode {
  final String postcode;
  final String outcode;
  final String incode;
  final String region;
  final String adminDistrict;
  final String? msoa;
  final double latitude;
  final double longitude;

  Postcode({
    required this.postcode,
    required this.outcode,
    required this.incode,
    required this.region,
    required this.adminDistrict,
    this.msoa,
    required this.latitude,
    required this.longitude,
  });

  factory Postcode.fromJson(Map<String, dynamic> json) {
    final latitude = (json['latitude'] as num?)?.toDouble();
    final longitude = (json['longitude'] as num?)?.toDouble();

    if (latitude == null || longitude == null) {
      throw FormatException('Missing coordinates in postcode response');
    }

    return Postcode(
      postcode: json['postcode'] as String? ?? '',
      outcode: json['outcode'] as String? ?? '',
      incode: json['incode'] as String? ?? '',
      region: json['region'] as String? ?? '',
      adminDistrict: json['admin_district'] as String? ?? '',
      msoa: json['msoa'] as String?,
      latitude: latitude,
      longitude: longitude,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'postcode': postcode,
      'outcode': outcode,
      'incode': incode,
      'region': region,
      'admin_district': adminDistrict,
      'msoa': msoa,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
