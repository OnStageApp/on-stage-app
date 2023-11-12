import 'package:freezed_annotation/freezed_annotation.dart';

part 'artist_model.freezed.dart';
part 'artist_model.g.dart';

@Freezed()
class Artist with _$Artist {
  const factory Artist({
    required int id,
    required String fullName,
    required List<int> songIds,
    String? imageUrl,
  }) = _Artist;

  factory Artist.fromJson(Map<String, dynamic> json) => _$ArtistFromJson(json);
}
