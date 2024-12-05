import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';
import '../provider/notification_utils_provider.dart';
import '../provider/student/timetable_notifier.dart';
import 'class_notification_service.dart';

Future<void> scheduleClassNotifications() async {
  final container = ProviderContainer();
  container.read(timetableProvider).when(
    data: (timetable) async {
      if (timetable.isEmpty) {
        log("Timetable is empty. Cannot schedule notifications.");
        return;
      }
      final bool notificationsEnabled =
          container.read(classNotificationProvider);
      final double sliderValue =
          container.read(classNotificationSliderProvider);
      final notificationService = NotificationService();

      // Initialize shared preferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      int lastClassNotificationId =
          prefs.getInt('lastClassNotificationId') ?? 0;

      // Exit if notifications are disabled
      if (!notificationsEnabled) {
        log("Notifications are disabled");
        notificationService.cancelAllNotifications();
        return;
      }

      // Cancel existing notifications if necessary
      notificationService.cancelAllNotifications();
      notificationService.initNotifications();
      log("Notifications are Enabled");

      final now = DateTime.now();
      final kolkata = tz.getLocation('Asia/Kolkata');
      int notificationId = lastClassNotificationId;

      // Helper function to get day name
      String getDayName(int weekday) {
        switch (weekday) {
          case DateTime.monday:
            return 'Monday';
          case DateTime.tuesday:
            return 'Tuesday';
          case DateTime.wednesday:
            return 'Wednesday';
          case DateTime.thursday:
            return 'Thursday';
          case DateTime.friday:
            return 'Friday';
          case DateTime.saturday:
            return 'Saturday';
          case DateTime.sunday:
            return 'Sunday';
          default:
            return 'Monday';
        }
      }

      // Schedule notifications for the next 7 days
      for (int dayOffset = 0; dayOffset < 7; dayOffset++) {
        final DateTime targetDate = now.add(Duration(days: dayOffset));
        final String targetDay = getDayName(targetDate.weekday);

        // Skip if no classes on this day
        if (!timetable.containsKey(targetDay)) {
          log("No classes found for $targetDay");
          continue;
        }

        final classes = timetable[targetDay];

        for (var classData in classes) {
          final timeRange = classData.keys.first;
          final classDetails = classData[timeRange];

          final startTime = timeRange.split('-').first.trim();
          final hoursMinutes = startTime.split(':');
          final hour = int.parse(hoursMinutes[0]);
          final minute = int.parse(hoursMinutes[1]);

          // Create notification time for the target date
          final classDateTime = tz.TZDateTime(
            kolkata,
            targetDate.year,
            targetDate.month,
            targetDate.day,
            hour,
            minute,
          );

          // Skip if class time has already passed
          if (now.isAfter(classDateTime)) {
            continue;
          }

          final notificationDuration = Duration(minutes: sliderValue.toInt());
          final notificationTime = classDateTime.subtract(notificationDuration);

          // Schedule the notification
          notificationService.scheduleNotification(
            id: notificationId++,
            title: "📅 Class Starting Soon",
            body:
                "Your ${classDetails['course_name']} class is about to begin in ${sliderValue.toInt()} minutes at ${classDetails['venue']}. Don't miss out!",
            scheduledTime: notificationTime,
          );

          log("$notificationId Scheduled: ${classDetails['course_name']} at $notificationTime (for $targetDay)");
        }
      }

      // Save the last notification ID
      prefs.setInt('lastClassNotificationId', notificationId);
    },
    error: (error, stackTrace) {
      log("Error loading timetable for notifications: $error",
          error: error, stackTrace: stackTrace);
    },
    loading: () {
      log("Timetable is still loading - cannot schedule notifications");
    },
  );
}

// Refresh method remains the same
Future<void> refreshWeeklyNotifications() async {
  await scheduleClassNotifications();
  log("Weekly notifications refreshed");
}
