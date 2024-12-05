import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:vit_ap_student_app/widgets/home/my_upcoming_class_widget.dart';
import 'package:vit_ap_student_app/widgets/home/my_weather_widget.dart';
import 'package:vit_ap_student_app/widgets/home/quick_access.dart';
import '../../widgets/custom/help_widget.dart';
import '../../widgets/home/for_you.dart';
import '../../widgets/home/greeting.dart';
import '../../widgets/home/my_grades_widget.dart';
import '../../widgets/home/my_home_appbar.dart';
import '../../utils/services/app_updates.dart';

class HomePage extends ConsumerStatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  initState() {
    super.initState();
    checkForUpdate(context, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          // AppBar
          MyHomeSliverAppBar(),

          // Hola Greeting
          MyHomeSliverGreeting(),

          // Grades
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyGradesTile(),
                  // ElevatedButton(
                  //   onPressed: () async {
                  //     // Request notification permission
                  //     PermissionStatus status =
                  //         await Permission.notification.request();
                  //     Permission.notification.request();

                  //     if (status.isGranted) {
                  //       // If permission is granted, show the notification
                  //       NotificationService().showNotification(
                  //         title: "📍 Notification Check",
                  //         body:
                  //             "Some beautiful notification but its way tooo long for a single line",
                  //         payload: "Payload",
                  //       );
                  //     } else if (status.isDenied) {
                  //       status = await Permission.notification.request();

                  //       if (status.isGranted) {
                  //         // If permission is granted on the second request
                  //         NotificationService().showNotification(
                  //           title: "Check",
                  //           body: "Some beautiful notification",
                  //           payload: "Payload",
                  //         );
                  //       } else {
                  //         print("Notification permission denied again.");
                  //       }
                  //     } else if (status.isPermanentlyDenied) {
                  //       // Handle the case when the permission is permanently denied
                  //       // Optionally guide the user to the app settings
                  //       openAppSettings();
                  //     }

                  //     // Additional check for location permission if needed
                  //     if (await Permission.location.isRestricted) {
                  //       print("Location permission is restricted");
                  //     }
                  //   },
                  //   child: Text("Check Notification"),
                  // ),
                ],
              ),
            ),
          ),

          // SliverToBoxAdapter(
          //   child: ElevatedButton(
          //       onPressed: () async {
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //             builder: (builder) => UpcomingClassWidget(),
          //           ),
          //         );
          //       },
          //       child: Text("data")),
          // ),

          // Today's Schedule
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: Column(
                children: [
                  Row(
                    children: [
                      Lottie.asset(
                        "assets/images/lottie/schedule.json",
                        frameRate: FrameRate(60),
                        width: 36,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Today\'s Schedule',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  MyUpcomingClassWidget(),
                ],
              ),
            ),
          ),

          // Weather
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: Column(
                children: [
                  Row(
                    children: [
                      Lottie.asset(
                        "assets/weather_icons/umbrella.json",
                        frameRate: FrameRate(60),
                        width: 48,
                      ),
                      const Text(
                        'Weather',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  // Weather Widget
                  MyWeatherWidget(),
                ],
              ),
            ),
          ),

          // Quick Access
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Positioned(
                        top: -5,
                        left: -16,
                        child: Lottie.asset(
                          "assets/images/lottie/cards.json",
                          frameRate: FrameRate(60),
                          width: 80,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 45.0),
                        child: Text(
                          'Quick access',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  MyQuickAccess(),
                ],
              ),
            ),
          ),

          // For You
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: Column(
                children: [
                  Row(
                    children: [
                      Lottie.asset(
                        "assets/images/lottie/schedule.json",
                        frameRate: FrameRate(60),
                        width: 36,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'For You',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  ForYouTiles(),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: HelpTile(),
          )
        ],
      ),
    );
  }
}
