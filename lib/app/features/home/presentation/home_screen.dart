import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/application/events/events_notifier.dart';
import 'package:on_stage_app/app/features/home/presentation/widgets/group_tile.dart';
import 'package:on_stage_app/app/features/home/presentation/widgets/notification_widget.dart';
import 'package:on_stage_app/app/features/home/presentation/widgets/saved_songs_tiled.dart';
import 'package:on_stage_app/app/features/home/presentation/widgets/upcoming_event_enhanced.dart';
import 'package:on_stage_app/app/features/notifications/application/notification_notifier.dart';
import 'package:on_stage_app/app/features/onboarding/presentation/onboarding_screen.dart';
import 'package:on_stage_app/app/features/song/application/songs/song_tab_scope.dart';
import 'package:on_stage_app/app/features/song/application/songs/songs_notifier.dart';
import 'package:on_stage_app/app/features/team/application/team_notifier.dart';
import 'package:on_stage_app/app/features/user_settings/application/user_settings_notifier.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/song_tile.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/time_utils.dart';

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
      showOnboardingOverlay(context);
    });
  }

  void initializeNotifiers() {
    ref.read(songsNotifierProvider(SongTabScope.home).notifier).getSongs();
    ref.read(eventsNotifierProvider.notifier).getUpcomingEvent();
    ref.read(teamNotifierProvider.notifier).getCurrentTeam();
  }

  @override
  Widget build(BuildContext context) {
    _listenToOnboardingStatus();
    final songs =
        ref.watch(songsNotifierProvider(SongTabScope.home)).filteredSongs;

    return Padding(
      padding: getResponsivePadding(context),
      child: Scaffold(
        appBar: StageAppBar(
          background: context.isLargeScreen
              ? context.colorScheme.surfaceContainerHigh
              : context.colorScheme.surface,
          title: 'Dashboard',
          trailing: const Padding(
            padding: EdgeInsets.only(right: 16),
            child: NotificationWidget(),
          ),
        ),
        body: RefreshIndicator.adaptive(
          onRefresh: () async {
            await Future.wait([
              ref
                  .read(songsNotifierProvider(SongTabScope.home).notifier)
                  .getSongs(),
              ref.read(eventsNotifierProvider.notifier).getUpcomingEvent(),
              ref
                  .read(notificationNotifierProvider.notifier)
                  .getNotifications(),
            ]);
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: Insets.medium),
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
                    style: context.textTheme.titleMedium,
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.only(top: Insets.smallNormal),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final song = songs[index];
                      return Padding(
                        padding: defaultScreenHorizontalPadding,
                        child: Column(
                          children: [
                            SongTile(
                              song: song,
                              songTabScope: SongTabScope.home,
                            ),
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
      ),
    );
  }

  void _listenToOnboardingStatus() {
    ref.listen<bool>(
      userSettingsNotifierProvider
          .select((settings) => settings.isOnboardingDone ?? true),
      (_, isOnboardingDone) {
        if (isOnboardingDone == false) {
          showOnboardingOverlay(context);
        }
      },
    );
  }

  Widget _buildEnhanced(bool hasUpcomingEvent) {
    final upcomingEvent = ref.watch(eventsNotifierProvider).upcomingEvent;
    final currentTeam = ref.watch(teamNotifierProvider).currentTeam;

    return SizedBox(
      height: 240,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 8),
              child: UpcomingEventEnhanced(
                onTap: () => context.pushNamed(
                  AppRoute.eventDetails.name,
                  queryParameters: {'eventId': upcomingEvent!.id},
                ),
                title: upcomingEvent?.name ?? 'Loading...',
                hour: TimeUtils().formatOnlyTime(upcomingEvent?.dateTime),
                date: TimeUtils().formatOnlyDate(upcomingEvent?.dateTime),
                stagerPhotos: upcomingEvent?.stagerPhotos ?? [],
                stagerCount: upcomingEvent?.stagerCount ?? 0,
                hasUpcomingEvent: upcomingEvent != null,
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 16),
                  child: SizedBox(
                    height: 112,
                    child: GroupTile(
                      title: currentTeam?.name ?? ' ',
                      hasUpcomingEvent: hasUpcomingEvent,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.only(left: 8, right: 16),
                  child: SizedBox(
                    height: 112,
                    child: SavedSongsTile(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
