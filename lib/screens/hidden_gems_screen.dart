import 'package:flutter/material.dart';
import '../models/place.dart';

class HiddenGemsScreen extends StatelessWidget {
  const HiddenGemsScreen({super.key});

  // Тестові дані прихованих місць
  static final List<Place> _gems = [
    Place(
      id: '1',
      name: 'Секретний сад у Граці',
      description: 'Маленький сад у центрі міста, відомий лише місцевим.',
      latitude: 47.0707,
      longitude: 15.4395,
      category: 'hidden_gem',
      rating: 4.8,
    ),
    Place(
      id: '2',
      name: 'Стара кав\'ярня 1890',
      description: 'Найстаріша кав\'ярня у місті з оригінальним інтер\'єром.',
      latitude: 47.0710,
      longitude: 15.4400,
      category: 'restaurant',
      rating: 4.6,
    ),
    Place(
      id: '3',
      name: 'Підземний музей',
      description: 'Невідомий більшості туристів підземний музей історії.',
      latitude: 47.0720,
      longitude: 15.4410,
      category: 'museum',
      rating: 4.9,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hidden Gems 💎'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _gems.length,
        itemBuilder: (context, index) {
          final place = _gems[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor:
                Theme.of(context).colorScheme.primaryContainer,
                child: const Icon(Icons.diamond),
              ),
              title: Text(
                place.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(place.description),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      Text(' ${place.rating}'),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}