import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:on_stage_app/app/features/song/domain/models/song_model.dart';
import 'package:on_stage_app/app/utils/api.dart';
import 'package:on_stage_app/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'song_repository.g.dart';

@riverpod
class SongRepository extends _$SongRepository {
  @override
  FutureOr build() {}

  Future<List<SongModel>> getSongs({
    String? search,
  }) async {
    try {
      final uri = API.getSongs(search);
      final response = await http.get(uri);

      logger.fetchedRequestResponse(
        'songs',
        response.statusCode,
        response.body,
      );

      switch (response.statusCode) {
        case 200:
          final songsJson = jsonDecode(response.body) as List<dynamic>;
          final songs = songsJson
              .map(
                (songJson) => SongModel.fromJson(
                  songJson as Map<String, dynamic>,
                ),
              )
              .toList();

          return songs;
        default:
          logger.e('Internal server error, please try again later.');
          break;
      }
    } on HttpException catch (e, s) {
      logger.e('Failed fetching songs: $e with stacktrace: $s');
    }
    return [];
  }
}
