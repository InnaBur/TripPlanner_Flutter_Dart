class Place {
  final String id;
  final String name;
  final String description;
  final double latitude;
  final double longitude;
  final String category;
  final double rating;
  final String? imagePath; // local image chosen by user
  final String? imageUrl;
  final String? address;
  final List<String> tags;

  Place({
    required this.id,
    required this.name,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.category,
    this.rating = 0.0,
    this.imagePath,
    this.imageUrl,
    this.address,
    this.tags = const [],
  });
}
