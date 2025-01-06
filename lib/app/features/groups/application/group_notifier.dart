import 'package:on_stage_app/app/features/groups/application/group_state.dart';
import 'package:on_stage_app/app/features/groups/data/group_repository.dart';
import 'package:on_stage_app/app/features/groups/domain/group.dart';
import 'package:on_stage_app/app/shared/data/dio_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'group_notifier.g.dart';

@riverpod
class GroupNotifier extends _$GroupNotifier {
  GroupRepository? _groupRepository;

  GroupRepository get groupRepository {
    _groupRepository ??= GroupRepository(ref.watch(dioProvider));
    return _groupRepository!;
  }

  @override
  GroupState build() {
    return const GroupState();
  }

  Future<void> loadGroups() async {
    final List<Group> groups = List.generate(
      3,
      (index) => Group(
        id: index.toString(),
        title: 'Group ${index + 1}',
        positionsLength: index + 1,
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

  Future<void> createGroup(String title) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final newGroup =
          await groupRepository.createGroup(Group(title: title, id: ''));
      state = state.copyWith(
        groups: [...state.groups, newGroup],
      );
    } catch (e) {
      state = state.copyWith(error: e);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> updateGroup(Group updatedGroup) async {
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
