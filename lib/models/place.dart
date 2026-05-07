class Place {
  final String id;
  final String name;
  final String description;
  final double latitude;
  final double longitude;
  final String category; // 'hidden_gem', 'restaurant', 'museum'
  final double rating;
  final String imageUrl;

  Place({
    required this.id,
    required this.name,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.category,
    this.rating = 0.0,
    this.imageUrl = '',
  });
}