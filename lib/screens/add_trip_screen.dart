import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/trip.dart';

class AddTripScreen extends StatefulWidget {
  const AddTripScreen({super.key});


  @override
  State<AddTripScreen> createState() => _AddTripScreenState();
}

class _AddTripScreenState extends State<AddTripScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _destinationCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  final _activityCtrl = TextEditingController();


  DateTime _startDate = DateTime.now().add(const Duration(days: 7));
  DateTime _endDate = DateTime.now().add(const Duration(days: 14));
  String? _imagePath;
  final List<String> _activities = [];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _destinationCtrl.dispose();
    _notesCtrl.dispose();
    _activityCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final result = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1200,
    );
    if (result != null) setState(() => _imagePath = result.path);
  }

  Future<void> _pickDate({required bool isStart}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF1E293B), // Slate-Dunkelgrau für ausgewählte Tage
            onPrimary: Colors.white,
            surface: Colors.white, // Weißer Hintergrund für den Kalender
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_endDate.isBefore(_startDate)) {
            _endDate = _startDate.add(const Duration(days: 7));
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _addActivity() {
    final text = _activityCtrl.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _activities.add(text);
        _activityCtrl.clear();
      });
    }
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final trip = Trip(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleCtrl.text.trim(),
        destination: _destinationCtrl.text.trim(),
        startDate: _startDate,
        endDate: _endDate,
        imagePath: _imagePath,
        activities: List.from(_activities),
        notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
      );
      Navigator.pop(context, trip);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('New Trip',
            style: TextStyle(
                color: Color(0xFF1E293B), fontWeight: FontWeight.w700)), // Dunkler Text
        backgroundColor: const Color(0xFFF8FAFC), // Gleicher heller Hintergrund wie das Scaffold
        elevation: 0, // Entfernt harten Schatten für einen cleanen Look
        iconTheme: const IconThemeData(color: Color(0xFF1E293B)), // Dunkler Zurück-Pfeil
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text('Save',
                style: TextStyle(
                    color: Color(0xFF1E293B), fontWeight: FontWeight.w700)),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // ── Photo picker ──
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white, // Weißer Hintergrund
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: const Color(0xFFE2E8F0), width: 1.5),
                ),
                clipBehavior: Clip.hardEdge,
                child: _imagePath != null
                    ? Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(File(_imagePath!), fit: BoxFit.cover),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.edit, color: Colors.white, size: 14),
                            SizedBox(width: 4),
                            Text('Change',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
                    : const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_photo_alternate_outlined,
                        color: Colors.white38, size: 48),
                    SizedBox(height: 12),
                    Text('Add Cover Photo',
                        style: TextStyle(
                            color: Colors.white54,
                            fontSize: 15,
                            fontWeight: FontWeight.w500)),
                    SizedBox(height: 4),
                    Text('Tap to choose from gallery',
                        style: TextStyle(
                            color: Colors.white30, fontSize: 12)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── Title ──
            _DarkTextField(
              controller: _titleCtrl,
              label: 'Trip Title',
              hint: 'e.g. Weekend in Paris',
              icon: Icons.title,
              validator: (v) =>
              v == null || v.isEmpty ? 'Please enter a title' : null,
            ),

            const SizedBox(height: 16),

            // ── Destination ──
            _DarkTextField(
              controller: _destinationCtrl,
              label: 'Destination',
              hint: 'e.g. Paris, France',
              icon: Icons.location_on_outlined,
              validator: (v) =>
              v == null || v.isEmpty ? 'Please enter a destination' : null,
            ),

            const SizedBox(height: 24),

            // ── Date pickers ──
            const Text('Travel Dates',
                style: TextStyle(
                    color: const Color(0xFF475569),
                    fontSize: 13,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _DateButton(
                    label: 'Departure',
                    date: _startDate,
                    onTap: () => _pickDate(isStart: true),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: const Icon(Icons.arrow_forward,
                      color: Colors.white38, size: 18),
                ),
                Expanded(
                  child: _DateButton(
                    label: 'Return',
                    date: _endDate,
                    onTap: () => _pickDate(isStart: false),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ── Activities ──
            const Text('Activities',
                style: TextStyle(
                    color: const Color(0xFF475569),
                    fontSize: 13,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _DarkTextField(
                    controller: _activityCtrl,
                    label: '',
                    hint: 'Add an activity...',
                    icon: Icons.add_circle_outline,
                    onSubmitted: (_) => _addActivity(),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _addActivity,
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.add,
                        color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
            if (_activities.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _activities.asMap().entries.map((e) {
                  return GestureDetector(
                    onTap: () =>
                        setState(() => _activities.removeAt(e.key)),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: Colors.white.withOpacity(0.15)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(e.value,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 13)),
                          const SizedBox(width: 6),
                          const Icon(Icons.close,
                              color: Colors.white54, size: 14),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],

            const SizedBox(height: 24),

            // ── Notes ──
            _DarkTextField(
              controller: _notesCtrl,
              label: 'Notes',
              hint: 'Packing list, reminders...',
              icon: Icons.notes_outlined,
              maxLines: 3,
            ),

            const SizedBox(height: 32),

            // ── Save button ──
            SizedBox(
              height: 54,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E293B), // Dunkler, moderner Button
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: _save,
                child: const Text(
                  'Save Trip',
                  style: TextStyle(
                      fontWeight: FontWeight.w800, fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Dark-themed text field
// ─────────────────────────────────────────────
class _DarkTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final String? Function(String?)? validator;
  final int maxLines;
  final void Function(String)? onSubmitted;

  const _DarkTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.validator,
    this.maxLines = 1,
    this.onSubmitted,
  });
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLines: maxLines,
      onFieldSubmitted: onSubmitted,
      // GEÄNDERT: Eingabetext ist jetzt dunkelgrau
      style: const TextStyle(color: Color(0xFF1E293B), fontSize: 15),
      decoration: InputDecoration(
        labelText: label.isEmpty ? null : label,
        hintText: hint,
        // GEÄNDERT: Label- und Hint-Farben angepasst
        labelStyle: const TextStyle(color: Color(0xFF64748B)),
        hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
        prefixIcon: Icon(icon, color: const Color(0xFF64748B), size: 20),
        filled: true,
        // GEÄNDERT: Hintergrund der Felder ist reines Weiß
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF1E293B), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Date selector button
// ─────────────────────────────────────────────
class _DateButton extends StatelessWidget {
  final String label;
  final DateTime date;
  final VoidCallback onTap;

  const _DateButton({
    required this.label,
    required this.date,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white, // Weißer Hintergrund
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE2E8F0)), // Heller Rahmen
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // GEÄNDERT: Label-Farbe dunkler
            Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
            const SizedBox(height: 4),
            // GEÄNDERT: Datumstext dunkelgrau
            Text(
              '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}',
              style: const TextStyle(
                  color: Color(0xFF1E293B),
                  fontWeight: FontWeight.w600,
                  fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
