import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateText extends StatelessWidget {
  final String date;
  final String? pattern;
  final bool onlyDate;
  final bool onlyTime;
  final bool missYear;
  final bool missSecond;
  final bool relative;
  final TextStyle? style;

  const DateText(
    this.date, {
    Key? key,
    this.pattern,
    this.onlyDate = false,
    this.onlyTime = false,
    this.missYear = false,
    this.missSecond = false,
    this.relative = false,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateTime = DateTime.parse(date);

    String dateText;
    if (relative) {
      dateText = _RelativeDateFormatter.format(dateTime);
    } else {
      var pattern = this.pattern ?? "MM/dd/yyyy hh:mm:ss a";
      if (this.pattern == null) {
        if (onlyDate) {
          pattern = pattern.split(" ")[0];
        } else if (onlyTime) {
          pattern = pattern.substring(11, pattern.length);
        }
        if (missYear) {
          pattern = pattern.replaceAll("/yyyy", "");
        }
        if (missSecond) pattern = pattern.replaceAll(":ss", "");
      }
      dateText = DateFormat(pattern).format(dateTime);
    }

    return Text(dateText, style: style);
  }
}

class _RelativeDateFormatter {
  static String format(DateTime date) {
    const num _oneMinute = 60000;
    const num _oneHour = 3600000;
    const num _oneDay = 86400000;
    const num _oneWeek = 604800000;

    final delta =
        DateTime.now().millisecondsSinceEpoch - date.millisecondsSinceEpoch;

    if (delta < 60 * _oneMinute) {
      num minutes = _toMinutes(delta).toInt();
      if (minutes <= 1) {
        return "$minutes minute ago";
      } else {
        return "$minutes minutes ago";
      }
    }
    if (delta < 24 * _oneHour) {
      num hours = _toHours(delta).toInt();
      if (hours <= 1) {
        return "$hours hour ago";
      } else {
        return "$hours hours ago";
      }
    }
    if (delta < 30 * _oneDay) {
      num days = _toDays(delta).toInt();
      if (days <= 1) {
        return "$days day ago";
      } else {
        return "$days days ago";
      }
    }
    if (delta < 12 * 4 * _oneWeek) {
      num months = _toMonths(delta).toInt();
      if (months <= 1) {
        return "$months month ago";
      } else {
        return "$months months ago";
      }
    }
    return DateFormat("MM/dd/yyyy").format(date);
  }

  static num _toSeconds(num date) {
    return date / 1000;
  }

  static num _toMinutes(num date) {
    return _toSeconds(date) / 60;
  }

  static num _toHours(num date) {
    return _toMinutes(date) / 60;
  }

  static num _toDays(num date) {
    return _toHours(date) / 24;
  }

  static num _toMonths(num date) {
    return _toDays(date) / 30;
  }
}
