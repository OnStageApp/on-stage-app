import 'package:flutter/material.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
          style: context.textTheme.headlineMedium,
        ),
      ),
      body: Column(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                context.goNamed(AppRoute.songs.name);
              },
              child: const Text('Go to Songs'),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              context.goNamed(AppRoute.profile.name);
            },
            child: const Text('Go to Profile'),
          ),
        ],
      ),
    );
  }
}
