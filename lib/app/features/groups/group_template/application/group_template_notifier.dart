import 'package:on_stage_app/app/features/groups/group_template/application/group_template_state.dart';
import 'package:on_stage_app/app/features/groups/group_template/data/group_template_repository.dart';
import 'package:on_stage_app/app/features/groups/group_template/domain/group_template.dart';
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
    return const GroupTemplateState();
  }

  Future<void> getGroupsTemplate() async {
    final groups = List.generate(
      3,
      (index) => GroupTemplateModel(
        id: index.toString(),
        name: 'Group ${index + 1}',
        positionsCount: index + 1,
      ),
    );
    state = state.copyWith(isLoading: true, error: null);

    try {
      // final groups = await groupRepository.getGroups();
      state = state.copyWith(groups: groups);
    } catch (e) {
      state = state.copyWith(error: e);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> getGroupsEvent() async {
    // final groups = List.generate(
    //   3,
    //   (index) => GroupEvent(
    //     id: index.toString(),
    //     name: 'Group ${index + 1}',
    //
    //   ),
    // );
    // state = state.copyWith(isLoading: true, error: null);
    //
    // try {
    //   // final groups = await groupRepository.getGroups();
    //   state = state.copyWith(groups: groups);
    // } catch (e) {
    //   state = state.copyWith(error: e);
    // } finally {
    //   state = state.copyWith(isLoading: false);
    // }
  }

  Future<void> createGroup(String title) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final newGroup = await groupRepository
          .createGroup(GroupTemplateModel(name: title, id: ''));
      state = state.copyWith(
        groups: [...state.groups, newGroup],
      );
    } catch (e) {
      state = state.copyWith(error: e);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> updateGroup(GroupTemplateModel updatedGroup) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // await groupRepository.updateGroup();
      state = state.copyWith(
        groups: state.groups.map((group) {
          return group.id == updatedGroup.id ? updatedGroup : group;
        }).toList(),
      );
    } catch (e) {
      state = state.copyWith(error: e);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> deleteGroup(String id) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await groupRepository.deleteGroup(id);
      state = state.copyWith(
        groups: state.groups.where((group) => group.id != id).toList(),
      );
    } catch (e) {
      state = state.copyWith(error: e);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}
