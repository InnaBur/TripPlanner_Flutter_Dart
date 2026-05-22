class Trip {
  final String id;
  final String title;
  final String destination;
  final DateTime startDate;
  final DateTime endDate;
  final String? imagePath; // local file path chosen by user
  final String? imageUrl;  // network fallback
  final List<String> activities;
  final String? notes;

  Trip({
    required this.id,
    required this.title,
    required this.destination,
    required this.startDate,
    required this.endDate,
    this.imagePath,
    this.imageUrl,
    this.activities = const [],
    this.notes,
  });

  int get durationDays => endDate.difference(startDate).inDays + 1;
  bool get isUpcoming => startDate.isAfter(DateTime.now());
  bool get isOngoing =>
      startDate.isBefore(DateTime.now()) && endDate.isAfter(DateTime.now());
}