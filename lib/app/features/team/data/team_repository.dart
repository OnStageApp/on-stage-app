import 'package:dio/dio.dart';
import 'package:on_stage_app/app/features/team/domain/team.dart';
import 'package:on_stage_app/app/features/team/domain/team_request/team_request.dart';
import 'package:on_stage_app/app/utils/api.dart';
import 'package:retrofit/retrofit.dart';

part 'team_repository.g.dart';

@RestApi(baseUrl: API.baseUrl)
abstract class TeamRepository {
  factory TeamRepository(Dio dio) = _TeamRepository;

  @GET(API.teams)
  Future<List<Team>> getTeams();

  @POST(API.teams)
  Future<Team> createTeam(@Body() TeamRequest teamRequest);

  @PUT(API.teamById)
  Future<Team> updateTeam(
    @Path('id') String id,
    @Body() TeamRequest teamRequest,
  );

  @DELETE(API.teamById)
  Future<void> deleteTeam(@Path('id') String id);
}
