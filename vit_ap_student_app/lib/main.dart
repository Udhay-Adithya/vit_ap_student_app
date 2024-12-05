import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';
import 'package:wiredash/wiredash.dart';
import 'utils/auth/user_auth.dart';
import 'utils/provider/providers.dart';
import 'utils/provider/student_provider.dart';
import 'utils/provider/theme_provider.dart';
import 'firebase_options.dart';
import 'utils/services/class_notification_service.dart';
import 'utils/services/notification_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await HomeWidget.setAppGroupId('group.com.udhay.vitapstudentapp');
  NotificationService notificationService = await NotificationService();
  notificationService.initNotifications();
  await dotenv.load(fileName: "assets/.env");

  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeNotifications();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    NotificationManager.dispose();
    super.dispose();
  }

  Future<void> _initializeNotifications() async {
    final timetable = ref.read(timetableProvider);
    if (timetable.isNotEmpty) {
      await NotificationManager.initialize(ref);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      final timetable = ref.read(timetableProvider);
      if (timetable.isNotEmpty) {
        NotificationManager.checkAndRefreshIfNeeded(ref);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    ref.read(studentProvider.notifier).init(ref);
    return Wiredash(
      projectId: 'vit-ap-student-app-uh1uuvl',
      secret: dotenv.env['WIREDASH_SECRET_KEY']!,
      child: MaterialApp(
        themeAnimationCurve: Curves.easeInOut,
        debugShowCheckedModeBanner: false,
        theme: theme,
        title: 'VIT-AP Student App',
        home: AuthPage(),
      ),
    );
  }
}
