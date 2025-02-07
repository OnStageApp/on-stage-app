import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/groups/group_event/domain/group_event.dart';
import 'package:on_stage_app/app/features/groups/group_event_template/domain/group_event_template.dart';
import 'package:on_stage_app/app/shared/data/dio_client.dart';
import 'package:on_stage_app/app/utils/api.dart';
import 'package:retrofit/retrofit.dart';

part 'group_event_template_repository.g.dart';

@RestApi()
abstract class GroupEventTemplateRepository {
  factory GroupEventTemplateRepository(Dio dio) = _GroupEventTemplateRepository;

  @GET(API.groupsForEventTemplate)
  Future<List<GroupEventTemplate>> getGroups(
    @Path('eventTemplateId') String eventTemplateId,
  );

  @GET(API.groupEventById)
  Future<GroupEvent> getGroupById(
    @Path('eventTemplateId') String eventTemplateId,
    @Path('groupId') String groupId,
  );
}

final groupEventTemplateRepo = Provider<GroupEventTemplateRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return GroupEventTemplateRepository(dio);
});
