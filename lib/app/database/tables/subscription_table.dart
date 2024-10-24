import 'package:drift/drift.dart';
import 'package:on_stage_app/app/database/app_database.dart';
import 'package:on_stage_app/app/features/subscription/domain/enum/subscription_status.dart';
import 'package:on_stage_app/app/features/subscription/domain/subscription.dart';

class SubscriptionTable extends Table {
  TextColumn get id => text()();

  TextColumn get teamId => text()();

  TextColumn get userId => text()();

  TextColumn get planId => text()();

  TextColumn get status => text()();

  DateTimeColumn? get startDate => dateTime()();

  TextColumn get type => text()();

  DateTimeColumn? get endDate => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

extension SubscriptionTableDataX on SubscriptionTableData {
  Subscription toSubscription() {
    return Subscription(
      id: id,
      teamId: teamId,
      userId: userId,
      planId: planId,
      status: SubscriptionStatusX.fromJson(status),
      purchaseDate: startDate,
      expiryDate: endDate,
    );
  }
}

extension SubscriptionX on Subscription {
  SubscriptionTableCompanion toTableCompanion() {
    return SubscriptionTableCompanion.insert(
      id: id,
      teamId: teamId,
      userId: userId,
      planId: planId,
      status: status.toJson(),
      startDate: purchaseDate ?? DateTime.now(),
      endDate: expiryDate ?? DateTime.now(),
      type: 'Subscription',
    );
  }
}
