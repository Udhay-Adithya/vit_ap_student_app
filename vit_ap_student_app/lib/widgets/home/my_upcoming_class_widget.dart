import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../../utils/helper/text_newline.dart';
import '../../utils/provider/student/timetable_notifier.dart';

class MyUpcomingClassWidget extends ConsumerStatefulWidget {
  const MyUpcomingClassWidget({super.key});

  @override
  MyUpcomingClassWidgetState createState() => MyUpcomingClassWidgetState();
}

class MyUpcomingClassWidgetState extends ConsumerState<MyUpcomingClassWidget> {
  int currentPageIndex = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    // Watch the timetable state
    final timetableState = ref.watch(timetableProvider);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: timetableState.when(
          data: (timetable) {
            return _buildTimetableContent(timetable);
          },
          loading: () {
            return _buildLoadingIndicator();
          },
          error: (error, stack) {
            return _buildErrorContent(context);
          },
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const CircularProgressIndicator();
  }

  Widget _buildErrorContent(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              "assets/images/lottie/data_not_found.json",
              frameRate: const FrameRate(60),
              width: 150,
            ),
            Text(
              'Error fetching timetable',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
            Text(
              'Please refresh the page to try again',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimetableContent(Map<String, dynamic> timetable) {
    DateTime now = DateTime.now();
    String day = DateFormat('EEEE').format(now);

    // Check if there are classes for today
    if (timetable[day] == null) {
      return _buildNoClassesContent(context);
    }

    List<Map<String, dynamic>> upcomingClasses =
        _getUpcomingClasses(timetable, day);

    return Column(
      children: [
        CarouselSlider.builder(
          carouselController: _carouselController,
          itemCount: upcomingClasses.length,
          itemBuilder: (context, index, realIndex) {
            final classInfo = upcomingClasses[index];
            return _buildClassCard(classInfo, context);
          },
          options: CarouselOptions(
            scrollPhysics: const BouncingScrollPhysics(),
            autoPlayCurve: Curves.fastOutSlowIn,
            height: 175,
            enlargeCenterPage: false,
            enableInfiniteScroll: false,
            viewportFraction: 1.0,
            initialPage: 0,
            autoPlay: false,
            onPageChanged: (index, reason) {
              setState(() {
                currentPageIndex = index;
              });
            },
          ),
        ),
        const SizedBox(height: 10),
        _buildPageIndicator(upcomingClasses.length),
      ],
    );
  }

  Widget _buildNoClassesContent(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(9),
      ),
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Lottie.asset("assets/images/lottie/cat_sleep.json",
                frameRate: const FrameRate(60), width: 150),
            Text(
              'No classes found',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
            Text(
              'Seems like a day off 😪',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getUpcomingClasses(
      Map<String, dynamic> timetable, String day) {
    List<Map<String, dynamic>> upcomingClasses = [];
    final data = timetable[day] as List<dynamic>; // Cast to List<dynamic>

    for (var classItem in data) {
      final classMap = classItem as Map<String, dynamic>;
      classMap.forEach((time, classInfo) {
        final startTimeString = time.split('-')[0];
        final startTime = DateFormat('HH:mm').parse(startTimeString);

        upcomingClasses.add({
          'day': day,
          'CourseName': classInfo['course_name'],
          'CourseCode': classInfo['course_code'],
          'CourseType': classInfo['course_type'],
          'Venue': classInfo['venue'],
          'time': time,
          'startTime': startTime,
        });
      });
    }

    upcomingClasses.sort((a, b) => a['startTime'].compareTo(b['startTime']));
    return upcomingClasses;
  }

  Widget _buildPageIndicator(int itemCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        bool isSelected = currentPageIndex == index;
        return GestureDetector(
          onTap: () {
            _carouselController.animateToPage(index);
          },
          child: AnimatedContainer(
            width: isSelected ? 30 : 15,
            height: 10,
            margin: EdgeInsets.symmetric(horizontal: isSelected ? 6 : 3),
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.tertiary,
              borderRadius: BorderRadius.circular(9),
            ),
            duration: const Duration(milliseconds: 300),
          ),
        );
      }),
    );
  }

  Widget _buildClassCard(Map<String, dynamic> classInfo, BuildContext context) {
    DateTime now = DateTime.now();

    // Extract the time from classInfo and parse it
    String startTimeString = classInfo['time'].split('-')[0];
    DateTime startTime = DateFormat('HH:mm').parse(startTimeString);

    // Combine the current date with the parsed time
    DateTime startDateTime = DateTime(
        now.year, now.month, now.day, startTime.hour, startTime.minute);

    // Calculate end time by adding 50 minutes
    DateTime endDateTime = startDateTime.add(const Duration(minutes: 50));
    String status;
    Color statusColor;
    Color textColor;

    // Now you can compare `now`, `startDateTime`, and `endDateTime` correctly
    if (now.isBefore(startDateTime)) {
      status = 'Upcoming';
      statusColor = Colors.blueAccent.shade200.withOpacity(0.5);
      textColor = Colors.blue;
    } else if (now.isAfter(endDateTime)) {
      status = 'Completed';
      statusColor = Colors.greenAccent.shade200.withOpacity(0.3);
      textColor = Colors.green;
    } else {
      status = 'Ongoing';
      statusColor = Colors.orange.shade300.withOpacity(0.5);
      textColor = Colors.orange;
    }

    return Stack(
      children: [
        Container(
          width: MediaQuery.sizeOf(context).width,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(9)),
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 14,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          '${classInfo['time']}',
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Flexible(
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            decoration: BoxDecoration(
                                color: statusColor,
                                borderRadius: BorderRadius.circular(9)),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text(
                                  status,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: textColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  addNewlines(classInfo['CourseName'], 30),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  '${classInfo['CourseCode']} - ${classInfo['CourseType']}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  '${classInfo['Venue']}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        classInfo['CourseType'].contains('TH')
            ? Positioned(
                bottom: -26,
                right: -15,
                child: Lottie.asset(
                  'assets/images/lottie/books.json',
                  width: 165,
                  repeat: false,
                ),
              )
            : Positioned(
                bottom: -24,
                right: -25,
                child: Lottie.asset(
                  'assets/images/lottie/lab.json',
                  width: 175,
                  repeat: true,
                ),
              ),
      ],
    );
  }
}
