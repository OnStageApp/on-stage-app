import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/application/events/events_notifier.dart';
import 'package:on_stage_app/app/features/notifications/application/notification_notifier.dart';
import 'package:on_stage_app/app/features/song/application/song_provider.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/stage_search_bar.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/profile_image_inbox_widget.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    Future.microtask(initializeNotifiers);
  }

  void initializeNotifiers() {
    ref.read(songNotifierProvider.notifier).init();
    ref.read(notificationNotifierProvider.notifier).getNotifications();
    ref.read(eventsNotifierProvider.notifier).init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            _buildHeader(),
            const SizedBox(height: Insets.large),
            _buildSearchBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: defaultScreenHorizontalPadding,
      child: Row(
        children: [
          _buildWelcomeText(),
          const Expanded(child: SizedBox()),
          const ProfileImageInboxWidget(),
        ],
      ),
    );
  }

  Widget _buildWelcomeText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Welcome', style: context.textTheme.headlineLarge),
        const SizedBox(height: 4),
        Text(
          '@johnmayer145',
          style: context.textTheme.bodyLarge
              ?.copyWith(color: context.colorScheme.outline),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: defaultScreenHorizontalPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: 'searchBar',
            child: StageSearchBar(
              focusNode: _focusNode,
              onTap: () => context.pushNamed(AppRoute.songs.name),
            ),
          ),
          const SizedBox(height: Insets.large),
          Text('Upcoming Event', style: context.textTheme.titleMedium),
          const SizedBox(height: Insets.medium),
          Text('Top Rated', style: context.textTheme.titleMedium),
          const SizedBox(height: Insets.medium),
        ],
      ),
    );
  }
}
