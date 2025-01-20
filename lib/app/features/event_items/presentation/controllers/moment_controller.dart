import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event_items/application/event_items_notifier.dart';
import 'package:on_stage_app/app/features/event_items/domain/event_item.dart';
import 'package:on_stage_app/app/features/event_items/presentation/controllers/moment_state.dart';

final momentControllerProvider =
    StateNotifierProvider.family<MomentController, MomentState, EventItem>(
  MomentController.new,
);

class MomentController extends StateNotifier<MomentState> {
  MomentController(this.ref, EventItem moment)
      : super(MomentState.initial(moment));
  final Ref ref;

  void toggleEditing({required bool isEditing}) {
    state = state.copyWith(isEditing: isEditing);
  }

  void updateContent(String title, String description) {
    final hasChanges =
        title != state.moment.name || description != state.moment.description;

    state = state.copyWith(
      hasChanges: hasChanges,
      title: title,
      description: description,
    );
  }

  Future<void> saveChanges() async {
    if (!state.hasChanges) return;

    final updatedMoment = state.moment.copyWith(
      name: state.title,
      description: state.description,
    );

    await ref
        .read(eventItemsNotifierProvider.notifier)
        .updateMomentItem(updatedMoment);

    state = state.copyWith(
      isEditing: false,
      hasChanges: false,
    );
  }

  void cancelEditing() {
    state = state.copyWith(
      isEditing: false,
      hasChanges: false,
      title: state.moment.name ?? '',
      description: state.moment.description ?? '',
    );
  }
}
