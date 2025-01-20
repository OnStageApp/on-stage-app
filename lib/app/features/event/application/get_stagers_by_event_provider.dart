import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/database/app_database.dart';
import 'package:on_stage_app/app/features/event/data/events_repository.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/stager_overview.dart';

final stagersByEventProvider =
    FutureProvider.autoDispose.family<List<StagerOverview>, String>(
  (ref, eventId) async {
    final eventRepo = ref.watch(eventsRepository);
    final database = ref.watch(databaseProvider);
    final stagers = await eventRepo.getStagersByEventId(eventId);

    // Process photos for all stagers in parallel
    final stagersWithPhotos = await Future.wait(
      stagers.map((stager) async {
        if (stager.userId == null) return stager;

        final photo = await database.getTeamMemberPhoto(stager.userId!);
        return stager.copyWith(profilePicture: photo?.profilePicture);
      }),
    );

    return stagersWithPhotos;
  },
);
