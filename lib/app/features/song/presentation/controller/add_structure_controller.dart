import 'package:on_stage_app/app/features/song/domain/enums/structure_item.dart';
import 'package:on_stage_app/app/features/song/presentation/controller/add_structure_controller_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'add_structure_controller.g.dart';

@Riverpod(keepAlive: true)
class AddStructureController extends _$AddStructureController {
  @override
  AddStructureControllerState build() {
    return const AddStructureControllerState();
  }

  void addStructureItem(StructureItem structureItem) {
    final structureItems = List<StructureItem>.from(state.structureItemsToAdd)
      ..add(structureItem);
    state = state.copyWith(structureItemsToAdd: structureItems);
  }

  void clearStructureItems() {
    state = state.copyWith(structureItemsToAdd: []);
  }

  void addAllStructureItems(List<StructureItem> structureItems) {
    state = state.copyWith(structureItemsToAdd: structureItems);
  }

  void removeStructureItem(StructureItem structureItem) {
    final structureItems = List<StructureItem>.from(state.structureItemsToAdd)
      ..remove(structureItem);
    state = state.copyWith(structureItemsToAdd: structureItems);
  }
}
