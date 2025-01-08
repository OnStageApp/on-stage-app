import 'package:on_stage_app/app/features/groups/group_event/application/group_event_state.dart';
import 'package:on_stage_app/app/features/groups/group_event/data/group_repository.dart';
import 'package:on_stage_app/app/features/groups/group_event/domain/group_event.dart';
import 'package:on_stage_app/app/shared/data/dio_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'group_event_notifier.g.dart';

@riverpod
class GroupEventNotifier extends _$GroupEventNotifier {
  GroupEventRepository? _groupRepository;

  GroupEventRepository get groupRepository {
    _groupRepository ??= GroupEventRepository(ref.watch(dioProvider));
    return _groupRepository!;
  }

  @override
  GroupEventState build() {
    return const GroupEventState();
  }

  Future<void> getGroupsEvent() async {
    final groups = await Future.delayed(const Duration(seconds: 1), () {
      return List.generate(
        3,
        (index) => GroupEvent(
          id: index.toString(),
          name: 'Group ${index + 1}',
          stagerCount: index + 1,
          confirmedCount: index,
        ),
      );
    });

    state = state.copyWith(isLoading: true, error: null);

    try {
      // final groups = await groupEventRepository.getGroups();
      state = state.copyWith(groupEvents: groups);
    } catch (e) {
      state = state.copyWith(error: e);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}
