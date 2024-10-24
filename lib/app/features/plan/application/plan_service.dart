import 'package:logger/logger.dart';
import 'package:on_stage_app/app/database/app_database.dart';
import 'package:on_stage_app/app/features/plan/application/plan_state.dart';
import 'package:on_stage_app/app/features/plan/domain/plan.dart';
import 'package:on_stage_app/app/utils/exceptions/plan_exception.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'plan_service.g.dart';

@Riverpod(keepAlive: true)
class PlanService extends _$PlanService {
  static final _logger = Logger();

  AppDatabase get _db => ref.read(databaseProvider);

  @override
  PlanState build() {
    return const PlanState();
  }

  Future<List<Plan>> fetchAndSavePlans({bool forceRefresh = false}) async {
    state = state.copyWith(isLoading: true);

    try {
      List<Plan> plans;

      plans = forceRefresh ? [] : await _db.getAllPlans();

      if (plans.isEmpty) {
        await _db.saveAllPlans(_staticPlans);
        plans = _staticPlans;
      }

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

const List<Plan> _staticPlans = [
  Plan(
    id: '6717d11b79e75220aa3293e1',
    name: 'Starter',
    entitlementId: 'starter',
    revenueCatProductId: 'starter',
    price: 0,
    currency: 'RON',
    isYearly: false,
    maxEvents: 3,
    maxMembers: 2,
    hasSongsAccess: true,
    hasAddSong: false,
    hasScreensSync: false,
    hasReminders: false,
  ),
  Plan(
    id: '670ff1b5e5844c1f35fd6536',
    name: 'Solo Monthly',
    entitlementId: 'solo',
    revenueCatProductId: 'onstage_solo_1m_1w0',
    price: 49.99,
    currency: 'RON',
    isYearly: false,
    maxEvents: 3,
    maxMembers: 2,
    hasSongsAccess: true,
    hasAddSong: false,
    hasScreensSync: false,
    hasReminders: false,
  ),
  Plan(
    id: '6719f82f7c7e4df7a01a8ead',
    name: 'Solo Yearly',
    entitlementId: 'solo',
    revenueCatProductId: 'onstage_solo_1y_1w0',
    price: 29.99,
    currency: 'RON',
    isYearly: true,
    maxEvents: 3,
    maxMembers: 2,
    hasSongsAccess: true,
    hasAddSong: false,
    hasScreensSync: false,
    hasReminders: false,
  ),
  Plan(
    id: '6714237379e75220aa3293dc',
    name: 'Pro Monthly',
    entitlementId: 'pro',
    revenueCatProductId: 'onstage_pro_1m_1m0',
    price: 79.99,
    currency: 'RON',
    isYearly: false,
    maxEvents: 10,
    maxMembers: 10,
    hasSongsAccess: true,
    hasAddSong: true,
    hasScreensSync: false,
    hasReminders: false,
  ),
  Plan(
    id: '6719f81f7c7e4df7a01a8eac',
    name: 'Pro Yearly',
    entitlementId: 'pro',
    revenueCatProductId: 'onstage_pro_1y_1m0',
    price: 59.99,
    currency: 'RON',
    isYearly: true,
    maxEvents: 10,
    maxMembers: 10,
    hasSongsAccess: true,
    hasAddSong: true,
    hasScreensSync: false,
    hasReminders: false,
  ),
  Plan(
    id: '6719f7827c7e4df7a01a8ea9',
    name: 'Ultimate Monthly',
    entitlementId: 'ultimate',
    revenueCatProductId: 'onstage_ultimate_1m_1m0',
    price: 129.99,
    currency: 'RON',
    isYearly: false,
    maxEvents: 30,
    maxMembers: 35,
    hasSongsAccess: true,
    hasAddSong: true,
    hasScreensSync: true,
    hasReminders: true,
  ),
  Plan(
    id: '6719f79d7c7e4df7a01a8eaa',
    name: 'Ultimate Yearly',
    entitlementId: 'ultimate',
    revenueCatProductId: 'onstage_ultimate_1y_1m0',
    price: 109.99,
    currency: 'RON',
    isYearly: true,
    maxEvents: 30,
    maxMembers: 35,
    hasSongsAccess: true,
    hasAddSong: true,
    hasScreensSync: true,
    hasReminders: true,
  ),
];
