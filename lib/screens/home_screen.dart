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
  final List<Trip> _trips = [
    Trip(
      id: '1',
      title: 'Weekend in Vienna',
      destination: 'Vienna, Austria',
      startDate: DateTime(2025, 7, 10),
      endDate: DateTime(2025, 7, 17),
      imageUrl: 'https://images.unsplash.com/photo-1516550893923-42d28e5677af?w=800',
      activities: ['Museums', 'Opera', 'Coffee Houses'],
    ),
    Trip(
      id: '2',
      title: 'Salzburg Day Trip',
      destination: 'Salzburg, Austria',
      startDate: DateTime(2025, 8, 2),
      endDate: DateTime(2025, 8, 4),
      imageUrl: 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800',
      activities: ['Fortress', 'Mozart Museum'],
    ),
    Trip(
      id: '3',
      title: 'Italian Escape',
      destination: 'Rome, Italy',
      startDate: DateTime(2025, 9, 15),
      endDate: DateTime(2025, 9, 22),
      imageUrl: 'https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=800',
      activities: ['Colosseum', 'Vatican', 'Trastevere'],
    ),
  ];

  // Background mosaic photos (travel themed from Unsplash)
  final List<String> _bgPhotos = [
    'https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?w=400',
    'https://images.unsplash.com/photo-1530521954074-e64f6810b32d?w=400',
    'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=400',
    'https://images.unsplash.com/photo-1493246507139-91e8fad9978e?w=400',
    'https://images.unsplash.com/photo-1504609813442-a8924e83f76e?w=400',
    'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?w=400',
    'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=400',
    'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?w=400',
    'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=400',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: CustomScrollView(
        slivers: [
          // ── Hero header with photo mosaic background ──
          SliverAppBar(
            expandedHeight: 380,
            pinned: true,
            backgroundColor: const Color(0xFF0D0D0D),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: _HeroMosaic(photos: _bgPhotos),
            ),
          ),

          // ── Greeting ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Where to next?',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_trips.length} trips planned · ${_trips.where((t) => t.isUpcoming).length} upcoming',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Quick stats row ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Row(
                children: [
                  _StatPill(
                    icon: Icons.flight_takeoff,
                    label: 'Trips',
                    value: '${_trips.length}',
                  ),
                  const SizedBox(width: 10),
                  _StatPill(
                    icon: Icons.calendar_today,
                    label: 'Upcoming',
                    value: '${_trips.where((t) => t.isUpcoming).length}',
                  ),
                  const SizedBox(width: 10),
                  _StatPill(
                    icon: Icons.place,
                    label: 'Countries',
                    value: '2',
                  ),
                ],
              ),
            ),
          ),

          // ── Section title ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'My Trips',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'See all',
                      style: TextStyle(color: Colors.white54, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Trip cards ──
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) => TripCard(
                trip: _trips[index],
                onDelete: () => setState(() => _trips.removeAt(index)),
              ),
              childCount: _trips.length,
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),

      floatingActionButton: _AddTripFab(
        onAdd: (trip) => setState(() => _trips.add(trip)),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Hero mosaic of travel photos
// ─────────────────────────────────────────────
class _HeroMosaic extends StatelessWidget {
  final List<String> photos;
  const _HeroMosaic({required this.photos});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Grid of photos
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
            childAspectRatio: 0.75,
          ),
          itemCount: photos.length,
          itemBuilder: (_, i) => Image.network(
            photos[i],
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: Colors.white10,
              child: const Icon(Icons.photo, color: Colors.white24),
            ),
          ),
        ),

        // Dark gradient overlay so text is readable
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.black.withOpacity(0.5),
                const Color(0xFF0D0D0D),
              ],
              stops: const [0.0, 0.6, 1.0],
            ),
          ),
        ),

        // Center logo / branding
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 60,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.flight_takeoff, color: Colors.white, size: 40),
              const SizedBox(height: 8),
              Text(
                'TripPlanner',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                  shadows: [
                    Shadow(
                      color: Colors.black54,
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Your world, planned.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Small stat pill
// ─────────────────────────────────────────────
class _StatPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatPill({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white60, size: 16),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 15)),
                Text(label,
                    style: const TextStyle(
                        color: Colors.white38, fontSize: 11)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// FAB for adding a trip
// ─────────────────────────────────────────────
class _AddTripFab extends StatelessWidget {
  final void Function(Trip) onAdd;
  const _AddTripFab({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      onPressed: () async {
        final trip = await Navigator.push<Trip>(
          context,
          MaterialPageRoute(builder: (_) => const AddTripScreen()),
        );
        if (trip != null) onAdd(trip);
      },
      icon: const Icon(Icons.add),
      label: const Text('New Trip',
          style: TextStyle(fontWeight: FontWeight.w700)),
    );
  }
}
