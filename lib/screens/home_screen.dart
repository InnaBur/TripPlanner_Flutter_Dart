import 'package:flutter/material.dart';
import '../models/trip.dart';
import '../widgets/trip_card.dart';
import 'add_trip_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Тестові дані (потім замінимо базою даних)
  final List<Trip> _trips = [
    Trip(
      id: '1',
      title: 'Відпустка в Відні',
      destination: 'Відень, Австрія',
      startDate: DateTime(2025, 7, 10),
      endDate: DateTime(2025, 7, 17),
      activities: ['Музеї', 'Опера', 'Кофейні'],
    ),
    Trip(
      id: '2',
      title: 'Вікенд у Зальцбурзі',
      destination: 'Зальцбург, Австрія',
      startDate: DateTime(2025, 8, 2),
      endDate: DateTime(2025, 8, 4),
      activities: ['Фортеця', 'Mozart museum'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Красивий заголовок що зникає при скролі
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'TripPlanner ✈️',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF2E86AB), Color(0xFF1B4F72)],
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.flight_takeoff,
                    size: 80,
                    color: Colors.white30,
                  ),
                ),
              ),
            ),
          ),

          // Привітання
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Привіт, мандрівнику! 👋',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Куди вирушаємо наступного разу?',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Статистика
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _StatCard(
                    icon: Icons.luggage,
                    label: 'Подорожей',
                    value: '${_trips.length}',
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 12),
                  _StatCard(
                    icon: Icons.calendar_today,
                    label: 'Найближча',
                    value: _trips.isNotEmpty ? 'Незабаром' : 'Немає',
                    color: Colors.orange,
                  ),
                ],
              ),
            ),
          ),

          // Заголовок списку
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Text(
                'Мої подорожі',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Список подорожей
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) => TripCard(trip: _trips[index]),
              childCount: _trips.length,
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final newTrip = await Navigator.push<Trip>(
            context,
            MaterialPageRoute(builder: (_) => const AddTripScreen()),
          );
          if (newTrip != null) {
            setState(() => _trips.add(newTrip));
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Нова подорож'),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: color)),
                Text(label,
                    style:
                    TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
          ],
        ),
      ),
    );
  }
}