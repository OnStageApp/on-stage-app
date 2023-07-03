import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/songs/presentation/widgets/stage_search_bar.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class SongsScreen extends StatefulWidget {
  const SongsScreen({super.key});

  @override
  State<SongsScreen> createState() => _SongsScreenState();
}

class _SongsScreenState extends State<SongsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: () {
                  context.goNamed(AppRoute.home.name);
                },
                child: const Text('Go back'),
              ),
              Text(
                'Songs',
                style: context.textTheme.headlineMedium,
              ),
              const SizedBox(height: 32),
              const StageSearchBar(),
            ],
          ),
        ),
      ),
    );
  }
}
