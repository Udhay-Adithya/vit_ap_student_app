import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

import '../../utils/provider/student/attendance_notifier.dart';

class MyAttendancePage extends ConsumerStatefulWidget {
  const MyAttendancePage({super.key});

  @override
  _MyAttendancePageState createState() => _MyAttendancePageState();
}

class _MyAttendancePageState extends ConsumerState<MyAttendancePage> {
  late Future<Map<String, dynamic>> attendanceData;
  DateTime? lastSynced;

  @override
  void initState() {
    super.initState();
    loadLastSynced();
  }

  Future<void> loadLastSynced() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastSyncedString = prefs.getString('lastSynced');
    if (lastSyncedString == null) {}
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
    ref.read(attendanceProvider.notifier).fetchAttendance();
    lastSynced = DateTime.now();

    saveLastSynced();
  }

  void _showSubjectInfoModal(
      BuildContext context, Map<String, dynamic> subjectInfo) {
    final String attendanceStr = subjectInfo['attendance_percentage'];
    final double attendancePercentage = double.tryParse(attendanceStr) ?? 0.0;
    final double waveHeight = ((attendancePercentage) / 100) == 1
        ? 1
        : ((attendancePercentage) / 100);

    showModalBottomSheet<dynamic>(
      showDragHandle: true,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Text(
                      "Summary",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(9),
                                child: WaveWidget(
                                  backgroundColor: Colors.blue.shade800,
                                  waveAmplitude: 0,
                                  config: CustomConfig(
                                    gradients: [
                                      [
                                        Colors.blue.shade600,
                                        Colors.blue.shade500,
                                      ],
                                      [
                                        Colors.blue.shade400,
                                        Colors.blue.shade300,
                                      ],
                                      [
                                        Colors.blue.shade200,
                                        Colors.cyan.shade100,
                                      ],
                                    ],
                                    gradientBegin: Alignment.bottomLeft,
                                    gradientEnd: Alignment.topRight,
                                    durations: [8000, 10000, 12000],
                                    heightPercentages: [
                                      1 - waveHeight,
                                      1 - waveHeight + 0.02,
                                      1 - waveHeight + 0.05,
                                    ],
                                    blur: MaskFilter.blur(
                                      BlurStyle.solid,
                                      0,
                                    ),
                                  ),
                                  size: const Size(125, 300),
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Column(
                                children: [
                                  Container(
                                    height: 95,
                                    width:
                                        MediaQuery.sizeOf(context).width - 181,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          Colors.blue.shade500,
                                          Colors.blue.shade900,
                                        ],
                                      ),
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      borderRadius: BorderRadius.circular(9),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Text(
                                            '$attendanceStr%',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 32,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Text(
                                            'Overall Attendence',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Container(
                                    height: 94,
                                    width:
                                        MediaQuery.sizeOf(context).width - 181,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          Colors.blue.shade500,
                                          Colors.blue.shade900,
                                        ],
                                      ),
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      borderRadius: BorderRadius.circular(9),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Text(
                                            '${subjectInfo['attended_classes']}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 32,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Text(
                                            'Attended Classes',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Container(
                                    height: 94,
                                    width:
                                        MediaQuery.sizeOf(context).width - 181,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          Colors.blue.shade500,
                                          Colors.blue.shade900,
                                        ],
                                      ),
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      borderRadius: BorderRadius.circular(9),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Text(
                                            '${subjectInfo['total_classes']}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 32,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Text(
                                            'Total classes',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Course Name',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          SizedBox(
                            height: 4,
                            width: MediaQuery.sizeOf(context).width,
                          ),
                          Text(
                            "${subjectInfo['course_name']}",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.tertiary,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                            width: MediaQuery.sizeOf(context).width,
                          ),
                          Text(
                            'Course Code',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            height: 4,
                            width: MediaQuery.sizeOf(context).width,
                          ),
                          Text(
                            "${subjectInfo['course_code']}",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.tertiary,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                            width: MediaQuery.sizeOf(context).width,
                          ),
                          Text(
                            'Course Type',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            height: 4,
                            width: MediaQuery.sizeOf(context).width,
                          ),
                          Text(
                            "${subjectInfo['course_type']}",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.tertiary,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final attendanceState = ref.watch(attendanceProvider);

    // Log the current state to debug
    log('Current attendance state: $attendanceState');

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
                      "My Attendance",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 5),
                    if (lastSynced != null)
                      Text(
                        "Last Synced: ${DateFormat('d MMM, hh:mm a').format(lastSynced!)} 💾 (${timeago.format(lastSynced!)})",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontSize: 8,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          // Loading condition check

          attendanceState.when(
            loading: () => SliverFillRemaining(
              child: Center(
                  child: Column(
                children: [
                  Text(attendanceState.value.toString()),
                  CircularProgressIndicator(),
                ],
              )),
            ),
            error: (error, _) {
              log(error.toString());
              return SliverFillRemaining(
                child: Center(
                  child: SelectableText('Error: ${error.toString()}'),
                ),
              );
            },
            data: (data) {
              if (data.isEmpty) {
                return SliverFillRemaining(
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Lottie.asset(
                            'assets/images/lottie/404_astronaut.json',
                            frameRate: const FrameRate(60),
                            width: 250,
                          ),
                        ),
                        const Text(
                          'Oops!',
                          style: TextStyle(fontSize: 32),
                        ),
                        const Text(
                          'Page not found',
                          style: TextStyle(fontSize: 32),
                        ),
                        const Text(
                          'The page you are looking for does not exist or some other error occurred',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                );
              }
              final keys = data.keys.toList();

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final key = keys[index];
                    final attendance = data[key];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            Flexible(
                              child: ListTile(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${attendance['attendance_percentage']}%',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontSize: 36,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Chip(
                                      avatarBoxConstraints:
                                          const BoxConstraints(
                                        minWidth: 10,
                                        maxHeight: 24,
                                      ),
                                      padding: const EdgeInsets.all(4),
                                      labelPadding: EdgeInsets.all(0),
                                      avatar: (attendance['course_type'])
                                              .contains("Theory")
                                          ? const Icon(Icons.book_outlined)
                                          : const Icon(Icons.science_outlined),
                                      label: Text(
                                        (attendance['course_type'])
                                                .contains("Theory")
                                            ? 'ETH'
                                            : 'LAB',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      attendance['course_name'],
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () =>
                                    _showSubjectInfoModal(context, attendance),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: keys.length,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
