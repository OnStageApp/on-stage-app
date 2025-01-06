import 'package:dio/dio.dart';
import 'package:on_stage_app/app/features/groups/domain/group.dart';
import 'package:retrofit/retrofit.dart';

part 'group_repository.g.dart';

@RestApi()
abstract class GroupRepository {
  factory GroupRepository(Dio dio) = _GroupRepository;

  @GET('')
  Future<List<Group>> getGroups();

  @POST('')
  Future<Group> createGroup(@Body() Group group);

  @PUT('')
  Future<Group> updateGroup();

  @DELETE('')
  Future<void> deleteGroup(@Path('id') String id);
}
