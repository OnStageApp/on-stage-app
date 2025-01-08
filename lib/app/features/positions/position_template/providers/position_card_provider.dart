import 'package:on_stage_app/app/features/positions/position_template/application/position_notifier.dart';
import 'package:on_stage_app/app/features/positions/position_template/providers/position_card_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'position_card_provider.g.dart';

@riverpod
class PositionCard extends _$PositionCard {
  @override
  PositionCardState build(String positionId) {
    final position = ref.watch(positionNotifierProvider).positions.firstWhere(
          (position) => position.id == positionId,
          orElse: () => throw StateError('Position not found: $positionId'),
        );

    return PositionCardState(position: position);
  }

  void startEditing() {
    state = state.copyWith(isEditing: true);
  }

  void stopEditingAndSave(String newName) {
    if (newName.isEmpty) return;

    final updatedPosition = state.position.copyWith(name: newName);
    ref.read(positionNotifierProvider.notifier).updatePosition(updatedPosition);
    state = state.copyWith(isEditing: false);
  }

  void deletePosition() {
    ref.read(positionNotifierProvider.notifier).deletePosition(positionId);
  }
}
