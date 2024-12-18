import 'dart:developer';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/custom/loading_dialogue_box.dart';
import '../../widgets/custom/my_snackbar.dart';
import '../../widgets/timetable/my_semester_dropdown.dart';
import '../../utils/provider/providers.dart';
import '../../utils/provider/theme_provider.dart';
import '../onboarding/pfp_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends ConsumerState<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? selectedSemSubID;
  String? _profileImagePath;
  bool _isObscure = true;

  @override
  void initState() {
    super.initState();
    _loadProfileImagePath();
  }

  Future<void> _loadProfileImagePath() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _profileImagePath =
          prefs.getString('pfpPath') ?? 'assets/images/pfp/default.png';
    });
  }

  void clearControllers() {
    usernameController.clear();
    passwordController.clear();
  }

  String validateInput() {
    final username = usernameController.text;
    final password = passwordController.text;

    if (username.isEmpty) {
      return "Make sure that you fill the username field";
    } else if (password.isEmpty) {
      return "Make sure that you fill the password field";
    } else if (selectedSemSubID == null ||
        selectedSemSubID == 'Select Semester') {
      return "Make sure that you select a valid semester";
    }

    final validUsernamePattern = RegExp(r'^[a-zA-Z0-9]+$');
    if (!validUsernamePattern.hasMatch(username)) {
      return "Make sure that username does not contain any special character";
    }

    return "true";
  }

  Future<void> _checkConnectivityAndLogin(BuildContext context) async {
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());

    if (connectivityResult.contains(ConnectivityResult.none)) {
      Navigator.pop(context);
      final snackBar = MySnackBar(
        title: 'Oops',
        message: 'Please check your internet connection and try again.',
        contentType: ContentType.failure,
      ).build(context);

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar as SnackBar);
    } else {
      showLoadingDialog(context, "Fetching all your information from\nVTOP");
      ref
          .read(loginProvider.notifier)
          .login(usernameController.text.toUpperCase(), passwordController.text,
              selectedSemSubID!, context)
          .then((_) {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              scale: 0.25,
              opacity: 0.15,
              image: AssetImage("assets/images/login/login_bg.png"),
              fit: BoxFit.cover,
              colorFilter: const ColorFilter.mode(
                Colors.black12,
                BlendMode.darken,
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            type: PageTransitionType.fade,
                            child: MyProfilePicScreen(
                              instructionText:
                                  "Choose a profile picture that best represents you. You can change it anytime from your profile settings.",
                              nextPage: LoginPage(),
                            ),
                          ),
                        );
                      },
                      icon: Icon(Icons.arrow_back_rounded, color: Colors.blue),
                      label: Text(
                        "Back",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                    IconButton(
                      color: Theme.of(context).colorScheme.primary,
                      icon: Icon(
                        ref.watch(themeModeProvider) == AppThemeMode.dark
                            ? Icons.dark_mode
                            : Icons.light_mode,
                      ),
                      onPressed: () {
                        final currentTheme = ref.read(themeModeProvider);
                        final newTheme = currentTheme == AppThemeMode.dark
                            ? AppThemeMode.light
                            : AppThemeMode.dark;
                        ref
                            .read(themeModeProvider.notifier)
                            .setThemeMode(newTheme);
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width / 8,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage(
                        _profileImagePath ?? 'assets/images/pfp/default.png'),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.width / 10),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10, top: 8),
                  child: Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
              Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Container(
                        width: 320,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9),
                          color: Theme.of(context).colorScheme.surface,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5.0, top: 10),
                          child: TextFormField(
                            textCapitalization: TextCapitalization.characters,
                            controller: usernameController,
                            decoration: InputDecoration(
                              prefixIcon:
                                  const Icon(Icons.person_outline_rounded),
                              border: InputBorder.none,
                              hintText: 'Registration number',
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Container(
                        width: 320,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9),
                          color: Theme.of(context).colorScheme.surface,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5.0, top: 10),
                          child: TextFormField(
                            controller: passwordController,
                            obscureText: _isObscure,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isObscure
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isObscure = !_isObscure;
                                  });
                                },
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              border: InputBorder.none,
                              prefixIcon: const Icon(Icons.key),
                              hintText: 'Password',
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    MySemesterDropDownWidget(
                      onSelected: (value) {
                        setState(() {
                          selectedSemSubID = value;
                        });
                        log('$selectedSemSubID');
                      },
                    ),
                  ],
                ),
              ),
              Center(
                child: SizedBox(
                  height: 60,
                  width: 320,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      foregroundColor: WidgetStatePropertyAll<Color>(
                        Theme.of(context).colorScheme.primary,
                      ),
                      backgroundColor: WidgetStatePropertyAll<Color>(
                        Theme.of(context).colorScheme.surface,
                      ),
                      shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9.0),
                        ),
                      ),
                    ),
                    onPressed: () {
                      String validationResult = validateInput();
                      log('Input validation done');
                      if (validationResult == "true") {
                        _checkConnectivityAndLogin(context);
                      } else {
                        final snackBar = MySnackBar(
                          title: 'Oops!',
                          message: validationResult,
                          contentType: ContentType.warning,
                        ).build(context);

                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(snackBar as SnackBar);
                      }
                    },
                    child: const Text('Login'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
