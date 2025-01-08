import 'package:dio/dio.dart';
import 'package:on_stage_app/app/features/groups/group_event/domain/group_event.dart';
import 'package:retrofit/retrofit.dart';

part 'group_repository.g.dart';

@RestApi()
abstract class GroupEventRepository {
  factory GroupEventRepository(Dio dio) = _GroupEventRepository;

  @GET('')
  Future<List<GroupEvent>> getGroups();
}
