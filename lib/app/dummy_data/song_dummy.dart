import 'package:on_stage_app/app/features/notifications/domain/models/stage_notification_model.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_model.dart';

class SongDummy {
  static const notificationsDummy = <StageNotification>[
    //fill with dummy data
    StageNotification(
      id: 1,
      title:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit Lorem ipsum dolor sit amet, consectetur adipiscing elit Ready to go live?',
      body:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit Lorem ipsum dolor sit amet, consectetur adipiscing elit8:00 PM',
      createdAt: 'today',
    ),
    StageNotification(
      id: 1,
      title: 'Friend Request',
      body: 'David sent you a friend request',
      createdAt: 'today',
    ),
    StageNotification(
      id: 1,
      title: 'Ready to go live?',
      body: '8:00 PM',
      createdAt: 'today',
    ),
    StageNotification(
      id: 1,
      title: 'Ready to go live?',
      body: '8:00 PM',
      createdAt: 'today',
    ),
    StageNotification(
      id: 1,
      title: 'Friend Request',
      body: '8:00 PM',
      createdAt: 'today',
    ),
    StageNotification(
      id: 1,
      title: 'Ready to go live?',
      body: '8:00 PM',
      createdAt: 'today',
    ),
  ];

  // static const List<SongModel> songs = [
  //   SongModel(
  //     id: 1,
  //     title: 'Nu e munte prea mare',
  //     lyrics: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
  //     tab: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
  //     key: 'C# M',
  //     createdAt: '2021-08-01T00:00:00.000Z',
  //     updatedAt: '2021-08-01T00:00:00.000Z',
  //     artist: Artist(
  //       id: 1,
  //       fullName: 'BBSO',
  //       songIds: [1, 2],
  //       imageUrl: 'assets/images/band1.png',
  //     ),
  //     album: 'Tabara 477',
  //     capo: 1,
  //   ),
  //   //add more of these
  //   SongModel(
  //     id: 2,
  //     title: 'Ala bala portocala',
  //     lyrics: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
  //     tab: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
  //     key: 'C#',
  //     createdAt: '2021-08-01T00:00:00.000Z',
  //     updatedAt: '2021-08-01T00:00:00.000Z',
  //     artist: Artist(id: 1, fullName: 'Tabara 477', songIds: [1, 2]),
  //     album: 'Tabara 477',
  //     capo: 1,
  //   ),
  //   SongModel(
  //     id: 3,
  //     title: 'Isus e Rege',
  //     lyrics: 'Ana are mere si pere',
  //     tab: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
  //     key: 'c#m',
  //     createdAt: '2021-08-01T00:00:00.000Z',
  //     updatedAt: '2021-08-01T00:00:00.000Z',
  //     artist: Artist(
  //       id: 1,
  //       fullName: 'Alin si Emima',
  //       songIds: [1, 2],
  //       imageUrl: 'assets/images/band3.png',
  //     ),
  //     capo: 1,
  //   ),
  //   SongModel(
  //     id: 4,
  //     title: 'Soarele neprihanirii',
  //     lyrics: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
  //     tab: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
  //     key: 'C#',
  //     createdAt: '2021-08-01T00:00:00.000Z',
  //     updatedAt: '2021-08-01T00:00:00.000Z',
  //     artist: Artist(id: 1, fullName: 'El Shaddai', songIds: [1, 2]),
  //     album: 'Tabara 477',
  //     capo: 1,
  //   ),
  //   SongModel(
  //     id: 5,
  //     title: 'Astazi e craciun',
  //     lyrics: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
  //     tab: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
  //     key: 'Ab',
  //     createdAt: '2021-08-01T00:00:00.000Z',
  //     updatedAt: '2021-08-01T00:00:00.000Z',
  //     artist: Artist(
  //       id: 1,
  //       fullName: 'Boboc',
  //       songIds: [1, 2],
  //       imageUrl: 'assets/images/band1.png',
  //     ),
  //     album: 'Tabara 477',
  //     capo: 1,
  //   ),
  //   SongModel(
  //     id: 6,
  //     title: 'Yahweh se manifesta',
  //     lyrics: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
  //     tab: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
  //     key: 'A',
  //     createdAt: '2021-08-01T00:00:00.000Z',
  //     updatedAt: '2021-08-01T00:00:00.000Z',
  //     artist: Artist(id: 1, fullName: 'Test 123', songIds: [1, 2]),
  //     album: 'Tabara 477',
  //     capo: 1,
  //   ),
  //   SongModel(
  //     id: 7,
  //     title: 'Soarele neprihanirii',
  //     lyrics: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
  //     tab: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
  //     key: 'em',
  //     createdAt: '2021-08-01T00:00:00.000Z',
  //     updatedAt: '2021-08-01T00:00:00.000Z',
  //     artist: Artist(
  //       id: 1,
  //       fullName: 'Harvest Arad',
  //       songIds: [1, 2],
  //       imageUrl: 'assets/images/band2.png',
  //     ),
  //     album: 'Tabara 477',
  //     capo: 1,
  //   ),
  //   SongModel(
  //     id: 8,
  //     title: 'Eu sunt mic, dar Isus',
  //     lyrics: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
  //     tab: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
  //     key: 'C# major',
  //     createdAt: '2021-08-01T00:00:00.000Z',
  //     updatedAt: '2021-08-01T00:00:00.000Z',
  //     artist: Artist(id: 1, fullName: 'Tabara 477', songIds: [1, 2]),
  //     album: 'Tabara 477',
  //     capo: 1,
  //   ),
  // ];

  static const List<SongModel> playlist = [
    SongModel(
      id: "8",
      title: 'Eu sunt mic, dar Isus',
      lyrics: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
      tab: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
      key: 'C# major',
      createdAt: '2021-08-01T00:00:00.000Z',
      updatedAt: '2021-08-01T00:00:00.000Z',
      artist: 'artist1',
      album: 'Tabara 477',
      capo: 1,
    ),
  ];
}
