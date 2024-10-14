import 'package:freezed_annotation/freezed_annotation.dart';

part 'artist_request.freezed.dart';
part 'artist_request.g.dart';

@Freezed()
class ArtistRequest with _$ArtistRequest {
  const factory ArtistRequest({
    required String name,
  }) = _ArtistRequest;

  factory ArtistRequest.fromJson(Map<String, dynamic> json) =>
      _$ArtistRequestFromJson(json);
}
