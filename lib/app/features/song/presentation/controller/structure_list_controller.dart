// structure_list_controller.dart
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/song/domain/enums/structure_item.dart';
import 'package:on_stage_app/app/features/song/presentation/controller/song_preferences_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'structure_list_controller.freezed.dart';
part 'structure_list_controller.g.dart';

@freezed
class StructureListState with _$StructureListState {
  const factory StructureListState({
    required List<StructureItem> items,
    @Default([]) List<GroupedStructureItem> groupedItems,
  }) = _StructureListState;
}

@freezed
class GroupedStructureItem with _$GroupedStructureItem {
  const factory GroupedStructureItem({
    required StructureItem item,
    required int multiplier,
    required int originalIndex,
  }) = _GroupedStructureItem;
}

@riverpod
class StructureListController extends _$StructureListController {
  @override
  StructureListState build() {
    return StructureListState(
      items: ref.watch(songPreferencesControllerProvider).structureItems,
      groupedItems: _createGroups(
        ref.watch(songPreferencesControllerProvider).structureItems,
      ),
    );
  }

  List<GroupedStructureItem> _createGroups(List<StructureItem> items) {
    if (items.isEmpty) return [];

    final groups = <GroupedStructureItem>[];
    var currentMultiplier = 1;
    var startIndex = 0;

    for (var i = 1; i < items.length; i++) {
      if (items[i] == items[i - 1]) {
        currentMultiplier++;
      } else {
        groups.add(
          GroupedStructureItem(
            item: items[i - 1],
            multiplier: currentMultiplier,
            originalIndex: startIndex,
          ),
        );
        startIndex = i;
        currentMultiplier = 1;
      }
    }
    groups.add(
      GroupedStructureItem(
        item: items.last,
        multiplier: currentMultiplier,
        originalIndex: startIndex,
      ),
    );

    return groups;
  }

  void reorderGroup(int oldIndex, int newIndex) {
    if (!_isValidIndex(oldIndex, newIndex)) return;

    final groups = [...state.groupedItems];
    final items = <StructureItem>[];

    if (newIndex > oldIndex) newIndex--;
    final group = groups.removeAt(oldIndex);
    groups.insert(newIndex, group);

    for (final group in groups) {
      items.addAll(List.filled(group.multiplier, group.item));
    }

    updateItems(items);
  }

  void removeGroup(int groupIndex) {
    if (!_isValidGroupIndex(groupIndex)) return;

    final groups = [...state.groupedItems];
    groups.removeAt(groupIndex);

    final items = <StructureItem>[];
    for (final group in groups) {
      items.addAll(List.filled(group.multiplier, group.item));
    }

    updateItems(items);
  }

  void cloneGroup(int groupIndex) {
    if (!_isValidGroupIndex(groupIndex)) return;

    final groups = [...state.groupedItems];
    final groupToClone = groups[groupIndex];
    groups.add(groupToClone);

    final items = <StructureItem>[];
    for (final group in groups) {
      items.addAll(List.filled(group.multiplier, group.item));
    }

    updateItems(items);
  }

  void addItemToGroup(int groupIndex) {
    if (!_isValidGroupIndex(groupIndex)) return;

    final currentItems = [...state.items];
    final groups = [...state.groupedItems];
    final targetGroup = groups[groupIndex];

    int insertPosition = 0;
    for (int i = 0; i <= groupIndex; i++) {
      insertPosition += groups[i].multiplier;
    }

    currentItems.insert(insertPosition, targetGroup.item);

    updateItems(currentItems);
  }

  void removeItemFromGroup(int groupIndex) {
    if (!_isValidGroupIndex(groupIndex)) return;

    final currentItems = [...state.items];
    final groups = [...state.groupedItems];
    final targetGroup = groups[groupIndex];

    if (targetGroup.multiplier <= 1) return;

    int removePosition = 0;
    for (int i = 0; i < groupIndex; i++) {
      removePosition += groups[i].multiplier;
    }
    removePosition += targetGroup.multiplier - 1;

    // Remove the item
    if (removePosition >= 0 && removePosition < currentItems.length) {
      currentItems.removeAt(removePosition);
      updateItems(currentItems);
    }
  }

  bool _isValidGroupIndex(int index) =>
      index >= 0 && index < state.groupedItems.length;

  bool _isValidIndex(int oldIndex, int newIndex) =>
      oldIndex >= 0 &&
      oldIndex < state.groupedItems.length &&
      newIndex >= 0 &&
      newIndex <= state.groupedItems.length;

  void updateItems(List<StructureItem> items) => ref
      .read(songPreferencesControllerProvider.notifier)
      .addAllStructureItems(items);
}
