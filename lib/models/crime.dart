/// Crime model for representing crime data from UK Police API
class Crime {
  final int id;
  final String category;
  final String streetName;
  final String latitude;
  final String longitude;
  final String month;
  final String? outcomeStatus;

  const Crime({
    required this.id,
    required this.category,
    required this.streetName,
    required this.latitude,
    required this.longitude,
    required this.month,
    this.outcomeStatus,
  });

  factory Crime.fromJson(Map<String, dynamic> json) {
    final location = _safeMap(json['location']);
    final street = _safeMap(location['street']);
    final outcome = _safeMap(json['outcome_status']);

    return Crime(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(_safeString(json['id']) ?? '') ?? 0,
      category: _safeString(json['category']) ?? 'unknown',
      streetName: _safeString(street['name']) ?? 'Location unavailable',
      latitude: _safeString(location['latitude']) ?? '',
      longitude: _safeString(location['longitude']) ?? '',
      month: _safeString(json['month']) ?? '',
      outcomeStatus:
          _safeString(outcome['category']) ??
          _safeString(json['outcome_status']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'street_name': streetName,
      'latitude': latitude,
      'longitude': longitude,
      'month': month,
      'outcome_status': outcomeStatus,
    };
  }
}

Map<String, dynamic> _safeMap(dynamic value) {
  if (value is Map<String, dynamic>) {
    return value;
  }
  if (value is Map) {
    return value.map((key, value) => MapEntry(key.toString(), value));
  }
  return const {};
}

String? _safeString(dynamic value) {
  if (value == null || value is Map || value is Iterable) {
    return null;
  }
  final text = value.toString().trim();
  return text.isEmpty ? null : text;
}
