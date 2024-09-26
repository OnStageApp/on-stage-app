import 'package:on_stage_app/app/features/event/presentation/controller/event_item_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'event_item_controller.g.dart';

@riverpod
class EventItemController extends _$EventItemController {
  @override
  EventItemControllerState build() {
    return const EventItemControllerState();
  }

  void setHasChanges({required bool value}) {
    state = state.copyWith(hasChanges: value, isButtonEnabled: value);
  }

  void resetChanges() {
    state = const EventItemControllerState();
  }
}
