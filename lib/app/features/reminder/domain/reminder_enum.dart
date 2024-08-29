enum ReminderEnum {
  none,
  fiveDaysBefore,
  threeDaysBefore,
  oneDayBefore,
  twoHoursBefore,
}

extension RemindersEnumExtension on ReminderEnum {
  int get daysBeforeEvent {
    switch (this) {
      case ReminderEnum.none:
        return 0;
      case ReminderEnum.fiveDaysBefore:
        return 5;
      case ReminderEnum.threeDaysBefore:
        return 3;
      case ReminderEnum.oneDayBefore:
        return 1;
      case ReminderEnum.twoHoursBefore:
        return 0;
    }
  }

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
