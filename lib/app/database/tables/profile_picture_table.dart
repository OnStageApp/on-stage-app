import 'package:drift/drift.dart';

class ProfilePictureTable extends Table {
  TextColumn get id => text()();
  BlobColumn get picture => blob().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
