// position_notifier.dart

import 'package:on_stage_app/app/features/positions/presentation/application/position_state.dart';
import 'package:on_stage_app/app/features/positions/presentation/domain/position.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'position_notifier.g.dart';

@riverpod
class PositionNotifier extends _$PositionNotifier {
  @override
  PositionState build() {
    return const PositionState();
  }

  Future<void> getPositions(String groupId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: Replace with actual API call
      final positions = [
        Position(id: '1', title: 'Guitar', groupId: '1'),
        Position(id: '2', title: 'Drums', groupId: '2'),
        Position(id: '3', title: 'Bass', groupId: '3'),
      ];
      final positionByGroup =
          positions.where((element) => element.groupId == groupId).toList();
      state = state.copyWith(
        positions: positionByGroup,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  void addPosition(Position position, String groupId) {
    final updatedPositions = [...state.positions, position];
    state = state.copyWith(positions: updatedPositions);
  }

  void updatePosition(Position updatedPosition) {
    final updatedPositions = state.positions.map((position) {
      if (position.id == updatedPosition.id) {
        return updatedPosition;
      }
      return position;
    }).toList();

    state = state.copyWith(positions: updatedPositions);
  }

  void deletePosition(String positionId) {
    final updatedPositions =
        state.positions.where((position) => position.id != positionId).toList();

    state = state.copyWith(positions: updatedPositions);
  }

  Position? getPositionById(String id) {
    try {
      return state.positions.firstWhere(
        (position) => position.id == id,
      );
    } catch (e) {
      return null;
    }
  }
}
