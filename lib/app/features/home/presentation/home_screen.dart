import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/application/events/events_notifier.dart';
import 'package:on_stage_app/app/features/home/presentation/widgets/friends_enhanced_tile.dart';
import 'package:on_stage_app/app/features/home/presentation/widgets/upcoming_event_enhanced.dart';
import 'package:on_stage_app/app/features/notifications/application/notification_notifier.dart';
import 'package:on_stage_app/app/features/song/application/songs/songs_notifier.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/stage_search_bar.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/profile_image_inbox_widget.dart';
import 'package:on_stage_app/app/shared/song_tile.dart';
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      initializeNotifiers();
    });
  }

  void initializeNotifiers() {
    ref.read(songsNotifierProvider.notifier).init();
    ref.read(notificationNotifierProvider.notifier).getNotifications();
    ref.read(eventsNotifierProvider.notifier).init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: Insets.large),
            _buildHeader(),
            const SizedBox(height: Insets.large),
            _buildSearchBar(),
            const SizedBox(height: Insets.large),
            _buildEnhanced(),
            const SizedBox(height: Insets.extraLarge),
            Padding(
              padding: defaultScreenHorizontalPadding,
              child: Text(
                'Upcoming events',
                style: context.textTheme.headlineMedium,
              ),
            ),
            const SizedBox(height: Insets.large),
            _buildRecentlyAdded(),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentlyAdded() {
    final songs = ref.watch(songsNotifierProvider).songs;
    return Padding(
      padding: defaultScreenHorizontalPadding,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: songs.length,
        itemBuilder: (context, index) {
          final song = songs[index];
          return Column(
            children: [
              // SongTile(
              //   song: song,
              // ),
              Divider(
                color: context.colorScheme.outlineVariant,
                thickness: 1,
                height: Insets.medium,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: defaultScreenHorizontalPadding,
      child: Row(
        children: [
          const ProfileImageInboxWidget(),
          const SizedBox(width: Insets.medium),
          _buildWelcomeText(),
          const Expanded(child: SizedBox()),
          IconButton(
            onPressed: () => {context.pushNamed(AppRoute.notification.name)},
            icon: Icon(
              Icons.notifications_none_outlined,
              color: context.colorScheme.onSurfaceVariant,
              size: 36,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome back,',
          style: context.textTheme.bodyLarge!.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          'Ferra Alexandra',
          style: context.textTheme.headlineSmall!.copyWith(
            fontWeight: FontWeight.bold,
          ),
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
        ],
      ),
    );
  }

  Widget _buildEnhanced() {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          height: 240,
          child: const Padding(
            padding: EdgeInsets.only(left: 16, right: 8),
            child: UpcomingEventEnhanced(
              title: 'Duminică seara la elsh',
              hour: '18:00',
              location: 'Sala El-Shaddai',
            ),
          ),
        ),
        Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              height: 112,
              child: const Padding(
                padding: EdgeInsets.only(left: 8, right: 16),
                child: FriendsEnhancedTile(
                  title: 'Duminică seara',
                  hour: '18:00',
                  location: 'Sala El-Shaddai',
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              height: 112,
              child: const Padding(
                padding: EdgeInsets.only(left: 8, right: 16),
                child: FriendsEnhancedTile(
                  title: 'Duminică seara',
                  hour: '18:00',
                  location: 'Sala El-Shaddai',
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
