import 'package:equatable/equatable.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_model.dart';
import 'package:on_stage_app/app/features/event/domain/models/rehearsal/rehearsal_model.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/stager.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_model.dart';

class EventState extends Equatable {
  const EventState({
    this.playlist = const [],
    this.stagers = const [],
    this.rehearsals = const [],
    this.event,
    this.isLoading = false,
  });

  final List<SongModel> playlist;
  final List<Stager> stagers;
  final List<RehearsalModel> rehearsals;
  final EventModel? event;
  final bool isLoading;

  @override
  List<Object?> get props => [playlist, stagers, rehearsals, event, isLoading];

  EventState copyWith({
    List<SongModel>? playlist,
    List<Stager>? stagers,
    List<RehearsalModel>? rehearsals,
    EventModel? event,
    bool? isLoading,
  }) {
    return EventState(
      playlist: playlist ?? this.playlist,
      stagers: stagers ?? this.stagers,
      rehearsals: rehearsals ?? this.rehearsals,
      event: event ?? this.event,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
