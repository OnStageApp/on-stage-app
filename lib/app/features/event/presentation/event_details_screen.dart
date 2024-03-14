import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:on_stage_app/app/features/event/application/event/event_notifier.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/song_playlist_widget.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/stagers_widget.dart';
import 'package:on_stage_app/app/shared/loading_widget.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/time_utils.dart';

class EventDetailsScreen extends ConsumerStatefulWidget {
  const EventDetailsScreen(this.eventId, {super.key});

  final String eventId;

  @override
  ConsumerState<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends ConsumerState<EventDetailsScreen> {
  late final String formattedDate;

  @override
  void initState() {
    super.initState();
    Future.microtask(_fetchEventDetails);
    _formatDate();
  }

  void _formatDate() {
    formattedDate = TimeUtils().formatDate(
      ref.read(eventNotifierProvider).event?.date,
    );
  }

  Future<void> _fetchEventDetails() async {
    await ref.read(eventNotifierProvider.notifier).getEventById(widget.eventId);
    await ref.read(eventNotifierProvider.notifier).getStagers();
  }

  @override
  Widget build(BuildContext context) {
    final eventState = ref.watch(eventNotifierProvider);
    return Scaffold(
      appBar: StageAppBar(
        title: eventState.event?.name ?? '',
        isBackButtonVisible: true,
      ),
      body: eventState.isLoading
          ? const OnStageLoadingIndicator()
          : Padding(
              padding: defaultScreenPadding,
              child: ListView(
                children: [
                  const SizedBox(height: Insets.medium),
                  Text(formattedDate, style: context.textTheme.bodyMedium),
                  const SizedBox(height: Insets.medium),
                  StagersList(stagers: eventState.stagers),
                  const SizedBox(height: Insets.medium),
                  Text('Playlist', style: context.textTheme.titleMedium),
                  const SizedBox(height: Insets.normal),
                  Playlist(playlist: eventState.playlist),
                ],
              ),
            ),
    );
  }
}
