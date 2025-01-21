import 'package:on_stage_app/app/features/event/domain/models/stager/stager_overview.dart';
import 'package:on_stage_app/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'assigned_stagers_to_item_notifier.g.dart';

@riverpod
class StagerSelection extends _$StagerSelection {
  @override
  List<StagerOverview> build() => [];

  void setStagers(List<StagerOverview> stagers) {
    logger.i('Setting stagers: ${stagers.length}');
    state = stagers;
  }

  void addStager(StagerOverview stager) {
    if (state.any((s) => s.id == stager.id)) return;
    final newList = List.of(state)..add(stager);
    state = newList;
  }

  void removeStager(String stagerId) {
    final newList = List.of(state)..removeWhere((s) => s.id == stagerId);
    state = newList;
  }

  void clearStagers() {
    state = List.empty();
  }

  bool hasStager(String stagerId) {
    return state.any((s) => s.id == stagerId);
  }
}
