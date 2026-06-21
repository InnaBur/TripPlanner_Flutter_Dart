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
      title: 'Venice Trip',
      destination: 'Venice, Italy',
      startDate: DateTime(2026, 4, 1),
      endDate: DateTime(2026, 4, 3),
      imageUrl: 'assets/trips/img19.jpg',
      activities: ['Palazzo Contarini del Bovolo', 'Gondola', 'St. Mark\'s Square'],
    ),
    Trip(
      id: '2',
      title: 'Castle in Slovenia',
      destination: 'Gornja Radgona, Slovenia',
      startDate: DateTime(2026, 5, 31),
      endDate: DateTime(2026, 5, 31),
      imageUrl: 'assets/trips/img25.jpg',
      activities: ['Schloss Oberradkersburg', 'Castle tour'],
    ),
    Trip(
      id: '3',
      title: 'Eisenerz',
      destination: 'Eisenerz, Austria',
      startDate: DateTime(2025, 9, 15),
      endDate: DateTime(2025, 9, 15),
      imageUrl: 'assets/trips/img16.jpg',
      activities: ['Erzberg', 'Mining history'],
    ),
  ];

  // Background mosaic photos (travel themed from Unsplash)
  final List<String> _bgPhotos = [
    'assets/images/img11.jpg',
    'assets/images/img5.jpg',
    'assets/images/img6.jpg',
    'assets/images/img7.jpg',
    'assets/images/img8.jpg',
    'assets/images/img9.jpg',
    'assets/images/img10.jpg',
    'assets/images/bg.jpg',
    'assets/images/img12.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // GEÄNDERT: Hintergrund von Dunkel auf helles Grau/Slate gewechselt
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          // ── Hero header with photo mosaic background ──
          SliverAppBar(
            expandedHeight: 380,
            pinned: true,
            // GEÄNDERT: Hintergrund an App-Hintergrund angepasst
            backgroundColor: const Color(0xFFF8FAFC),
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
                      // GEÄNDERT: Textfarbe auf dunkles Slate für lesbaren Kontrast
                      color: const Color(0xFF1E293B),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_trips.length} trips planned · ${_trips.where((t) => t.isUpcoming).length} upcoming',
                    style: const TextStyle(
                      fontSize: 14,
                      // GEÄNDERT: Subtext lesbar abgedunkelt
                      color: Color(0xFF64748B),
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
                      // GEÄNDERT: Überschrift dunkel gefärbt
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'See all',
                      // GEÄNDERT: Textbutton-Farbe angepasst
                      style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
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
            // GEÄNDERT: Von 0.75 auf 1.15 gestellt, damit alle 9 Bilder perfekt hineinpassen
            childAspectRatio: 1.42,
          ),
          itemCount: photos.length,
          itemBuilder: (_, i) => Image.asset(
            photos[i],
            fit: BoxFit.cover,
          ),
        ),

        // Helles Gradient-Overlay für optimale Lesbarkeit im Light Mode
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.white.withOpacity(0.15),
                const Color(0xFFF8FAFC),
              ],
              stops: const [0.0, 0.7, 1.0],
            ),
          ),
        ),

        // Center logo / branding
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 40,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // GEÄNDERT: Icon-Farbe auf Dunkelgrau gesetzt
              const Icon(Icons.flight_takeoff, color: Color(0xFF1E293B), size: 40),
              const SizedBox(height: 8),
              Text(
                'TripPlanner',
                style: TextStyle(
                  // GEÄNDERT: Textfarbe auf edles, dunkles Slate umgestellt
                  color: const Color(0xFFFFFFFF),
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                  shadows: [
                    Shadow(
                      // GEÄNDERT: Weicher, weißer Schatten für optimale Lesbarkeit auf Bildern
                      color: Colors.white.withOpacity(0.8),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Your world, planned',
                style: TextStyle(
                  // GEÄNDERT: Slogan-Farbe lesbar angepasst
                  color: Color(0xFFFFFFFF),
                  fontSize: 14,
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.w500,
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
          // GEÄNDERT: Weißer Kachel-Hintergrund für den hellen "Card-Look"
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          // GEÄNDERT: Subtiler Rahmen und cleaner Schatten-Effekt
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // GEÄNDERT: Icon-Farbe abgedunkelt
            Icon(icon, color: const Color(0xFF64748B), size: 16),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    style: const TextStyle(
                      // GEÄNDERT: Zahlen-Farbe abgedunkelt
                        color: Color(0xFF1E293B),
                        fontWeight: FontWeight.w700,
                        fontSize: 15)),
                Text(label,
                    style: const TextStyle(
                      // GEÄNDERT: Label-Farbton angepasst
                        color: Color(0xFF94A3B8), fontSize: 11)),
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
      // GEÄNDERT: Invertierter, dunkler Button-Stil als eleganter Akzent
      backgroundColor: const Color(0xFF1E293B),
      foregroundColor: Colors.white,
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