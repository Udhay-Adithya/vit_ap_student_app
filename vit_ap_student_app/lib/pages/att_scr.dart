import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/provider/student/attendance_notifier.dart';

class AttendanceScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attendanceState = ref.watch(attendanceProvider);
    final attendanceNotifier = ref.read(attendanceProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Trigger data refresh
              attendanceNotifier.fetchAttendance();
            },
          ),
        ],
      ),
      body: attendanceState.when(
        data: (attendance) => ListView.builder(
          itemCount: attendance.length,
          itemBuilder: (context, index) {
            final entry = attendance.entries.toList()[index];
            return ListTile(
              title: Text('Subject: ${entry.key}'),
              subtitle: Text('Attendance: ${entry.value}%'),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text('Error: $err'),
        ),
      ),
    );
  }
}
