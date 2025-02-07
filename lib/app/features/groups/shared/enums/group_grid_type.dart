enum GroupGridType {
  event,
  eventTemplate;

  static GroupGridType fromIds({
    required String? eventId,
    required String? eventTemplateId,
  }) {
    if (eventId != null) return GroupGridType.event;
    if (eventTemplateId != null) return GroupGridType.eventTemplate;
    throw ArgumentError('Either eventId or eventTemplateId must be provided');
  }
}
