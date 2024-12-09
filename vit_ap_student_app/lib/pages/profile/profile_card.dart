import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../utils/helper/text_newline.dart';
import '../../utils/provider/student_provider.dart';
import 'account_page.dart';

class ProfileCard extends ConsumerStatefulWidget {
  const ProfileCard({super.key});

  @override
  ConsumerState<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends ConsumerState<ProfileCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final studentState = ref.watch(studentProvider);

    return Padding(
      padding: const EdgeInsets.only(top: 100.0),
      child: studentState.when(
        data: (student) {
          final String username = student.profile.studentName;
          final String registrationNumber = student.registrationNumber;
          final String profileImagePath = student.pfpPath;

          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10, left: 25, right: 10),
                    child: CircleAvatar(
                      radius: 45,
                      backgroundImage: AssetImage(profileImagePath),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        addNewlines(username, 12),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      Text(
                        registrationNumber,
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 35.0),
                    child: IconButton(
                      color: Theme.of(context).colorScheme.primary,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AccountPage(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.mode_edit_rounded),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
        error: (error, stackTrace) => Center(
          child: Text(
            "Error loading profile: $error",
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
