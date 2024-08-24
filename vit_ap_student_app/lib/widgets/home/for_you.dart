import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vit_ap_student_app/utils/provider/providers.dart';

class ForYouTiles extends ConsumerStatefulWidget {
  const ForYouTiles({super.key});

  @override
  ForYouTilesState createState() => ForYouTilesState();
}

class ForYouTilesState extends ConsumerState<ForYouTiles> {
  Map<String, dynamic>? gradesMap;

  @override
  void initState() {
    super.initState();
    fetchGrades();
  }

  void fetchGrades() async {
    final prefs = await SharedPreferences.getInstance();
    final String? profileJson = prefs.getString('profile');

    if (profileJson != null) {
      gradesMap = jsonDecode(profileJson)['grade_history'];
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 125,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: Theme.of(context).colorScheme.secondary,
            ),
            width: 150,
            height: 100,
            margin: EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (index == 0)
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'GPA\nCalculator',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          height: 22,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            style: ButtonStyle(
                              padding: WidgetStatePropertyAll(
                                EdgeInsets.all(0),
                              ),
                            ),
                            iconAlignment: IconAlignment.end,
                            icon: Icon(
                              Icons.arrow_forward,
                              size: 20,
                              color: Colors.blue,
                            ),
                            onPressed: () {},
                            label: Text(
                              "Calculate",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else if (index == 1)
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Attendence\nCalculator',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          height: 22,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            style: ButtonStyle(
                              padding: WidgetStatePropertyAll(
                                EdgeInsets.all(0),
                              ),
                            ),
                            iconAlignment: IconAlignment.end,
                            icon: Icon(
                              Icons.arrow_forward,
                              size: 20,
                              color: Colors.blue,
                            ),
                            onPressed: () {},
                            label: Text(
                              "Calculate",
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else if (index == 2)
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Attendence\nCalculator',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          height: 22,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            style: ButtonStyle(
                              padding: WidgetStatePropertyAll(
                                EdgeInsets.all(0),
                              ),
                            ),
                            iconAlignment: IconAlignment.end,
                            icon: Icon(
                              Icons.arrow_forward,
                              size: 20,
                              color: Colors.blue,
                            ),
                            onPressed: () {},
                            label: Text(
                              "Calculate",
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
