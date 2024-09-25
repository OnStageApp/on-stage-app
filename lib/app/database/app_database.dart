import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/database/tables/profile_picture_table.dart';
import 'package:on_stage_app/app/database/tables/profile_picture_xl_table.dart';
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

@DriftDatabase(tables: [ProfilePictureTable, ProfilePictureXlTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase._() : super(_openConnection());

  static final AppDatabase _instance = AppDatabase._();

  static AppDatabase get instance => _instance;

  @override
  int get schemaVersion => 1;

  Future<bool> testConnection() async {
    try {
      // Perform a simple query
      await customSelect('SELECT 1').getSingle();
      logger.i('Database connection test successful');
      return true;
    } catch (e) {
      logger.e('Database connection test failed', e);
      return false;
    }
  }

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
}
