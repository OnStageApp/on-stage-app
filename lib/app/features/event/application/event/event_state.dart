import 'package:equatable/equatable.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_model.dart';
import 'package:on_stage_app/app/features/event/domain/models/rehearsal/rehearsal_model.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/stager.dart';
import 'package:on_stage_app/app/features/positions/position_template/domain/position_stagers.dart';

class EventState extends Equatable {
  const EventState({
    this.stagers = const [],
    this.positionsWithStagers = const [],
    this.rehearsals = const [],
    this.event,
    this.isLoading = false,
  });

  final List<Stager> stagers;
  final List<PositionWithStagers> positionsWithStagers;
  final List<RehearsalModel> rehearsals;
  final EventModel? event;
  final bool isLoading;

  @override
  List<Object?> get props => [
        stagers,
        positionsWithStagers,
        rehearsals,
        event,
        isLoading,
      ];

  EventState copyWith({
    List<Stager>? stagers,
    List<PositionWithStagers>? positionsWithStagers,
    List<RehearsalModel>? rehearsals,
    EventModel? event,
    bool? isLoading,
  }) {
    return EventState(
      stagers: stagers ?? this.stagers,
      positionsWithStagers: positionsWithStagers ?? this.positionsWithStagers,
      rehearsals: rehearsals ?? this.rehearsals,
      event: event ?? this.event,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
