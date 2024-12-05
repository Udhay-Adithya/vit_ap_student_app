import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:lottie/lottie.dart';
import 'package:vit_ap_student_app/utils/helper/text_newline.dart';
import '../../utils/provider/student/timetable_notifier.dart';

class MySchedule extends ConsumerWidget {
  final String day;

  const MySchedule({super.key, required this.day});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timetableState = ref.watch(timetableProvider);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: timetableState.when(
        data: (timetable) {
          log(timetable.toString());
          if (timetable.isEmpty || timetable[day] == null) {
            return _buildNoClassesContent(context);
          }

          final data = timetable[day] as List<dynamic>;
          log("Data var : $data");

          return ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final classItem = data[index] as Map<String, dynamic>;
              final classEntries = classItem.entries.toList();

              if (classEntries.isNotEmpty) {
                log("Class entries : $classEntries");
                final classTime = classEntries[0].key;
                final classInfo = classEntries[0].value;
                log("Class info : $classInfo");

                return _buildTimeLineTile(
                    context, classTime, classInfo, index, data.length);
              } else {
                // Handle cases where classItem is empty or invalid
                return ListTile(
                  title: const Text('Invalid class data'),
                  subtitle: Text(classItem.toString()),
                );
              }
            },
          );
        },
        loading: () {
          return _buildLoadingIndicator();
        },
        error: (error, stack) {
          return _buildErrorContent(context);
        },
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorContent(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(9),
      ),
      height: 150,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              "assets/images/lottie/data_not_found.json",
              frameRate: const FrameRate(60),
              width: 150,
            ),
            Text(
              'Error fetching timetable',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
            Text(
              'Please refresh the page to try again',
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoClassesContent(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(9),
      ),
      height: 150,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset("assets/images/lottie/cat_sleep.json",
                frameRate: const FrameRate(60), width: 150),
            Text(
              'No classes found',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
            Text(
              'Seems like a day off 😪',
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeLineTile(BuildContext context, String classTime,
      Map<String, dynamic> classInfo, int index, int totalClasses) {
    bool isFirst = index == 0;
    bool isLast = index == totalClasses - 1;
    String startTime = classTime.split('-')[0].trim();

    return TimelineTile(
      alignment: TimelineAlign.manual,
      lineXY: 0.05,
      isFirst: isFirst,
      isLast: isLast,
      indicatorStyle: IndicatorStyle(
        iconStyle: IconStyle(
          fontSize: 5.0,
          iconData: Icons.circle,
          color: Theme.of(context).colorScheme.secondary,
        ),
        indicatorXY: 0.13,
        width: 12,
        color: Theme.of(context).colorScheme.primary,
        padding: const EdgeInsets.symmetric(horizontal: 5),
      ),
      beforeLineStyle: LineStyle(
        color: Theme.of(context).colorScheme.tertiary,
        thickness: 1.5,
      ),
      endChild: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  startTime,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: MediaQuery.sizeOf(context).width - 112,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.zero,
                      bottomLeft: Radius.circular(10),
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                      bottom: 10,
                      top: 4,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          addNewlines(
                              classInfo['course_name'] ?? 'Unavailable', 30),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          classInfo['faculty'] ?? 'Unavailable',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${classInfo['course_code'] ?? 'Unavailable'} - ${classInfo['course_type'] ?? 'Unavailable'}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          classInfo['venue'] ?? 'Unavailable',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
