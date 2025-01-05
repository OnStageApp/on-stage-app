// // song_table.dart
// import 'dart:convert';
//
// import 'package:drift/drift.dart';
// import 'package:on_stage_app/app/database/app_database.dart';
// import 'package:on_stage_app/app/features/song/domain/enums/structure_item.dart';
// import 'package:on_stage_app/app/features/song/domain/models/raw_section.dart';
// import 'package:on_stage_app/app/features/song/domain/models/song_model_v2.dart';
// import 'package:on_stage_app/app/features/song/domain/models/tonality/song_key.dart';
//
// class SongTable extends Table {
//   // Using .nullable() for columns that can be null
//   // If your 'id' should always be set, remove .nullable().
//   TextColumn get id => text().nullable()();
//
//   TextColumn get title => text().nullable()();
//
//   // We'll store the list of RawSection as JSON
//   TextColumn get rawSectionsJson => text().nullable()();
//
//   // We'll store the list of StructureItem as JSON
//   TextColumn get structureJson => text().nullable()();
//
//   IntColumn get tempo => integer().nullable()();
//
//   // We'll store the SongKey object as JSON (originalKey)
//   TextColumn get originalKeyJson => text().nullable()();
//
//   // We'll store the transposed SongKey as JSON (key)
//   TextColumn get keyJson => text().nullable()();
//
//   TextColumn get createdAt => text().nullable()();
//
//   TextColumn get updatedAt => text().nullable()();
//
//   TextColumn get teamId => text().nullable()();
//
//   @override
//   Set<Column> get primaryKey => {id};
// }
//
// extension SongTableDataX on SongTableData {
//   SongModelV2 toSongModelV2() {
//     return SongModelV2(
//       id: id,
//       title: title,
//       rawSections: _decodeRawSections(rawSectionsJson),
//       structure: _decodeStructure(structureJson),
//       tempo: tempo,
//       originalKey: _decodeSongKey(originalKeyJson),
//       key: _decodeSongKey(keyJson),
//       createdAt: createdAt,
//       updatedAt: updatedAt,
//       teamId: teamId,
//     );
//   }
//
//   /// Helper methods to decode each field
//
//   List<RawSection>? _decodeRawSections(String? jsonString) {
//     if (jsonString == null) return null;
//     final rawList = jsonDecode(jsonString) as List<dynamic>;
//     return rawList
//         .map((item) => RawSection.fromJson(item as Map<String, dynamic>))
//         .toList();
//   }
//
//   List<StructureItem>? _decodeStructure(String? jsonString) {
//     if (jsonString == null) return null;
//     final rawList = jsonDecode(jsonString) as List<dynamic>;
//     return rawList
//         .map((item) => StructureItemExtension.fromJson(item as String))
//         .toList();
//   }
//
//   SongKey? _decodeSongKey(String? jsonString) {
//     if (jsonString == null) return null;
//     final decoded = jsonDecode(jsonString);
//     return SongKey.fromJson(decoded as Map<String, dynamic>);
//   }
// }
//
// /// Extend `SongModelV2` to create a companion that can be inserted/updated
// extension SongModelV2X on SongModelV2 {
//   SongTableCompanion toTableCompanion() {
//     return SongTableCompanion(
//       id: Value(id),
//       title: Value(title),
//       rawSectionsJson: Value(_encodeRawSections(rawSections)),
//       structureJson: Value(_encodeStructure(structure)),
//       tempo: Value(tempo),
//       originalKeyJson: Value(_encodeSongKey(originalKey)),
//       keyJson: Value(_encodeSongKey(key)),
//       createdAt: Value(createdAt),
//       updatedAt: Value(updatedAt),
//       teamId: Value(teamId),
//     );
//   }
//
//   /// Helper methods to encode each field
//
//   String? _encodeRawSections(List<RawSection>? sections) {
//     if (sections == null) return null;
//     return jsonEncode(sections.map((s) => s.toJson()).toList());
//   }
//
//   String? _encodeStructure(List<StructureItem>? items) {
//     if (items == null) return null;
//     return jsonEncode(items.map((i) => i.toJson()).toList());
//   }
//
//   String? _encodeSongKey(SongKey? songKey) {
//     if (songKey == null) return null;
//     return jsonEncode(songKey.toJson());
//   }
// }
