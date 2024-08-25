import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/application/events/events_notifier.dart';
import 'package:on_stage_app/app/features/home/presentation/widgets/group_tile.dart';
import 'package:on_stage_app/app/features/home/presentation/widgets/notification_widget.dart';
import 'package:on_stage_app/app/features/home/presentation/widgets/saved_songs_tiled.dart';
import 'package:on_stage_app/app/features/home/presentation/widgets/upcoming_event_enhanced.dart';
import 'package:on_stage_app/app/features/notifications/application/notification_notifier.dart';
import 'package:on_stage_app/app/features/search/presentation/stage_search_bar.dart';
import 'package:on_stage_app/app/features/song/application/songs/songs_notifier.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/song_tile.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  final hasUpcomingEvent = true;

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
    final songs = ref.watch(songsNotifierProvider).filteredSongs;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            CupertinoSliverRefreshControl(
              onRefresh: () async {
                // Implement refresh logic here
                await Future.wait([
                  ref.read(songsNotifierProvider.notifier).getSongs(),
                  ref
                      .read(notificationNotifierProvider.notifier)
                      .getNotifications(),
                  ref.read(eventsNotifierProvider.notifier).getEvents(),
                ]);
              },
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  _buildTopBar(),
                  const SizedBox(height: Insets.large),
                  _buildEnhanced(hasUpcomingEvent),
                  const SizedBox(height: Insets.extraLarge),
                ],
              ),
            ),
            SliverPadding(
              padding: defaultScreenHorizontalPadding,
              sliver: SliverToBoxAdapter(
                child: Text(
                  'Recently Added',
                  style: context.textTheme.headlineMedium,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(top: Insets.large),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final song = songs[index];
                    return Padding(
                      padding: defaultScreenHorizontalPadding,
                      child: Column(
                        children: [
                          SongTile(song: song),
                          const SizedBox(height: Insets.smallNormal),
                        ],
                      ),
                    );
                  },
                  childCount: songs.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: defaultScreenHorizontalPadding,
      child: Row(
        children: [
          Expanded(
            child: Hero(
              tag: 'searchBar',
              child: StageSearchBar(
                focusNode: FocusNode(),
                onTap: () => context.pushNamed(AppRoute.songs.name),
              ),
            ),
          ),
          const SizedBox(width: Insets.smallNormal),
          const NotificationWidget(),
        ],
      ),
    );
  }

  Widget _buildEnhanced(bool hasUpcomingEvent) {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          height: 240,
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 8),
            child: UpcomingEventEnhanced(
              title: 'Duminică seara la elsh',
              hour: '18:00',
              hasUpcomingEvent: hasUpcomingEvent,
            ),
          ),
        ),
        Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              height: 112,
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 16),
                child: GroupTile(
                  title: 'Group',
                  hasUpcomingEvent: hasUpcomingEvent,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              height: 112,
              child: const Padding(
                padding: EdgeInsets.only(left: 8, right: 16),
                child: SavedSongsTile(
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
