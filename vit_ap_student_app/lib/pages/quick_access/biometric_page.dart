import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../../utils/provider/biometric_provider.dart';

class BiometricPage extends ConsumerStatefulWidget {
  const BiometricPage({super.key});

  @override
  ConsumerState<BiometricPage> createState() => _BiometricPageState();
}

class _BiometricPageState extends ConsumerState<BiometricPage> {
  TextEditingController dateController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? _picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2025),
      helpText: "Please select a date",
    );
    if (_picked != null) {
      setState(() {
        selectedDate = _picked;
        dateController.text = DateFormat('dd/MM/yyyy').format(selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat('dd/MM/yyyy').format(selectedDate);

    // Watch the provider here
    final biometricLogAsyncValue = ref.watch(biometricProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Text(
          "Biometric Log",
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
            child: Text(
              "Pick a date",
              style: TextStyle(fontSize: 18),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 8),
              Container(
                width: MediaQuery.sizeOf(context).width / 2,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9),
                  color: Theme.of(context).colorScheme.secondary,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: TextFormField(
                    textCapitalization: TextCapitalization.characters,
                    controller: dateController,
                    readOnly: true, // Prevent user from manually typing
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.date_range_outlined,
                        size: 26,
                      ),
                      border: InputBorder.none,
                      hintText: formattedDate,
                      hintStyle: TextStyle(
                        height: 3,
                        letterSpacing: 2,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9),
                  color: Theme.of(context).colorScheme.secondary,
                ),
                child: IconButton(
                  onPressed: () => _selectDate(context),
                  icon: Icon(Icons.calendar_month_outlined),
                ),
              ),
              SizedBox(width: 8),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9),
                  color: Theme.of(context).colorScheme.secondary,
                ),
                child: TextButton(
                  onPressed: () {
                    ref
                        .read(biometricProvider.notifier)
                        .fetchBiometricLog(formattedDate);
                  },
                  child: Text(
                    'Go',
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 4),
          Expanded(
            child: biometricLogAsyncValue.when(
              loading: () => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.asset(
                    "assets/images/lottie/loading_files.json",
                    frameRate: const FrameRate(60),
                    height: 100,
                  ),
                  Text(
                    "Stay still",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    "Searching the logs...",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              error: (error, stackTrace) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      "assets/images/lottie/404_astronaut.json",
                      width: 250,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Error occurred',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                    Text(
                      error.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              data: (data) {
                if (data['biometric_log'] == null ||
                    data['biometric_log'].isEmpty) {
                  return Center(
                    child: Text('No biometric logs found'),
                  );
                }

                final biometricLog = data['biometric_log'];
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: biometricLog.length,
                  itemBuilder: (context, index) {
                    String key = biometricLog.keys.elementAt(index);
                    var logEntry = biometricLog[key];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9)),
                          tileColor: Theme.of(context).colorScheme.secondary,
                          onLongPress: () {
                            // Implement any desired action on long press
                          },
                          leading: Container(
                            height: 55,
                            width: 55,
                            decoration: BoxDecoration(
                              color: Colors.orange.shade300.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: logEntry.toString().contains("MH") ||
                                    logEntry.toString().contains("LH")
                                ? Icon(
                                    Icons.maps_home_work_rounded,
                                    color: Colors.blue.shade300,
                                  )
                                : Icon(
                                    Icons.school_rounded,
                                    color: Colors.pink.shade300,
                                  ),
                          ),
                          title: Text(
                            '${logEntry["location"]}',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          subtitle: Text(
                            formattedDate,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                          ),
                          trailing: Text(
                            '${DateFormat.jm().format(DateFormat.Hm().parse(logEntry["time"]))}',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
