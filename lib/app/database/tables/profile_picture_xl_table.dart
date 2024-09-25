import 'package:drift/drift.dart';

class ProfilePictureXlTable extends Table {
  TextColumn get id => text()();
  BlobColumn get picture => blob().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
