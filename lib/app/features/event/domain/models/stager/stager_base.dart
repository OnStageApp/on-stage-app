import 'dart:typed_data';

abstract class StagerBase {
  String get id;
  String? get name;
  String? get userId;
  String? get groupId;
  String? get positionId;
  Uint8List? get profilePicture;
}
