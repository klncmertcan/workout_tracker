import 'package:intl/intl.dart';

// Formats a weight value
String formatWeight(double w) {
  return w == w.roundToDouble() ? w.toStringAsFixed(0) : w.toString();
}

/// Today's date as 'YYYY-MM-DD' — the format stored in the database.
String todayAsDbDate() {
  return DateTime.now().toIso8601String().substring(0, 10);
}

/// Formats a stored 'YYYY-MM-DD' date for display, e.g. "Tuesday, Aug 18".
String formatWorkoutDate(String dbDate) {
  return DateFormat('EEEE, MMM d').format(DateTime.parse(dbDate));
}
