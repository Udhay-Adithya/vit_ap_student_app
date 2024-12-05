import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';

import '../provider/student/timetable_notifier.dart';

class UpcomingClassWidget extends ConsumerStatefulWidget {
  const UpcomingClassWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<UpcomingClassWidget> createState() =>
      _UpcomingClassWidgetState();
}

class _UpcomingClassWidgetState extends ConsumerState<UpcomingClassWidget> {
  void updateWidget(AsyncValue<Map<String, dynamic>> timetableState) async {
    try {
      final now = DateTime.now();
      final day = _getDayString(now.weekday);

      if (timetableState.hasValue) {
        final todayClasses = timetableState.value![day] as List?;

        // Store today's classes directly in HomeWidget
        await HomeWidget.saveWidgetData<String>(
            'today_classes', json.encode(todayClasses));

        final nextClassData = _getNextClassWithTiming(todayClasses, now);

        if (nextClassData != null) {
          final nextClass = nextClassData['classInfo'];
          final timing = nextClassData['timing'];

          // Save next class details in HomeWidget
          await Future.wait([
            HomeWidget.saveWidgetData<String>(
                'next_class', nextClass['course_name']),
            HomeWidget.saveWidgetData<String>(
                'faculty_name', nextClass['faculty']),
            HomeWidget.saveWidgetData<String>('venue', nextClass['venue']),
            HomeWidget.saveWidgetData<String>('class_timing', timing)
          ]);
        } else {
          // Handle no upcoming class case
          await HomeWidget.saveWidgetData<String>(
              'next_class', 'No upcoming class');
        }

        // Update widget
        await HomeWidget.updateWidget(
          name: 'UpcomingClassWidget',
          iOSName: 'UpcomingClassWidget',
          androidName: 'UpcomingClassWidget',
        );
      }
    } catch (e, stackTrace) {
      log('Error updating widget: $e');
      log('Stack trace: $stackTrace');
    }
  }

  String _getDayString(int weekday) {
    return [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday"
    ][weekday - 1];
  }

  Map<String, dynamic>? _getNextClassWithTiming(
      List? todayClasses, DateTime now) {
    if (todayClasses == null || todayClasses.isEmpty) {
      return null;
    }

    for (final classItem in todayClasses) {
      final timeRange = classItem.keys.first;
      if (isClassUpcoming(timeRange, now)) {
        return {
          'classInfo': classItem[timeRange],
          'timing': timeRange,
        };
      }
    }

    return null;
  }

  bool isClassUpcoming(String timeRange, DateTime now) {
    final timeFormatter = DateFormat('HH:mm');
    final timeParts = timeRange.split(' - ');
    final startTime = timeFormatter.parse(timeParts[0]);

    final nowTime = TimeOfDay.fromDateTime(now);
    final startTimeOfDay = TimeOfDay.fromDateTime(startTime);

    if (nowTime.hour < startTimeOfDay.hour ||
        (nowTime.hour == startTimeOfDay.hour &&
            nowTime.minute < startTimeOfDay.minute)) {
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final timetableState = ref.watch(timetableProvider);
    return Container(
      child: ElevatedButton(
        onPressed: () => updateWidget(timetableState),
        child: Text('Update Widget'),
      ),
    );
  }
}
