import 'package:dio/dio.dart';
import 'package:on_stage_app/app/features/team_member/domain/create_team_member_request/create_team_member_request.dart';
import 'package:on_stage_app/app/features/team_member/domain/edit_team_member_request/edit_team_member_request.dart';
import 'package:on_stage_app/app/features/team_member/domain/team_member.dart';
import 'package:on_stage_app/app/features/team_member/domain/team_member_photo/team_member_photo_response.dart';
import 'package:on_stage_app/app/utils/api.dart';
import 'package:retrofit/retrofit.dart';

part 'team_member_repository.g.dart';

@RestApi(baseUrl: API.baseUrl)
abstract class TeamMemberRepository {
  factory TeamMemberRepository(Dio dio) = _TeamMemberRepository;

  @GET(API.teamMembers)
  Future<List<TeamMember>> getTeamMembers({
    @Query('includeCurrentUser') bool? includeCurrentUser,
  });

  @GET(API.currentTeamMember)
  Future<TeamMember> getCurrentTeamMember();

  @GET(API.uninvitedTeamMembers)
  Future<List<TeamMember>> getUninvitedTeamMembers(
    @Query('eventId') String eventId, {
    @Query('includeCurrentUser') bool includeCurrentUser = false,
  });

  @POST(API.addTeamMember)
  Future<TeamMember?> inviteTeamMember(
    @Body() CreateTeamMemberRequest addTeamMemberRequest,
  );

  @GET(API.teamMemberPhotos)
  Future<List<TeamMemberPhotoResponse>> getTeamMemberPhotos();

  @PUT(API.teamMembersById)
  Future<TeamMember?> updateTeamMember(
    @Path('id') String id,
    @Body() EditTeamMemberRequest teamMember,
  );

  @DELETE(API.teamMembersById)
  Future<void> deleteTeamMember(
    @Path('id') String id,
  );
}
