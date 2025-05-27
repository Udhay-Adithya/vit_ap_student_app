// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:objectbox/objectbox.dart';

@Entity()
class UserPreferences {
  @Id()
  int? id;

  bool isTimetableNotificationsEnabled;
  bool isExamScheduleNotificationEnabled;
  int timetableNotificationDelay;
  int examScheduleNotificationDelay;
  bool isPrivacyEnabled;
  bool isDarkModeEnabled;

  @Property(type: PropertyType.date)
  DateTime? lastSync;

  @Property(type: PropertyType.date)
  DateTime? attendanceLastSync;

  @Property(type: PropertyType.date)
  DateTime? marksLastSync;

  @Property(type: PropertyType.date)
  DateTime? examScheduleLastSync;
  bool isFirstLaunch;

  UserPreferences({
    this.id,
    this.isTimetableNotificationsEnabled = true,
    this.isExamScheduleNotificationEnabled = true,
    this.timetableNotificationDelay = 10,
    this.examScheduleNotificationDelay = 60,
    this.isPrivacyEnabled = true,
    this.isDarkModeEnabled = false,
    this.lastSync,
    this.attendanceLastSync,
    this.marksLastSync,
    this.examScheduleLastSync,
    this.isFirstLaunch = true,
  });

  UserPreferences copyWith({
    int? id,
    bool? isTimetableNotificationsEnabled,
    bool? isExamScheduleNotificationEnabled,
    int? timetableNotificationDelay,
    int? examScheduleNotificationDelay,
    bool? isPrivacyEnabled,
    bool? isDarkModeEnabled,
    DateTime? lastSync,
    DateTime? attendanceLastSync,
    DateTime? marksLastSync,
    DateTime? examScheduleLastSync,
    bool? isFirstLaunch,
  }) {
    return UserPreferences(
      id: id ?? this.id,
      isTimetableNotificationsEnabled: isTimetableNotificationsEnabled ??
          this.isTimetableNotificationsEnabled,
      isExamScheduleNotificationEnabled: isExamScheduleNotificationEnabled ??
          this.isExamScheduleNotificationEnabled,
      timetableNotificationDelay:
          timetableNotificationDelay ?? this.timetableNotificationDelay,
      examScheduleNotificationDelay:
          examScheduleNotificationDelay ?? this.examScheduleNotificationDelay,
      isPrivacyEnabled: isPrivacyEnabled ?? this.isPrivacyEnabled,
      isDarkModeEnabled: isDarkModeEnabled ?? this.isDarkModeEnabled,
      lastSync: lastSync ?? this.lastSync,
      attendanceLastSync: attendanceLastSync ?? this.attendanceLastSync,
      marksLastSync: marksLastSync ?? this.marksLastSync,
      examScheduleLastSync: examScheduleLastSync ?? this.examScheduleLastSync,
      isFirstLaunch: isFirstLaunch ?? this.isFirstLaunch,
    );
  }
}
