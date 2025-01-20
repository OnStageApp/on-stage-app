import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/stager_overview.dart';

class StagerSelection extends StateNotifier<List<StagerOverview>> {
  StagerSelection() : super([]);

  void setStagers(List<StagerOverview> stagers) => state = stagers;

  void addStager(StagerOverview stager) {
    if (state.any((s) => s.id == stager.id)) return;
    state = [...state, stager];
  }

  void removeStager(String stagerId) =>
      state = state.where((s) => s.id != stagerId).toList();

  void clearStagers() => state = [];

  bool hasStager(String stagerId) => state.any((s) => s.id == stagerId);
}

final stagerSelectionProvider =
    StateNotifierProvider<StagerSelection, List<StagerOverview>>(
  (ref) => StagerSelection(),
);
