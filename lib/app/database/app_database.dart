import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/database/tables/plan_table.dart';
import 'package:on_stage_app/app/database/tables/profile_picture_table.dart';
import 'package:on_stage_app/app/database/tables/profile_picture_xl_table.dart';
import 'package:on_stage_app/app/database/tables/subscription_table.dart';
import 'package:on_stage_app/app/features/plan/domain/plan.dart';
import 'package:on_stage_app/app/features/subscription/domain/enum/subscription_status.dart';
import 'package:on_stage_app/app/features/subscription/domain/subscription.dart';
import 'package:on_stage_app/app/features/team_member/domain/team_member_photo/team_member_photo.dart';
import 'package:on_stage_app/logger.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

// Database provider
final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase.instance;
});

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    logger.i('Opening database');
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app_database.sqlite'));
    return NativeDatabase(file);
  });
}

@DriftDatabase(
  tables: [
    ProfilePictureTable,
    ProfilePictureXlTable,
    SubscriptionTable,
    PlanTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase._() : super(_openConnection());

  static final AppDatabase _instance = AppDatabase._();

  static AppDatabase get instance => _instance;

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          logger.i('Creating database tables...');
          // This will create all tables based on your @DriftDatabase tables list
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          logger.i('Upgrading database from $from to $to');
          // Add future migration code here when needed
        },
        beforeOpen: (details) async {
          logger.i('Opening database with version: ${details.versionNow}');
          // Enable foreign keys
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  // Modify your initDatabase method to ensure tables are created
  Future<void> initDatabase() async {
    try {
      logger.i('Initializing database...');
      // This will trigger the migration strategy if needed
      await customSelect('SELECT 1').get();

      logger.i('Database initialized successfully');
    } catch (e) {
      logger.e('Error initializing database: $e');
      rethrow;
    }
  }

  // Subscription

  Future<Subscription?> getCurrentSubscription() async {
    try {
      final tableData = await (select(subscriptionTable)
            ..orderBy([(t) => OrderingTerm.desc(t.startDate)])
            ..limit(1))
          .getSingleOrNull();

      return tableData?.toSubscription();
    } catch (e) {
      logger.e('Error getting current subscription from local storage', e);
      return null;
    }
  }

  Future<bool> saveSubscription(Subscription subscription) async {
    try {
      final dbExist = await checkDatabaseExists();
      print('DB Exist: $dbExist');
      await into(subscriptionTable).insertOnConflictUpdate(
        subscription.toTableCompanion(),
      );
      logger.i('Subscription saved successfully');
      return true;
    } catch (e) {
      logger.e('Error saving subscription to local storage', e);
      return false;
    }
  }

  Future<bool> checkDatabaseExists() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app_database.sqlite'));

    return await file.exists(); // Returns true if the database exists
  }

  Future<bool> updateSubscriptionStatus(
    String id,
    SubscriptionStatus status,
  ) async {
    try {
      final updatedCount = await (update(subscriptionTable)
            ..where((tbl) => tbl.id.equals(id)))
          .write(
        SubscriptionTableCompanion(
          status: Value(status.toJson()),
        ),
      );

      logger
          .i('Subscription status updated successfully to: ${status.toJson()}');
      return updatedCount > 0;
    } catch (e) {
      logger.e('Error updating subscription status to ${status.toJson()}', e);
      return false;
    }
  }

  // Plans
  Future<List<Plan>> getAllPlans() async {
    try {
      final results = await select(planTable).get();
      return results.map((plan) => plan.toPlan()).toList();
    } catch (e, s) {
      logger.e('Error getting all plans from local storage', e, s);
      return [];
    }
  }

  Future<Plan?> getPlanById(String id) async {
    try {
      final result = await (select(planTable)
            ..where((tbl) => tbl.id.equals(id)))
          .getSingleOrNull();

      return result?.toPlan();
    } catch (e) {
      logger.e('Error getting plan by ID from local storage', e);
      return null;
    }
  }

  Future<bool> savePlan(Plan plan) async {
    try {
      await into(planTable).insertOnConflictUpdate(
        plan.toTableCompanion(),
      );
      logger.i('Plan saved successfully');
      return true;
    } catch (e) {
      logger.e('Error saving plan to local storage', e);
      return false;
    }
  }

  Future<bool> updatePlan(Plan plan) async {
    try {
      final updatedCount = await (update(planTable)
            ..where((tbl) => tbl.id.equals(plan.id)))
          .write(plan.toTableCompanion());

      logger.i('Plan updated successfully');
      return updatedCount > 0;
    } catch (e) {
      logger.e('Error updating plan in local storage', e);
      return false;
    }
  }

  Future<bool> deletePlan(String id) async {
    try {
      final deletedCount =
          await (delete(planTable)..where((tbl) => tbl.id.equals(id))).go();

      logger.i('Plan deleted successfully');
      return deletedCount > 0;
    } catch (e) {
      logger.e('Error deleting plan from local storage', e);
      return false;
    }
  }

  Future<bool> saveAllPlans(List<Plan> plans) async {
    try {
      await batch((batch) {
        batch.insertAllOnConflictUpdate(
          planTable,
          plans.map((plan) => plan.toTableCompanion()).toList(),
        );
      });
      logger.i('All plans saved successfully');
      return true;
    } catch (e) {
      logger.e('Error saving all plans to local storage', e);
      return false;
    }
  }

  // User Profile

  Future<Uint8List?> getUserProfilePicture(String id) async {
    final result = await (select(profilePictureXlTable)
          ..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
    return result?.picture;
  }

  Future<int> updateUserProfilePicture(String id, Uint8List picture) async {
    return (update(profilePictureTable)..where((tbl) => tbl.id.equals(id)))
        .write(
      ProfilePictureTableCompanion(
        picture: Value(picture),
      ),
    );
  }

  Future<TeamMemberPhoto?> getTeamMemberPhoto(String id) async {
    final result = await (select(profilePictureTable)
          ..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
    if (result != null) {
      return TeamMemberPhoto(userId: result.id, profilePicture: result.picture);
    }
    return null;
  }

  Future<int> insertTeamMemberPhoto(TeamMemberPhoto photo) {
    return into(profilePictureTable).insert(
      ProfilePictureTableCompanion.insert(
        id: photo.userId,
        picture: Value(photo.profilePicture),
      ),
    );
  }

  Future<bool> updateTeamMemberPhoto(TeamMemberPhoto photo) async {
    return await (update(profilePictureTable)
              ..where((tbl) => tbl.id.equals(photo.userId)))
            .write(ProfilePictureTableCompanion(
          picture: Value(photo.profilePicture),
        )) >
        0;
  }

  Future<int> deleteTeamMemberPhoto(String id) {
    return (delete(profilePictureTable)..where((tbl) => tbl.id.equals(id)))
        .go();
  }

  Future<void> deleteDatabase() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app_database.sqlite'));

    if (await file.exists()) {
      await file.delete();
      logger.i('Database deleted successfully');
    } else {
      logger.w('Database file does not exist');
    }
  }

  Future<void> clearDatabase() async {
    try {
      await transaction(() async {
        // Clear all tables
        await delete(planTable).go();
        await delete(subscriptionTable).go();
        await delete(profilePictureTable).go();
        await delete(profilePictureXlTable).go();

        logger.i('All tables cleared successfully');
      });
    } catch (e) {
      logger.e('Error clearing database: $e');
      rethrow;
    }
  }
}
