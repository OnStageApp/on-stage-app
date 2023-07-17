import 'package:flutter/material.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreentate();
}

class _ProfileScreentate extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.background,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 16),
          child: Column(
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'John Mayer',
                        style: context.textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '@johnmayer03',
                        style: context.textTheme.bodyLarge,
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Column(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage:
                        AssetImage('assets/images/profile1.png'),
                        radius: 50,
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Container(
                  decoration: BoxDecoration(
                    color: context.colorScheme.onPrimary,
                      border: Border.all(
                        color: Colors.transparent,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(12))),


                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.bookmark_border_rounded,
                              color: context.colorScheme.primary,
                              size: 16,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                'Saved',
                                style: context.textTheme.bodyLarge,
                              ),
                            ),
                            Spacer(),
                            Text(
                              '23',
                              style: context.textTheme.bodyLarge!.copyWith(
                                color: context.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(
                              Icons.person_2_outlined,
                              color: context.colorScheme.primary,
                              size: 16,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                'Friends',
                                style: context.textTheme.bodyLarge,
                              ),
                            ),
                            Spacer(),
                            Text(
                              '54',
                              style: context.textTheme.bodyLarge!.copyWith(
                                color: context.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(
                              Icons.music_note_outlined,
                              color: context.colorScheme.primary,
                              size: 16,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                'Friends',
                                style: context.textTheme.bodyLarge,
                              ),
                            ),
                            Spacer(),
                            Text(
                              '560',
                              style: context.textTheme.bodyLarge!.copyWith(
                                color: context.colorScheme.primary,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )),
            ],
          ),
        ),

      ),
    );
  }
}
