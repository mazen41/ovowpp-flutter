import 'package:intl/intl.dart';

import '../utils/util.dart';

class DateConverter {
  static String formatDate(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd hh:mm:ss').format(dateTime);
  }

  static String formatValidityDate(String dateString) {
    var inputDate = DateFormat('yyyy-MM-dd hh:mm:ss').parse(dateString);
    var outputFormat = DateFormat('dd MMM yyyy').format(inputDate);
    return outputFormat;
  }

  static String formatDateForPlan(String dateTimeString) {
    try {
      DateTime dateTime = DateTime.parse(dateTimeString);
      return "${dateTime.month.toString().padLeft(2, '0')}/"
          "${dateTime.day.toString().padLeft(2, '0')}/"
          "${dateTime.year}";
    } catch (e) {
      return "Invalid date";
    }
  }

  static String formatCreatedAt(String dateTimeString) {
    try {
      // Parse your input: "2026-01-17 18:23:24"
      DateTime dateTime = DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateTimeString);

      // Output: "Oct 28, 2025 10:00 AM"
      return DateFormat('MMM dd, yyyy hh:mm a').format(dateTime);
    } catch (e) {
      return '--';
    }
  }

  static String isoToLocalDateAndTime(String dateTime, {String errorResult = '--'}) {
    String date = '';
    if (dateTime.isEmpty || dateTime == 'null') {
      date = '';
    }
    try {
      date = DateFormat('dd MMM yyyy').format(isoStringToLocalDate(dateTime));
    } catch (v) {
      date = '';
    }
    String time = isoStringToLocalTimeOnly(dateTime);
    return '$date, $time';
  }

  static String formatDepositTimeWithAmFormat(String dateString) {
    var newStr = '${dateString.substring(0, 10)} ${dateString.substring(11, 23)}';
    DateTime dt = DateTime.parse(newStr);

    String formatedDate = DateFormat("yyyy-MM-dd").format(dt);

    return formatedDate;
  }

  static String estimatedDate(DateTime dateTime) {
    return DateFormat('dd MMM yyyy').format(dateTime);
  }

  static String estimatedDateTime(DateTime dateTime) {
    return DateFormat('dd MMM yyyy - hh:mm:ss a').format(dateTime);
  }

  static String estimatedTime(DateTime dateTime) {
    return DateFormat('hh:mm:ss a').format(dateTime);
  }

  static DateTime convertStringToDatetime(String dateTime) {
    return DateFormat("yyyy-MM-ddTHH:mm:ss.mmm").parse(dateTime);
  }

  static String convertIsoToString(String dateTime) {
    DateTime time = convertStringToDatetime(dateTime);
    String result = DateFormat('dd MMM yyyy hh:mm aa').format(time);
    return result;
  }

  static String convertUtcToLocalTime(String utcTimeString) {
    try {
      DateTime utcTime = DateTime.parse(utcTimeString);
      DateTime localTime = utcTime.toLocal();

      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day);
      DateTime yesterday = today.subtract(Duration(days: 1));

      DateTime localDate = DateTime(localTime.year, localTime.month, localTime.day);

      if (localDate == today) {
        // Show only time if it's today
        return DateFormat('hh:mm a').format(localTime);
      } else if (localDate == yesterday) {
        // Show "Yesterday"
        return "Yesterday";
      } else {
        // Show date + time
        return DateFormat('yyyy-MM-dd hh:mm a').format(localTime);
      }
    } catch (e) {
      printX("error : ${e.toString()}");
      return "Invalid Date";
    }
  }

  static String convertDateToString(String dateTime) {
    DateTime messageTime = convertStringToDatetime(dateTime).toLocal();
    DateTime now = DateTime.now();

    Duration difference = now.difference(messageTime);

    // Check if it's today (within 24 hours and same date)
    if (difference.inHours < 24 && now.day == messageTime.day) {
      return DateFormat('hh:mm a').format(messageTime); // just time
    }

    // Check if it was yesterday
    DateTime yesterday = now.subtract(Duration(days: 1));
    if (messageTime.year == yesterday.year &&
        messageTime.month == yesterday.month &&
        messageTime.day == yesterday.day) {
      return "Yesterday";
    }

    // Otherwise return date like 1/12/24
    return DateFormat('d/M/yy').format(messageTime);
  }

  static DateTime isoStringToLocalDate(String dateTime) {
    return DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').parse(dateTime, true).toLocal();
  }

  static String isoToLocalTimeSubtract(String dateTime) {
    DateTime date = isoStringToLocalDate(dateTime);
    final currentDate = DateTime.now();
    final difference = currentDate.difference(date).inDays;
    return difference.toString();
  }

  static String isoStringToLocalTimeOnly(String dateTime) {
    return DateFormat('hh:mm aa').format(isoStringToLocalDate(dateTime));
  }

  static String isoStringToLocalAMPM(String dateTime) {
    return DateFormat('a').format(isoStringToLocalDate(dateTime));
  }

  static String isoStringToLocalDateOnly(String dateTime) {
    try {
      return DateFormat('dd MMM yyyy').format(isoStringToLocalDate(dateTime));
    } catch (v) {
      return "--";
    }
  }

  static String isoStringToLocalFormattedDateOnly(String dateTime) {
    try {
      return DateFormat('dd MMM, yyyy').format(isoStringToLocalDate(dateTime));
    } catch (v) {
      return "--";
    }
  }

  static String localDateTime(DateTime dateTime) {
    return DateFormat('dd-MM-yyyy').format(dateTime.toUtc());
  }

  static String localDateToIsoString(DateTime dateTime) {
    return DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').format(dateTime.toUtc());
  }

  static String convertTimeToTime(String time) {
    return DateFormat('hh:mm a').format(DateFormat('hh:mm:ss').parse(time));
  }

  static String nextReturnTime(String dateTime) {
    final date = DateFormat("dd MMM, yyyy hh:mm a").format(DateTime.parse(dateTime));
    return date;
  }

  static String getFormatedSubtractTime(String time, {bool numericDates = false}) {
    final date1 = DateTime.now();
    final isoDate = isoStringToLocalDate(time);
    final difference = date1.difference(isoDate);

    if ((difference.inDays / 365).floor() >= 1) {
      int year = (difference.inDays / 365).floor();
      return '$year year ago';
    } else if ((difference.inDays / 30).floor() >= 1) {
      int month = (difference.inDays / 30).floor();
      return '$month month ago';
    } else if ((difference.inDays / 7).floor() >= 1) {
      int week = (difference.inDays / 7).floor();
      return '$week week ago';
    } else if (difference.inDays >= 1) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'Just now';
    }
  }
}
