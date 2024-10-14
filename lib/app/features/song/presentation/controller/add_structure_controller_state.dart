import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/song/domain/enums/structure_item.dart';

part 'add_structure_controller_state.freezed.dart';

@freezed
class AddStructureControllerState with _$AddStructureControllerState {
  const factory AddStructureControllerState({
    @Default([]) List<StructureItem> structureItemsToAdd,
  }) = _AddStructureControllerState;
}
