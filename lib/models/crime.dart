/// Crime model for representing crime data from UK Police API
class Crime {
  final int id;
  final String category;
  final String streetName;
  final String latitude;
  final String longitude;
  final String month;
  final String? outcomeStatus;

  Crime({
    required this.id,
    required this.category,
    required this.streetName,
    required this.latitude,
    required this.longitude,
    required this.month,
    this.outcomeStatus,
  });

  factory Crime.fromJson(Map<String, dynamic> json) {
    final location = json['location'] as Map<String, dynamic>? ?? {};
    final street = location['street'] as Map<String, dynamic>? ?? {};

    // Helper function to safely extract string values
    String? _safeString(dynamic value) {
      if (value == null) return null;
      if (value is String) return value;
      if (value is Map) return null; // Skip maps, they're not strings
      return value.toString();
    }

    return Crime(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id'].toString()) ?? 0,
      category: _safeString(json['category']) ?? 'Unknown',
      streetName: _safeString(street['name']) ?? 'Unknown location',
      latitude: _safeString(location['latitude']) ?? '0',
      longitude: _safeString(location['longitude']) ?? '0',
      month: _safeString(json['month']) ?? '',
      outcomeStatus: _safeString(json['outcome_status']),
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
