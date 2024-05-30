import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vit_ap_student_app/models/widgets/my_list_tile_widget.dart';
import 'package:vit_ap_student_app/pages/login_page.dart';
import 'package:vit_ap_student_app/pages/profile/account_page.dart';
import 'package:vit_ap_student_app/pages/profile/notifications_page.dart';
import 'package:vit_ap_student_app/pages/profile/settings_page.dart';
import 'package:vit_ap_student_app/pages/profile/themes_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            title: Text(
              "My Profile",
              style: TextStyle(fontWeight: FontWeight.w400),
            ),
            centerTitle: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.only(top: 100.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 25, right: 10),
                          child: CircleAvatar(
                            radius: 45,
                            backgroundImage:
                                AssetImage('assets/images/profile_image.jpg'),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Udhay Adithya",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              "23BCE7625",
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 35.0),
                          child: IconButton(
                            onPressed: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AccountPage()),
                              )
                            },
                            icon: Icon(Icons.mode_edit_rounded),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    textAlign: TextAlign.left,
                    "Account",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                ),
                SettingsListTile(
                  icon: Icons.person_outline,
                  title: "My Account",
                  subtitle: "Check your personal information",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AccountPage()),
                    );
                  },
                ),
                SettingsListTile(
                  icon: Icons.notifications_none_rounded,
                  title: "Notification",
                  subtitle: "Personalize your notifications",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NotificationPage()),
                    );
                  },
                ),
                SettingsListTile(
                  icon: Icons.lock_outline_rounded,
                  title: "Settings",
                  subtitle: "Customize your privacy settings",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserSettings(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  "App",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
              ),
              SettingsListTile(
                icon: Icons.color_lens_outlined,
                title: "Themes",
                subtitle: "Customize your app themes",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserThemes(),
                    ),
                  );
                },
              ),
              SettingsListTile(
                icon: Icons.sync_rounded,
                title: "Sync",
                subtitle: "Sync latest data with V-Top",
              ),
              SettingsListTile(
                icon: Icons.share_outlined,
                title: "Tell a friend",
                subtitle: "Show us some love by sharing this app ",
                onTap: () async {
                  final result = await Share.share(
                      'check out my website https://example.com');
                  if (result.status == ShareResultStatus.success) {
                    print('Thank you for sharing my website!');
                  }
                },
              ),
              SettingsListTile(
                icon: Icons.my_library_books_outlined,
                title: "Terms and Conditions",
                subtitle: "Make sure that you agree to these rules",
              ),
            ],
          )),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    "Actions",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                ),
                SettingsListTile(
                  icon: Icons.bug_report_outlined,
                  title: "Report a problem",
                  subtitle: "Bugs? Let us fix them for you ",
                ),
                SettingsListTile(
                  icon: Icons.star_outline_rounded,
                  title: "Rate us",
                  subtitle: "Show your love by rating us!",
                ),
                SettingsListTile(
                  icon: Icons.logout_rounded,
                  title: "Sign out",
                  subtitle: "Logout out of VTOP Student App",
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    prefs.setBool('isLoggedIn', false);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
