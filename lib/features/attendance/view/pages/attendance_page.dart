import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:vit_ap_student_app/core/providers/current_user.dart';
import 'package:vit_ap_student_app/features/attendance/view/widgets/attendance_bottom_sheet.dart';

class AttendancePage extends ConsumerStatefulWidget {
  const AttendancePage({super.key});

  @override
  AttendancePageState createState() => AttendancePageState();
}

class AttendancePageState extends ConsumerState<AttendancePage> {
  DateTime? lastSynced;

  @override
  void initState() {
    super.initState();
    loadLastSynced();
  }

  Future<void> loadLastSynced() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastSyncedString = prefs.getString('lastSynced');
    if (lastSyncedString != null) {
      setState(() {
        lastSynced = DateTime.parse(lastSyncedString);
      });
    }
  }

  Future<void> saveLastSynced() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastSynced', lastSynced!.toIso8601String());
  }

  Future<void> refreshAttendanceData() async {
    log("Going to fetch new attendance");
    // Implement your refresh logic using currentUserNotifierProvider
    lastSynced = DateTime.now();
    saveLastSynced();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserNotifierProvider);
    final attendances = user?.attendance.toList() ?? [];

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: true,
            expandedHeight: 75,
            backgroundColor: Theme.of(context).colorScheme.surface,
            actions: [
              PopupMenuButton(
                icon: Icon(
                  Icons.more_vert_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 0,
                    child: Text(
                      "Refresh",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
                onSelected: (value) {
                  if (value == 0) {
                    refreshAttendanceData();
                  }
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Align(
                alignment: Alignment.bottomLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Attendance",
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontSize: 20,
                              ),
                    ),
                    const SizedBox(height: 5),
                    if (lastSynced != null)
                      Text(
                        "Last Synced: ${DateFormat('d MMM, hh:mm a').format(lastSynced!)} 💾 (${timeago.format(lastSynced!)})",
                        style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHigh,
                          fontSize: 8,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          if (attendances.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      "assets/images/lottie/empty.json",
                      frameRate: const FrameRate(60),
                      width: 380,
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        'Feels so empty',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                    ),
                    Text(
                      'No attendance found.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    )
                  ],
                ),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final attendance = attendances[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4),
                    child: Row(
                      children: [
                        Flexible(
                          child: ListTile(
                            tileColor: Theme.of(context)
                                .colorScheme
                                .surfaceContainerLow,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${attendance.attendancePercentage}%",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontSize: 36,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                attendance.courseType.contains("Theory")
                                    ? Image.asset(
                                        "assets/images/icons/theory.png",
                                        height: 24,
                                      )
                                    : Padding(
                                        padding:
                                            const EdgeInsets.only(top: 4.0),
                                        child: Image.asset(
                                          "assets/images/icons/lab.png",
                                          height: 24,
                                        ),
                                      ),
                                const SizedBox(height: 24),
                                Text(
                                  attendance.courseName,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  attendance.courseCode,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            onTap: () =>
                                showAttendanceBottomSheet(context, attendance),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                childCount: attendances.length,
              ),
            ),
        ],
      ),
    );
  }
}
