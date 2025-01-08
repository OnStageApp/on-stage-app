import 'package:dio/dio.dart';
import 'package:on_stage_app/app/features/groups/group_template/domain/group_template.dart';
import 'package:retrofit/retrofit.dart';

part 'group_template_repository.g.dart';

@RestApi()
abstract class GroupTemplateRepository {
  factory GroupTemplateRepository(Dio dio) = _GroupTemplateRepository;

  @GET('')
  Future<List<GroupTemplateModel>> getGroups();

  @POST('')
  Future<GroupTemplateModel> createGroup(@Body() GroupTemplateModel group);

  @PUT('')
  Future<GroupTemplateModel> updateGroup();

  @DELETE('')
  Future<void> deleteGroup(@Path('id') String id);
}
