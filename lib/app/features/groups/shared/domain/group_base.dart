import 'package:flutter/foundation.dart';

abstract class GroupBase {
  String get id;

  String get name;

  int get membersCount;

  List<String>? get stagersWithPhoto;

  List<Uint8List>? get profilePictures;
}
