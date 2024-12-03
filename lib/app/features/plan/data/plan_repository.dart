import 'package:dio/dio.dart';
import 'package:on_stage_app/app/features/plan/domain/plan.dart';
import 'package:on_stage_app/app/utils/api.dart';
import 'package:retrofit/retrofit.dart';

part 'plan_repository.g.dart';

@RestApi()
abstract class PlanRepository {
  factory PlanRepository(Dio dio) = _PlanRepository;

  @GET(API.plans)
  Future<List<Plan>> getPlans();
}
