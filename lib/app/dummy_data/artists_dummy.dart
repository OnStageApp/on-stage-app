
import 'package:on_stage_app/app/features/artist/domain/models/artist_model.dart';

class ArtistsDummy {
  static List<Artist> artists = [
    const Artist(
      id: 1,
      fullName: 'BBSO',
      songIds: [1, 2, 3],
      imageUrl: 'assets/images/band1.png',
    ),
    const Artist(
      id: 2,
      fullName: 'Tabara 477',
      songIds: [4, 5, 6],
      imageUrl: 'assets/images/band2.png',
    ),
    const Artist(
      id: 3,
      fullName: 'El-Shaddai',
      songIds: [7, 8, 9],
      imageUrl: 'assets/images/band3.png',
    ),
    const Artist(
      id: 4,
      fullName: 'Hillsong',
      songIds: [10, 11, 12],
      imageUrl: 'assets/images/profile5.png',
    ),
  ];
}