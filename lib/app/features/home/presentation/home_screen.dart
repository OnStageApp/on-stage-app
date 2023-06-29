import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:on_stage_app/app/router/app_router.dart';

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
        title: const Text('Home'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              context.pushNamed(AppRoute.songs.name);
            },
            child: const Text('Go to Songs'),
          ),
          const Center(
            child: Text('Home Screen'),
          ),
        ],
      ),
    );
  }
}
