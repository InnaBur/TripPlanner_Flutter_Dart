class Trip {
  final String id;
  final String title;
  final String destination;
  final DateTime startDate;
  final DateTime endDate;
  final String imageUrl;
  final List<String> activities;

  Trip({
    required this.id,
    required this.title,
    required this.destination,
    required this.startDate,
    required this.endDate,
    this.imageUrl = '',
    this.activities = const [],
  });

  int get durationDays => endDate.difference(startDate).inDays + 1;

  bool get isUpcoming => startDate.isAfter(DateTime.now());
}