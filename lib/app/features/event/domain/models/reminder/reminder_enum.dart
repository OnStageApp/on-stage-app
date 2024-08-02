enum ReminderEnum {
  none,
  fiveDaysBefore,
  threeDaysBefore,
  oneDayBefore,
  twoHoursBefore,
}

extension RemindersEnumExtension on ReminderEnum {
  String get name {
    switch (this) {
      case ReminderEnum.none:
        return 'None';
      case ReminderEnum.fiveDaysBefore:
        return '5 days before';
      case ReminderEnum.threeDaysBefore:
        return '3 days before';
      case ReminderEnum.oneDayBefore:
        return '1 day before';
      case ReminderEnum.twoHoursBefore:
        return '2 hours before';
    }
  }
}
