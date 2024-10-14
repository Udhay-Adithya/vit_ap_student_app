// import 'package:flutter/material.dart';
// import 'package:wave/config.dart';
// import 'package:wave/wave.dart';

// class AttendanceBottomSheet extends StatefulWidget {
//   const AttendanceBottomSheet({super.key});

//   @override
//   State<AttendanceBottomSheet> createState() => _AttendanceBottomSheetState();
// }

// class _AttendanceBottomSheetState extends State<AttendanceBottomSheet> {
//   final double waveHeight = ((attendancePercentage) / 100) == 1
//         ? 1
//         : ((attendancePercentage) / 100);
//   final double attendancePercentage = double.tryParse(attendanceStr) ?? 0.0;
//   final String attendanceStr = subjectInfo['attendance_percentage'];
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//           decoration: BoxDecoration(
//             color: Theme.of(context).colorScheme.surface,
//           ),
//           child: SizedBox(
//             width: MediaQuery.of(context).size.width,
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: const Text(
//                       "Summary",
//                       style: TextStyle(
//                         fontSize: 28,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                   Container(
//                     decoration: BoxDecoration(
//                       color: Theme.of(context).colorScheme.secondary,
//                       borderRadius: BorderRadius.circular(9),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         mainAxisSize: MainAxisSize.min,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               ClipRRect(
//                                 borderRadius: BorderRadius.circular(9),
//                                 child: WaveWidget(
//                                   backgroundColor: Colors.blue.shade800,
//                                   waveAmplitude: 0,
//                                   config: CustomConfig(
//                                     gradients: [
//                                       [
//                                         Colors.blue.shade600,
//                                         Colors.blue.shade500,
//                                       ],
//                                       [
//                                         Colors.blue.shade400,
//                                         Colors.blue.shade300,
//                                       ],
//                                       [
//                                         Colors.blue.shade200,
//                                         Colors.cyan.shade100,
//                                       ],
//                                     ],
//                                     gradientBegin: Alignment.bottomLeft,
//                                     gradientEnd: Alignment.topRight,
//                                     durations: [8000, 10000, 12000],
//                                     heightPercentages: [
//                                       1 - waveHeight,
//                                       1 - waveHeight + 0.02,
//                                       1 - waveHeight + 0.05,
//                                     ],
//                                     blur: MaskFilter.blur(
//                                       BlurStyle.solid,
//                                       0,
//                                     ),
//                                   ),
//                                   size: const Size(125, 300),
//                                 ),
//                               ),
//                               SizedBox(
//                                 width: 8,
//                               ),
//                               Column(
//                                 children: [
//                                   Container(
//                                     height: 95,
//                                     width:
//                                         MediaQuery.sizeOf(context).width - 181,
//                                     decoration: BoxDecoration(
//                                       gradient: LinearGradient(
//                                         begin: Alignment.topLeft,
//                                         end: Alignment.centerRight,
//                                         colors: [
//                                           Colors.blue.shade500,
//                                           Colors.blue.shade900,
//                                         ],
//                                       ),
//                                       color:
//                                           Theme.of(context).colorScheme.primary,
//                                       borderRadius: BorderRadius.circular(9),
//                                     ),
//                                     child: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Padding(
//                                           padding: const EdgeInsets.symmetric(
//                                               horizontal: 8.0),
//                                           child: Text(
//                                             '$attendanceStr%',
//                                             style: TextStyle(
//                                               fontWeight: FontWeight.w800,
//                                               fontSize: 32,
//                                               color: Colors.white,
//                                             ),
//                                           ),
//                                         ),
//                                         Padding(
//                                           padding: const EdgeInsets.symmetric(
//                                               horizontal: 8.0),
//                                           child: Text(
//                                             'Overall Attendence',
//                                             style: TextStyle(
//                                               fontSize: 16,
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.w500,
//                                             ),
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     height: 8,
//                                   ),
//                                   Container(
//                                     height: 94,
//                                     width:
//                                         MediaQuery.sizeOf(context).width - 181,
//                                     decoration: BoxDecoration(
//                                       gradient: LinearGradient(
//                                         begin: Alignment.topLeft,
//                                         end: Alignment.centerRight,
//                                         colors: [
//                                           Colors.blue.shade500,
//                                           Colors.blue.shade900,
//                                         ],
//                                       ),
//                                       color:
//                                           Theme.of(context).colorScheme.primary,
//                                       borderRadius: BorderRadius.circular(9),
//                                     ),
//                                     child: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Padding(
//                                           padding: const EdgeInsets.symmetric(
//                                               horizontal: 8.0),
//                                           child: Text(
//                                             '${subjectInfo['attended_classes']}',
//                                             style: TextStyle(
//                                               fontWeight: FontWeight.w800,
//                                               fontSize: 32,
//                                               color: Colors.white,
//                                             ),
//                                           ),
//                                         ),
//                                         Padding(
//                                           padding: const EdgeInsets.symmetric(
//                                               horizontal: 8.0),
//                                           child: Text(
//                                             'Attended Classes',
//                                             style: TextStyle(
//                                               fontSize: 16,
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.w500,
//                                             ),
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     height: 8,
//                                   ),
//                                   Container(
//                                     height: 94,
//                                     width:
//                                         MediaQuery.sizeOf(context).width - 181,
//                                     decoration: BoxDecoration(
//                                       gradient: LinearGradient(
//                                         begin: Alignment.topLeft,
//                                         end: Alignment.centerRight,
//                                         colors: [
//                                           Colors.blue.shade500,
//                                           Colors.blue.shade900,
//                                         ],
//                                       ),
//                                       color:
//                                           Theme.of(context).colorScheme.primary,
//                                       borderRadius: BorderRadius.circular(9),
//                                     ),
//                                     child: Column(
//                                       mainAxisSize: MainAxisSize.min,
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Padding(
//                                           padding: const EdgeInsets.symmetric(
//                                               horizontal: 8.0),
//                                           child: Text(
//                                             '${subjectInfo['total_classes']}',
//                                             style: TextStyle(
//                                               fontWeight: FontWeight.w800,
//                                               fontSize: 32,
//                                               color: Colors.white,
//                                             ),
//                                           ),
//                                         ),
//                                         Padding(
//                                           padding: const EdgeInsets.symmetric(
//                                               horizontal: 8.0),
//                                           child: Text(
//                                             'Total classes',
//                                             style: TextStyle(
//                                               fontSize: 16,
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.w500,
//                                             ),
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 12,
//                   ),
//                   Container(
//                     decoration: BoxDecoration(
//                       color: Theme.of(context).colorScheme.secondary,
//                       borderRadius: BorderRadius.circular(9),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Course Name',
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.w600,
//                               color: Theme.of(context).colorScheme.primary,
//                             ),
//                           ),
//                           SizedBox(
//                             height: 4,
//                             width: MediaQuery.sizeOf(context).width,
//                           ),
//                           Text(
//                             "${subjectInfo['course_name']}",
//                             style: TextStyle(
//                               color: Theme.of(context).colorScheme.tertiary,
//                               fontSize: 14,
//                               fontWeight: FontWeight.w400,
//                             ),
//                           ),
//                           SizedBox(
//                             height: 8,
//                             width: MediaQuery.sizeOf(context).width,
//                           ),
//                           Text(
//                             'Course Code',
//                             style: TextStyle(
//                               color: Theme.of(context).colorScheme.primary,
//                               fontSize: 18,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           SizedBox(
//                             height: 4,
//                             width: MediaQuery.sizeOf(context).width,
//                           ),
//                           Text(
//                             "${subjectInfo['course_code']}",
//                             style: TextStyle(
//                               color: Theme.of(context).colorScheme.tertiary,
//                               fontSize: 14,
//                               fontWeight: FontWeight.w400,
//                             ),
//                           ),
//                           SizedBox(
//                             height: 8,
//                             width: MediaQuery.sizeOf(context).width,
//                           ),
//                           Text(
//                             'Course Type',
//                             style: TextStyle(
//                               color: Theme.of(context).colorScheme.primary,
//                               fontSize: 18,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           SizedBox(
//                             height: 4,
//                             width: MediaQuery.sizeOf(context).width,
//                           ),
//                           Text(
//                             "${subjectInfo['course_type']}",
//                             style: TextStyle(
//                               color: Theme.of(context).colorScheme.tertiary,
//                               fontSize: 14,
//                               fontWeight: FontWeight.w400,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//   }
// }