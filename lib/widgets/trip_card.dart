import 'dart:io';

import 'package:flutter/material.dart';
import '../models/trip.dart';


class TripCard extends StatelessWidget {
  final Trip trip;
  final VoidCallback? onDelete;

  const TripCard({super.key, required this.trip, this.onDelete});

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';

  Color _statusColor() {
    if (trip.isOngoing) return const Color(0xFF4CAF50);
    if (trip.isUpcoming) return const Color(0xFF2196F3);
    return Colors.white38;
  }

  String _statusLabel() {
    if (trip.isOngoing) return 'Ongoing';
    if (trip.isUpcoming) return 'Upcoming';
    return 'Past';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onDelete != null
          ? () => _showDeleteDialog(context)
          : null,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xFF0F172A),
          border: Border.all(color: Colors.white.withOpacity(0.07)),
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Photo header ──
            _PhotoHeader(trip: trip),

            // ── Info section ──
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          trip.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 17,
                          ),
                        ),
                      ),
                      // Status badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _statusColor().withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: _statusColor().withOpacity(0.4)),
                        ),
                        child: Text(
                          _statusLabel(),
                          style: TextStyle(
                            color: _statusColor(),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          color: Colors.white38, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        trip.destination,
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // ── Dates row ──
                  Row(
                    children: [
                      _InfoChip(
                        icon: Icons.calendar_today_outlined,
                        label:
                        '${_formatDate(trip.startDate)} → ${_formatDate(trip.endDate)}',
                      ),
                      const SizedBox(width: 8),
                      _InfoChip(
                        icon: Icons.access_time_outlined,
                        label: '${trip.durationDays}d',
                      ),
                    ],
                  ),

                  // ── Activity tags ──
                  if (trip.activities.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: trip.activities
                          .map((a) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.07),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(a,
                            style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12)),
                      ))
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Delete trip?',
            style: TextStyle(color: Colors.white)),
        content: Text('Remove "${trip.title}"?',
            style: const TextStyle(color: Colors.white60)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel',
                  style: TextStyle(color: Colors.white54))),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                onDelete?.call();
              },
              child: const Text('Delete',
                  style: TextStyle(color: Colors.redAccent))),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Photo header — shows user's photo or network fallback
// ─────────────────────────────────────────────
class _PhotoHeader extends StatelessWidget {
  final Trip trip;
  const _PhotoHeader({required this.trip});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Image (local file takes priority over URL)
          if (trip.imagePath != null)
            Image.file(File(trip.imagePath!), fit: BoxFit.cover)
          else if (trip.imageUrl != null)
            Image.network(
              trip.imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _Placeholder(),
            )
          else
            _Placeholder(),

          // Bottom gradient
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 80,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    const Color(0xFF1A1A1A),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    color: Colors.white10,
    child: const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.photo_camera_outlined,
            color: Colors.white24, size: 40),
        SizedBox(height: 8),
        Text('No photo',
            style: TextStyle(color: Colors.white24, fontSize: 13)),
      ],
    ),
  );
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white38, size: 13),
        const SizedBox(width: 4),
        Text(label,
            style: const TextStyle(color: Colors.white54, fontSize: 12)),
      ],
    );
  }
}
