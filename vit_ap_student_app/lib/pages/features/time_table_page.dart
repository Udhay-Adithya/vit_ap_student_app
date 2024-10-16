import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import '../../utils/provider/student_provider.dart';
import '../../widgets/timetable/my_tab_bar.dart';
import 'bottom_navigation_bar.dart';

class TimeTablePage extends ConsumerWidget {
  const TimeTablePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> refreshTimetableData() async {
      log("Going to fetch new timetable");
      await ref.read(studentProvider.notifier).fetchAndUpdateTimetable();
    }

    // Watch the timetableProvider
    final timetable = ref.watch(studentProvider.notifier).timetableState.value!;
    DateTime now = DateTime.now();
    String day = DateFormat('EEEE').format(now);
    final int noOfClasses = timetable[day]?.length ?? 0;

    log(MediaQuery.sizeOf(context).height.toString());

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 90,
            backgroundColor: Theme.of(context).colorScheme.secondary,
            leading: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    type: PageTransitionType.fade,
                    child: const MyBNB(
                      initialIndex: 0,
                    ),
                  ),
                );
              },
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Theme.of(context).colorScheme.primary,
              ),
              iconSize: 20,
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
                    refreshTimetableData();
                    //fetchTimetable();
                  }
                },
              )
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Align(
                alignment: Alignment.bottomLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "My Timetable",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "You have $noOfClasses classes Today",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 8,
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              // height: MediaQuery.of(context).size.height - 650,
              child: const DaysTabBar(),
            ),
          ),
        ],
      ),
    );
  }
}
