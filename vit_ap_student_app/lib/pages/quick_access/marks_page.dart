import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/provider/student/marks_notifier.dart';

class MarksPage extends ConsumerStatefulWidget {
  const MarksPage({super.key});

  @override
  ConsumerState<MarksPage> createState() => _MarksPageState();
}

class _MarksPageState extends ConsumerState<MarksPage> {
  DateTime? lastSynced;

  @override
  void initState() {
    super.initState();
    loadLastSynced();
  }

  Future<void> loadLastSynced() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastSyncedString = prefs.getString('marksLastSynced');
    if (lastSyncedString != null) {
      setState(() {
        lastSynced = DateTime.parse(lastSyncedString);
      });
    }
  }

  Future<void> saveLastSynced() async {
    if (lastSynced != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('marksLastSynced', lastSynced!.toIso8601String());
    }
  }

  Future<void> refreshMarksData() async {
    await ref.watch(marksProvider.notifier).fetchMarks();
    setState(() {
      lastSynced = DateTime.now();
    });
    saveLastSynced();
  }

  void showDetailsBottomSheet(Map<String, dynamic> course) {
    double totalWeightage = 0;
    double lostWeightage = 0;

    for (var detail in course['details']) {
      // Convert weightage_mark to double if it's a string
      totalWeightage += (detail['weightage_mark'] is String)
          ? double.parse(detail['weightage_mark'])
          : detail['weightage_mark'];

      if (detail['max_mark'] != null && detail['scored_mark'] != null) {
        final maxMark = (detail['max_mark'] is String)
            ? double.parse(detail['max_mark'])
            : detail['max_mark'];
        final scoredMark = (detail['scored_mark'] is String)
            ? double.parse(detail['scored_mark'])
            : detail['scored_mark'];
        final weightage = (detail['weightage'] is String)
            ? double.parse(detail['weightage'])
            : detail['weightage'];

        final lostMark = maxMark - scoredMark;
        lostWeightage += (lostMark * weightage / maxMark);
      }
    }

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                children: [
                  Text(
                    course['course_title'],
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  course["course_type"].toString().contains("Theory")
                      ? Image.asset(
                          "assets/images/icons/theory.png",
                          height: 24,
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Image.asset(
                            "assets/images/icons/lab.png",
                            height: 24,
                          ),
                        )
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
              ),
              const SizedBox(height: 8),
              Text(
                'Faculty',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Text(
                "${course['faculty']}",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Course Code',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Text(
                "${course['course_code']}",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    height: 100,
                    width: MediaQuery.sizeOf(context).width - 231,
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.greenAccent.shade200,
                          Colors.greenAccent.shade400,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            '${totalWeightage.toStringAsFixed(1)}',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 32,
                              color: Theme.of(context).colorScheme.surface,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 8.0,
                            bottom: 4,
                          ),
                          child: Text(
                            'Total\nWeightage',
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.surface,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 100,
                    width: MediaQuery.sizeOf(context).width - 231,
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.redAccent.shade100,
                          Colors.redAccent.shade200,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            '${lostWeightage.toStringAsFixed(1)}',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 32,
                              color: Theme.of(context).colorScheme.surface,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 8.0,
                            bottom: 8,
                          ),
                          child: Text(
                            'Lost\nWeightage',
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.surface,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              const Text(
                'Details:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: course['details'].length,
                itemBuilder: (context, index) {
                  final detail = course['details'][index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        detail["mark_title"],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      Text(
                        "${detail['scored_mark']} / ${detail['max_mark']}",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 2),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final marksState = ref.watch(marksProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Marks",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
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
                refreshMarksData();
              }
            },
          ),
        ],
      ),
      body: marksState.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, _) => Text('Error: $error'),
        data: (data) {
          if (data.isEmpty) {
            return Padding(
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
            );
          }
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final course = data[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9)),
                  tileColor: Theme.of(context).colorScheme.secondary,
                  title: Text(
                    course['course_title'],
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    '${course['course_code']}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    showDetailsBottomSheet(course);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
