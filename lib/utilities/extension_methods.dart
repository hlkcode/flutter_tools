import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension DurationExtensions on Duration {
  String toFormattedString() => '$this'.split('.').first.padLeft(8, '0');
}

extension TimeOfDayExtensions on TimeOfDay {
  TimeOfDay toUtc() {
    final now = DateTime.now().toUtc();
    return TimeOfDay.fromDateTime(
        DateTime(now.year, now.month, now.day, hour, minute).toUtc());
  }
}

extension StringExtensions on String {
  bool containsIgnoreCase(String other) =>
      toLowerCase().contains(other.toLowerCase());
  String toInitials() {
    final init = trim();
    final ar = init.split(' ').where((s) => s.isNotEmpty);
    return init.isEmpty
        ? '.'
        : ar.isEmpty
            ? init.substring(0, 1).toUpperCase()
            : ar.map((str) => str.toUpperCase()).join().substring(0, 1);
  }
}

extension ListExtensions on List {
  void addOrRemove(dynamic data) => contains(data) ? remove(data) : add(data);
}

extension Unique<E, Id> on List<E> {
  List<E> unique([Id Function(E element)? id, bool inplace = true]) {
    final ids = Set();
    var list = inplace ? this : List<E>.from(this);
    list.retainWhere((x) => ids.add(id != null ? id(x) : x as Id));
    return list;
  }
}

extension DateTimeExtensions on DateTime {
  String format(String format) => DateFormat(format).format(this);

  String toShortDate() => format('dd MM yy');
  String toDotedShortDate() => format('dd.MM.yy');
  String toDashedShortDate() => format('dd-MM-yy');

  String toLongDate() => format('dd MMM yyyy');
  String toDotedLongDate() => format('dd.MMM.yyyy');
  String toDashedLongDate() => format('dd-MMM-yyyy');

  String toLongTime() => format('hh:mm:ss');

  String toShortTime() => format('hh:mm');
  String toShortAmPmTime() => format('hh:mm a');

  String toShortDateTime() => format('dd MM yy hh:mm');
  String toDotedShortDateTime() => format('dd.MM.yy hh:mm');
  String toDashedShortDateTime() => format('dd-MM-yy hh:mm');

  String toLongDateTime() => format('dd MMM yyyy hh:mm:ss');
  String toDotedLongDateTime() => format('dd.MMM.yyyy hh:mm:ss');
  String toDashedLongDateTime() => format('dd-MMM-yyyy hh:mm:ss');

  bool isYesterday() =>
      DateTime.now().subtract(const Duration(days: 1)).day == day;
  bool isToday() => DateTime.now().day == day;
  bool isTomorrow() => DateTime.now().add(const Duration(days: 1)).day == day;

  DateTime toZone() => add(DateTime.now().toLocal().timeZoneOffset);
}
