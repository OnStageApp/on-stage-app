import 'package:on_stage_app/app/features/groups/group_template/application/group_template_state.dart';
import 'package:on_stage_app/app/features/groups/group_template/data/group_template_repository.dart';
import 'package:on_stage_app/app/features/groups/group_template/domain/create_or_edit_group_request.dart';
import 'package:on_stage_app/app/shared/data/dio_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'group_template_notifier.g.dart';

@riverpod
class GroupTemplateNotifier extends _$GroupTemplateNotifier {
  GroupTemplateRepository? _groupRepository;

  GroupTemplateRepository get groupRepository {
    _groupRepository ??= GroupTemplateRepository(ref.watch(dioProvider));
    return _groupRepository!;
  }

  @override
  GroupTemplateState build() {
    final dio = ref.watch(dioProvider);
    _groupRepository = GroupTemplateRepository(dio);
    return const GroupTemplateState();
  }

  Future<void> getGroupsTemplate() async {
    try {
      state = state.copyWith(isLoading: true);

      final groups = await groupRepository.getGroupsTemplate();
      state = state.copyWith(groups: groups);
    } catch (e) {
      state = state.copyWith(error: e);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> createGroup(String title) async {
    state = state.copyWith(error: null);

    try {
      final newGroup = await groupRepository.createGroup(
        CreateOrEditGroupRequest(
          name: title,
        ),
      );
      state = state.copyWith(
        groups: [...state.groups, newGroup],
      );
    } catch (e) {
      state = state.copyWith(error: e);
    }
  }

  Future<void> updateGroup(String id, String newName) async {
    try {
      _updateLocally(id, newName);
      await groupRepository.updateGroup(
        id,
        CreateOrEditGroupRequest(name: newName),
      );
    } catch (e) {
      // Rollback on error
      await getGroupsTemplate();
      state = state.copyWith(error: e);
    }
  }

  Future<void> deleteGroup(String id) async {
    final previousGroups = [...state.groups];

    try {
      // First attempt backend deletion
      await groupRepository.deleteGroup(id);

      // Only update state after successful backend operation
      state = state.copyWith(
        groups: state.groups.where((group) => group.id != id).toList(),
      );
    } catch (e) {
      // On error, restore previous state
      state = state.copyWith(
        groups: previousGroups,
        error: e.toString(),
      );

      // Optionally refresh to ensure sync with backend
      await getGroupsTemplate();
    }
  }

  void _updateLocally(String id, String newName) {
    state = state.copyWith(
      groups: state.groups.map((group) {
        if (group.id == id) {
          return group.copyWith(name: newName);
        }
        return group;
      }).toList(),
    );
  }
}
