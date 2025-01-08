import 'package:on_stage_app/app/features/groups/group_template/application/group_template_notifier.dart';
import 'package:on_stage_app/app/features/groups/group_template/presentation/providers/group_card_template_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'group_card_template_provider.g.dart';

@riverpod
class GroupTemplate extends _$GroupTemplate {
  @override
  GroupCardTemplateState build(String groupId) {
    return GroupCardTemplateState(
      group: ref.watch(groupTemplateNotifierProvider).groups.firstWhere(
            (group) => group.id == groupId,
            orElse: () => throw StateError('Group not found: $groupId'),
          ),
    );
  }

  void startEditing() {
    state = state.copyWith(isEditing: true);
  }

  void stopEditingAndSave(String newTitle) {
    if (newTitle.isEmpty) return;

    final updatedGroup = state.group.copyWith(name: newTitle);
    ref.read(groupTemplateNotifierProvider.notifier).updateGroup(updatedGroup);
    state = state.copyWith(isEditing: false);
  }

  void deleteGroup() {
    ref
        .read(groupTemplateNotifierProvider.notifier)
        .deleteGroup(state.group.id);
  }
}
