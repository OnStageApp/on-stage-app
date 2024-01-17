import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:on_stage_app/app/features/event/application/event_notifier.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_model.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_model.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/stage_search_bar.dart';
import 'package:on_stage_app/app/shared/participant_profile.dart';
import 'package:on_stage_app/app/shared/providers/loading_provider/loading_provider.dart';
import 'package:on_stage_app/app/shared/song_author_tile.dart';
import 'package:on_stage_app/app/shared/song_chord_tile.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class EventDetailsScreen extends ConsumerStatefulWidget {
  const EventDetailsScreen(this.eventId, {super.key});

  final String eventId;

  @override
  EventDetailsScreenState createState() => EventDetailsScreenState();

}

class EventDetailsScreenState extends ConsumerState<EventDetailsScreen> {
  List<SongModel> _playlist = List.empty(growable: true);
  List<ParticipantProfile> _participants = List.empty(growable: true);
  EventModel? _event;


  @override
  void initState() {
    ref.read(eventNotifierProvider.notifier).getEventById(widget.eventId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(eventNotifierProvider).event == null;
    _event = ref.watch(eventNotifierProvider).event;
    _playlist = ref.watch(eventNotifierProvider).playlist;
    _participants = ref.watch(eventNotifierProvider).participants;

    final formattedDate = _event != null ? DateFormat('EEEE, dd MMMM').format(_event!.date) : '';
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: context.colorScheme.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
        title: Text(_event?.name ?? ''),
      ),
       body: isLoading
           ? _buildLoadingIndicator()
           : Padding(
         padding: defaultScreenPadding,
         child: ListView(
           children: [
             const SizedBox(height: Insets.medium),
             Text(
               formattedDate,
               style: context.textTheme.bodyMedium,
             ),
             const SizedBox(height: Insets.medium),
             SingleChildScrollView(
               scrollDirection: Axis.horizontal,
               child: Row(
                 children: [
                   ParticipantProfile(profilePicture: 'assets/images/profile1.png', fullName: 'Alexandru'),
                   SizedBox(width: 8),
                   ParticipantProfile(profilePicture: 'assets/images/profile2.png', fullName: 'Vasile'),
                   SizedBox(width: 8),
                   ParticipantProfile(profilePicture: 'assets/images/profile4.png', fullName: 'John Mayer'),
                   SizedBox(width: 8),
                   ParticipantProfile(profilePicture: 'assets/images/profile1.png', fullName: 'Alexandru'),
                   SizedBox(width: 8),
                   ParticipantProfile(profilePicture: 'assets/images/profile2.png', fullName: 'Vasile'),
                   SizedBox(width: 8),
                   ParticipantProfile(profilePicture: 'assets/images/profile4.png', fullName: 'John Mayer'),
                   SizedBox(width: 8),
                   ParticipantProfile(profilePicture: 'assets/images/profile1.png', fullName: 'Alexandru'),
                 ],
               ),
             ),
             const SizedBox(height: Insets.medium),
             Text(
               'Playlist',
               style: context.textTheme.titleMedium,
             ),
             const SizedBox(height: Insets.normal),
             if (ref.watch(loadingProvider.notifier).state)
               _buildLoadingIndicator()
             else
               _buildPlaylist(),
           ],
         ),
       ),
    );
  }


  Widget _buildPlaylist() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _playlist.length,
      itemBuilder: (context, index) {
        final song = _playlist[index];

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: 
            SongChordTile(song: song),
        );
        
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: SizedBox(
        width: 50,
        height: 50,
        child: LoadingIndicator(
          indicatorType: Indicator.ballClipRotateMultiple,
        ),
      ),
    );
  }

  Widget _buildParticipants() {
    return SizedBox(
      height: 81,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final participant = _participants[index];
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Container(child: participant),
              ),
            ],
          );
        },
        shrinkWrap: true,
      ),
    );
  }



}
