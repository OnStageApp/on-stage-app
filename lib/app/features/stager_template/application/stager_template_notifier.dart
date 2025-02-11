import 'package:flutter/foundation.dart';
import 'package:on_stage_app/app/database/app_database.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/create_all_stagers_request.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/create_stager_request.dart';
import 'package:on_stage_app/app/features/stager_template/application/stager_template_state.dart';
import 'package:on_stage_app/app/features/stager_template/data/stager_template_repository.dart';
import 'package:on_stage_app/app/features/stager_template/domain/create_all_stager_templates.dart';
import 'package:on_stage_app/app/features/stager_template/domain/stager_template.dart';
import 'package:on_stage_app/app/features/team_member/domain/team_member.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stager_template_notifier.g.dart';

@riverpod
class StagerTemplateNotifier extends _$StagerTemplateNotifier {
  StagerTemplateRepository get _repository => ref.read(stagerTemplateRepo);

  @override
  StagerTemplateState build() {
    return const StagerTemplateState();
  }

  Future<void> getStagersByGroupAndEventTemplate({
    required String eventTemplateId,
    required String groupId,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      final stagers = await _repository.getAll(
        eventTemplateId: eventTemplateId,
        groupId: groupId,
      );
      final stagersWithPhoto =
          await Future.wait<StagerTemplate>(stagers.map(_getStagerWithPhoto));
      state =
          state.copyWith(stagerTemplates: stagersWithPhoto, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
      );
      rethrow;
    }
  }

  Future<StagerTemplate> _getStagerWithPhoto(
    StagerTemplate stager,
  ) async {
    final photo = await _setPhotosFromLocalStorage(stager.userId);
    return stager.copyWith(profilePicture: photo);
  }

  Future<Uint8List?> _setPhotosFromLocalStorage(
    String? userId,
  ) async {
    if (userId == null) return null;
    final photo = await ref.read(databaseProvider).getTeamMemberPhoto(userId);
    return photo?.profilePicture;
  }

  Future<void> addStagersToEventTemplate(
    List<TeamMember> selectedMembers,
    String eventTemplateId,
    String positionId,
    String groupId,
  ) async {
    try {
      final request = CreateAllStagerTemplates(
        stagerTemplates: selectedMembers
            .map(
              (teamMember) => CreateStagerRequest(
                positionId: positionId,
                groupId: groupId,
                teamMemberId: teamMember.id,
                userId: teamMember.userId,
              ),
            )
            .toList(),
        eventTemplateId: eventTemplateId,
      );

      final newStagers = await _repository.addStagerToEvent(request);
      final newStagersWithPhoto = await Future.wait<StagerTemplate>(
        newStagers.map(_getStagerWithPhoto),
      );

      final updatedStagerTemplates = [
        ...state.stagerTemplates,
        ...newStagersWithPhoto,
      ];

      state = state.copyWith(
        stagerTemplates: updatedStagerTemplates,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeStagerTemplateById(
    String stagerTemplateId,
  ) async {
    try {
      await _repository.delete(id: stagerTemplateId);
      state = state.copyWith(
        stagerTemplates: state.stagerTemplates
            .where((stager) => stager.id != stagerTemplateId)
            .toList(),
      );
    } catch (e) {
      rethrow;
    }
  }
}
