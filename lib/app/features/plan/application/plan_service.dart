import 'package:logger/logger.dart';
import 'package:on_stage_app/app/database/app_database.dart';
import 'package:on_stage_app/app/features/plan/application/plan_state.dart';
import 'package:on_stage_app/app/features/plan/data/plan_repository.dart';
import 'package:on_stage_app/app/features/plan/domain/plan.dart';
import 'package:on_stage_app/app/shared/data/dio_client.dart';
import 'package:on_stage_app/app/utils/exceptions/plan_exception.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'plan_service.g.dart';

@Riverpod(keepAlive: true)
class PlanService extends _$PlanService {
  static final _logger = Logger();
  PlanRepository? _planRepository;

  PlanRepository get plansRepo {
    _planRepository ??= PlanRepository(ref.read(dioProvider));
    return _planRepository!;
  }

  AppDatabase get _db => ref.read(databaseProvider);

  @override
  PlanState build() {
    return const PlanState();
  }

  Future<List<Plan>> fetchAndSavePlans({bool forceRefresh = false}) async {
    state = state.copyWith(isLoading: true);

    try {
      List<Plan> plans;

      if (forceRefresh) {
        plans = await plansRepo.getPlans();
        await _db.saveAllPlans(plans);
      } else {
        plans = await _db.getAllPlans();
      }
      plans = plans..sort((a, b) => a.price.compareTo(b.price));
      _logger.i(' Plans saved successfully: ${plans.length} plans');
      state = state.copyWith(plans: plans);
      return plans;
    } catch (e) {
      _logger.e('Failed to fetch and save plans: $e');
      state = state.copyWith(error: 'Failed to load plans');
      throw PlanException('Failed to fetch and save plans', e);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<Plan?> getPlanById(String id) async {
    try {
      if (id.isEmpty) {
        throw PlanException('Plan ID cannot be empty');
      }

      final plan = await _db.getPlanById(id);
      _logger.i('Plan fetched by ID: $id');
      return plan;
    } catch (e) {
      _logger.e('Failed to get plan by ID $id: $e');
      throw PlanException('Failed to get plan', e);
    }
  }
}
