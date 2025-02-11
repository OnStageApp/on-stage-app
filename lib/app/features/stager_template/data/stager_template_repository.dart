import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/stager_template/domain/create_all_stager_templates.dart';
import 'package:on_stage_app/app/features/stager_template/domain/stager_template.dart';
import 'package:on_stage_app/app/shared/data/dio_client.dart';
import 'package:on_stage_app/app/utils/api.dart';
import 'package:retrofit/retrofit.dart';

part 'stager_template_repository.g.dart';

@RestApi()
abstract class StagerTemplateRepository {
  factory StagerTemplateRepository(Dio dio) = _StagerTemplateRepository;

  @GET(API.getStagerTemplates)
  Future<List<StagerTemplate>> getAll({
    @Query('eventTemplateId') required String eventTemplateId,
    @Query('groupId') required String groupId,
  });

  @DELETE(API.deleteStagerTemplate)
  Future<void> delete({
    @Path('id') required String id,
  });

  @POST(API.createStagerTemplates)
  Future<List<StagerTemplate>> addStagerToEvent(
    @Body() CreateAllStagerTemplates createStagerTemplatesRequest,
  );
}

final stagerTemplateRepo = Provider<StagerTemplateRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return StagerTemplateRepository(dio);
});
