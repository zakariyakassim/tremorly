String formatCrimeCategory(String value) {
  final words = value
      .trim()
      .replaceAll(RegExp(r'[-_]+'), ' ')
      .replaceAll(RegExp(r'\s+'), ' ');
  if (words.isEmpty || words.toLowerCase() == 'unknown') {
    return 'Other / unknown';
  }
  return '${words[0].toUpperCase()}${words.substring(1).toLowerCase()}';
}

String formatCrimeMonth(String value) {
  final match = RegExp(r'^(\d{4})-(\d{2})$').firstMatch(value);
  if (match == null) {
    return 'Latest available';
  }

  const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  final month = int.tryParse(match.group(2)!);
  if (month == null || month < 1 || month > 12) {
    return 'Latest available';
  }
  return '${months[month - 1]} ${match.group(1)}';
}
