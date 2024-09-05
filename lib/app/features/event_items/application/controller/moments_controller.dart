import 'package:on_stage_app/app/features/event_items/application/controller/moments_controller_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'moments_controller.g.dart';

@riverpod
class MomentsController extends _$MomentsController {
  @override
  MomentsControllerState build() {
    return const MomentsControllerState();
  }

  List<String> getStructureItems() {
    return List.of(
      ['None', 'Prayer Time', 'Worship', 'Message', 'Testimony'],
    );
  }

  void addMoment(String moment) {
    state = state.copyWith(moments: [...state.moments, moment]);
  }

  void removeMoment(String moment) {
    state = state.copyWith(
      moments: state.moments.where((m) => m != moment).toList(),
    );
  }
}
