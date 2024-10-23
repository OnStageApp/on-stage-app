import 'package:logger/logger.dart';
import 'package:on_stage_app/app/database/app_database.dart';
import 'package:on_stage_app/app/features/plan/application/plan_state.dart';
import 'package:on_stage_app/app/features/plan/domain/plan.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'plan_service.g.dart';

@Riverpod(keepAlive: true)
class PlanService extends _$PlanService {
  final logger = Logger();

  AppDatabase get db => ref.read(databaseProvider);

  @override
  PlanState build() {
    logger.d('PlanNotifier: build() called');
    return const PlanState();
  }

  Future<void> fetchAndSavePlans({bool forceRefresh = false}) async {
    try {
      state = state.copyWith(isLoading: true);

      final localPlans = forceRefresh ? <Plan>[] : await db.getAllPlans();
      final plans = localPlans.isEmpty ? _staticPlans : localPlans;

      if (localPlans.isEmpty) {
        await db.saveAllPlans(_staticPlans);
      }

      state = state.copyWith(plans: plans);
      logger.i('Plans fetched and saved successfully');
    } catch (e) {
      logger.e('Error fetching and saving plans: $e');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<Plan?> getPlanById(String id) async {
    try {
      return await db.getPlanById(id);
    } catch (e) {
      logger.e('Error getting plan by ID: $e');
      return null;
    }
  }
}

const List<Plan> _staticPlans = [
  Plan(
    id: '3',
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
    id: '2',
    name: 'Starter',
    entitlementId: 'starter',
    revenueCatProductId: 'starter',
    price: 0,
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
    id: '1',
    name: 'Solo',
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
    id: '6714237379e75220aa3293dc',
    name: 'Pro',
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
    id: '1',
    name: 'Ultimate',
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
    id: '670ff1b5e5844c1f35fd6536',
    name: 'Solo',
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
    id: '1',
    name: 'Pro',
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
    id: '3',
    name: 'Ultimate',
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
