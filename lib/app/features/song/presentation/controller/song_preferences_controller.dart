import 'package:on_stage_app/app/features/song/domain/enums/structure_item.dart';
import 'package:on_stage_app/app/features/song/presentation/controller/song_preferences_controller_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'song_preferences_controller.g.dart';

@Riverpod(keepAlive: true)
class SongPreferencesController extends _$SongPreferencesController {
  @override
  SongPreferencesControllerState build() {
    return const SongPreferencesControllerState();
  }

  void toggleAddStructurePage({required bool isOnAddStructurePage}) {
    state = state.copyWith(isOnAddStructurePage: isOnAddStructurePage);
  }

  void removeStructureItem(StructureItem structureItem) {
    final structureItems = List<StructureItem>.from(state.structureItems)
      ..remove(structureItem);
    state = state.copyWith(structureItems: structureItems);
  }

  void addStructureItem(StructureItem structureItem) {
    final structureItems = List<StructureItem>.from(state.structureItems)
      ..add(structureItem);
    state = state.copyWith(structureItems: structureItems);
  }

  void clearStructureItems() {
    state = state.copyWith(structureItems: []);
  }

  void addAllStructureItems(List<StructureItem> structureItems) {
    state = state.copyWith(structureItems: structureItems);
  }

  void addStructureItemsToCurrent(List<StructureItem> structureItems) {
    final currentStructureItems = List<StructureItem>.from(state.structureItems)
      ..addAll(structureItems);
    state = state.copyWith(structureItems: currentStructureItems);
  }
}
