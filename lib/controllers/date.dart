import 'package:intl/intl.dart';

class DateController {
  static String formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final delta = now.difference(timestamp);

    if (delta.inSeconds < 60) {
      return delta.inSeconds.toString() + "s ago";
    } else if (delta.inMinutes < 60) {
      return delta.inMinutes.toString() + "min ago";
    } else if (delta.inHours < 24) {
      return delta.inHours.toString() + "h ago";
    } else if (delta.inDays < 30) {
      return delta.inDays.toString() + "d ago";
    } else if (delta.inDays / 30 < 12) {
      return (delta.inDays / 30).toString() + "m ago";
    } else {
      return DateFormat("MM/yy").format(timestamp);
    }
  }
}