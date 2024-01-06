import 'package:on_stage_app/app/features/event/application/event_state.dart';
import 'package:on_stage_app/app/features/event/data/event_repository.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_model.dart';
import 'package:on_stage_app/app/shared/providers/loading_provider/loading_provider.dart';
import 'package:on_stage_app/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:on_stage_app/app/dummy_data/song_dummy.dart';

part 'event_notifier.g.dart';

@Riverpod(keepAlive: true)
class EventNotifier extends _$EventNotifier {

  @override
  EventState build() {
    return const EventState();
  }

  Future<void> init() async {
    if (state.events.isNotEmpty) {
      return;
    }
    logger.i('init event provider state');
    await getPastEvents();
    await getThisWeekEvents();
    await getUpcomingEvents();
  }

 



  Future<void> getPastEvents() async {
    ref.read(loadingProvider.notifier).state = true;
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    
    // TODO: uncomment when we use database
   // var pastEvents = await ref.read(eventRepositoryProvider.notifier).getEventsByRange(null, yesterday);

    final pastEvents = await Future.delayed(
      const Duration(seconds: 1),
          () => SongDummy.pastEventsDummy,
    );
   state = state.copyWith(pastEvents: pastEvents);
    ref.read(loadingProvider.notifier).state = false;
  }



    Future<void> getThisWeekEvents() async {
      ref.read(loadingProvider.notifier).state = true;
      // TODO: uncomment when we use database
      // DateTime now = DateTime.now();
      // DateTime lastDayOfTheWeek = now.subtract(Duration(days: now.weekday - 7));

      //var thisWeekEvents = await ref.read(eventRepositoryProvider.notifier).getEventsByRange(DateTime.now(), lastDayOfTheWeek);

      final thisWeekEvents = await Future.delayed(
        const Duration(seconds: 1),
            () => SongDummy.thisWeekEventsDummy,
      );

      state = state.copyWith(thisWeekEvents: thisWeekEvents);
      ref.read(loadingProvider.notifier).state = false;
     
    }

    Future<void> getUpcomingEvents() async {
      ref.read(loadingProvider.notifier).state = true;
      // TODO: uncomment when we use database

     // DateTime now = DateTime.now();
     // DateTime lastDayOfTheWeek = now.subtract(Duration(days: now.weekday - 7));

      //var upcomingEvents = await ref.read(eventRepositoryProvider.notifier).getEventsByRange(lastDayOfTheWeek, null);

      final upcomingEvents = await Future.delayed(
        const Duration(seconds: 1),
            () => SongDummy.upcomingEventsDummy,
      );

      state = state.copyWith(upcomingEvents: upcomingEvents);
      ref.read(loadingProvider.notifier).state = false;
    }

    Future<void> _getEventsByDate() async {

      ref.read(eventRepositoryProvider.notifier).getEventsByRange(DateTime.now(), DateTime.now());
    }
  }

