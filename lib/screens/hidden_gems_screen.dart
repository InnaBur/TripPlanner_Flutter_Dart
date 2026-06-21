import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/place.dart';
import 'package:flutter/foundation.dart';

class HiddenGemsScreen extends StatefulWidget {
  const HiddenGemsScreen({super.key});

  @override
  State<HiddenGemsScreen> createState() => _HiddenGemsScreenState();
}

class _HiddenGemsScreenState extends State<HiddenGemsScreen> {
  final List<Place> _gems = [
    Place(
      id: '1',
      name: 'Palazzo Contarini del Bovolo',
      description:
      'A stunning hidden Venetian palace famous for its spiral external staircase. Most tourists walk right past it without noticing the entrance in the tiny alley',
      latitude: 45.4373,
      longitude: 12.3346,
      category: 'Architecture',
      rating: 4.9,
      imagePath: 'assets/gems/img26.jpg',
      address: 'Calle Contarini del Bovolo, Venice, Italy',
      tags: ['Hidden', 'Architecture', 'Photo Spot'],
    ),
    Place(
      id: '2',
      name: 'Frohnleiten',
      description:
      'A charming small town along the Mur river, surrounded by green hills. Perfect for a relaxed walk away from the tourist crowds.',
      latitude: 47.2667,
      longitude: 15.3167,
      category: 'Nature',
      rating: 4.6,
      imagePath: 'assets/gems/img24.jpg',
      address: 'Frohnleiten, Austria',
      tags: ['Quiet', 'Nature', 'Riverside'],
    ),
    Place(
      id: '3',
      name: 'Leopoldsteinersee',
      description:
      'A crystal-clear alpine lake surrounded by mountains near Eisenerz. One of the most beautiful and peaceful lakes in Styria.',
      latitude: 47.5333,
      longitude: 14.9667,
      category: 'Nature',
      rating: 5.0,
      imagePath: 'assets/gems/img22.jpg',
      address: 'Leopoldsteinersee, Eisenerz, Austria',
      tags: ['Lake', 'Mountains', 'Hiking'],
    ),
  ];

  String _selectedFilter = 'All';
  final List<String> _filters = [
    'All',
    'Architecture',
    'Nature',
    'Other'
  ];

  List<Place> get _filtered => _selectedFilter == 'All'
      ? _gems
      : _gems.where((p) => p.category == _selectedFilter).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 140,
            backgroundColor: const Color(0xFF0F172A),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.fromLTRB(20, 0, 0, 16),
              title: const Text(
                'Hidden Gems',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 22,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1E1E38), const Color(0xFF0F172A)],
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.diamond_outlined,
                      color: Colors.white10, size: 100),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: _filters.length,
                itemBuilder: (_, i) {
                  final f = _filters[i];
                  final selected = f == _selectedFilter;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedFilter = f),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: selected
                            ? const Color(0xFF38BDF8)
                            : Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: selected
                              ? const Color(0xFF38BDF8)
                              : Colors.white.withOpacity(0.1),
                        ),
                      ),
                      child: Text(
                        f,
                        style: TextStyle(
                          color: selected
                              ? const Color(0xFF0F172A)
                              : const Color(0xFF94A3B8),
                          fontWeight: selected
                              ? FontWeight.w700
                              : FontWeight.normal,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
              child: Text(
                '${_filtered.length} place${_filtered.length == 1 ? '' : 's'} found',
                style: const TextStyle(
                    color: Color(0xFF64748B), fontSize: 12),
              ),
            ),
          ),

          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) => _GemCard(
                gem: _filtered[index],
                onDelete: () {
                  final gem = _filtered[index];
                  setState(() => _gems.removeWhere((g) => g.id == gem.id));
                },
              ),
              childCount: _filtered.length,
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF38BDF8),
        foregroundColor: const Color(0xFF0F172A),
        icon: const Icon(Icons.add),
        label: const Text('Add Gem',
            style: TextStyle(fontWeight: FontWeight.w700)),
        onPressed: () async {
          final gem = await Navigator.push<Place>(
            context,
            MaterialPageRoute(builder: (_) => const AddGemScreen()),
          );
          if (gem != null) setState(() => _gems.add(gem));
        },
      ),
    );
  }
}

class _GemCard extends StatelessWidget {
  final Place gem;
  final VoidCallback onDelete;

  const _GemCard({required this.gem, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => _showDeleteDialog(context),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B).withOpacity(0.6),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.06)),
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 160,
              width: double.infinity,
              child: _GemPhoto(gem: gem),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          gem.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded,
                              color: Color(0xFFFFD700), size: 16),
                          const SizedBox(width: 3),
                          Text(gem.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13)),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF38BDF8).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text('Architecture',
                            style: TextStyle(
                                color: Color(0xFF38BDF8),
                                fontSize: 11,
                                fontWeight: FontWeight.w600)),
                      ),
                      if (gem.address != null) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.location_on_outlined,
                            color: Color(0xFF64748B), size: 12),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            gem.address!,
                            style: const TextStyle(
                                color: Color(0xFF94A3B8), fontSize: 11),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 10),
                  Text(
                    gem.description,
                    style: const TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 13,
                        height: 1.5),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  if (gem.tags.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 6,
                      children: gem.tags
                          .map((t) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(t,
                            style: const TextStyle(
                                color: Color(0xFF64748B),
                                fontSize: 11)),
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
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Remove gem?',
            style: TextStyle(color: Colors.white)),
        content: Text('Remove "${gem.name}" from your gems?',
            style: const TextStyle(color: Color(0xFF94A3B8))),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel',
                  style: TextStyle(color: Color(0xFF64748B)))),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                onDelete();
              },
              child: const Text('Remove',
                  style: TextStyle(color: Colors.redAccent))),
        ],
      ),
    );
  }
}

class _GemPhoto extends StatelessWidget {
  final Place gem;
  const _GemPhoto({required this.gem});

  @override
  Widget build(BuildContext context) {
    if (gem.imagePath != null) {
      if (gem.imagePath!.startsWith('assets/')) {
        return Image.asset(
          gem.imagePath!,
          fit: BoxFit.cover,
          width: double.infinity,
          errorBuilder: (_, __, ___) => _GemPlaceholder(),
        );
      }
      if (!kIsWeb) {
        return Image.file(
          File(gem.imagePath!),
          fit: BoxFit.cover,
          width: double.infinity,
        );
      }
    }
    if (gem.imageUrl != null) {
      return Image.network(
        gem.imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _GemPlaceholder(),
      );
    }
    return _GemPlaceholder();
  }
}

class _GemPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    color: Colors.white.withOpacity(0.04),
    child: const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.diamond_outlined, color: Colors.white24, size: 36),
        SizedBox(height: 6),
        Text('No photo',
            style: TextStyle(color: Colors.white24, fontSize: 12)),
      ],
    ),
  );
}

class AddGemScreen extends StatefulWidget {
  const AddGemScreen({super.key});

  @override
  State<AddGemScreen> createState() => _AddGemScreenState();
}

class _AddGemScreenState extends State<AddGemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _tagCtrl = TextEditingController();

  String _category = 'Nature';
  double _rating = 4.0;
  String? _imagePath;
  final List<String> _tags = [];

  final List<String> _categories = [
    'Nature',
    'Café',
    'Museum',
    'Viewpoint',
    'Restaurant',
    'Bar',
    'Art',
    'Other',
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _addressCtrl.dispose();
    _tagCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final result = await picker.pickImage(
        source: ImageSource.gallery, imageQuality: 85, maxWidth: 1200);
    if (result != null) setState(() => _imagePath = result.path);
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final gem = Place(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        latitude: 0,
        longitude: 0,
        category: _category,
        rating: _rating,
        imagePath: _imagePath,
        address: _addressCtrl.text.trim().isEmpty
            ? null
            : _addressCtrl.text.trim(),
        tags: List.from(_tags),
      );
      Navigator.pop(context, gem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Add Hidden Gem',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w700)),
        backgroundColor: const Color(0xFF0F172A),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text('Save',
                style: TextStyle(
                    color: Color(0xFF38BDF8), fontWeight: FontWeight.w700)),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: Colors.white.withOpacity(0.08), width: 1.5),
                ),
                clipBehavior: Clip.hardEdge,
                child: _imagePath != null
                    ? Stack(
                  fit: StackFit.expand,
                  children: [
                    _imagePath!.startsWith('assets/')
                        ? Image.asset(_imagePath!, fit: BoxFit.cover)
                        : kIsWeb
                        ? Image.network(_imagePath!, fit: BoxFit.cover)
                        : Image.file(File(_imagePath!), fit: BoxFit.cover),
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
                            Icon(Icons.edit,
                                color: Colors.white, size: 14),
                            SizedBox(width: 4),
                            Text('Change',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12)),
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
                        color: Color(0xFF64748B), size: 40),
                    SizedBox(height: 10),
                    Text('Add Photo',
                        style: TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 15,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            _DarkField(
              controller: _nameCtrl,
              label: 'Place Name',
              hint: 'e.g. Secret Garden',
              icon: Icons.diamond_outlined,
              validator: (v) =>
              v == null || v.isEmpty ? 'Enter a name' : null,
            ),
            const SizedBox(height: 16),

            _DarkField(
              controller: _descCtrl,
              label: 'Description',
              hint: 'What makes this place special?',
              icon: Icons.description_outlined,
              maxLines: 3,
              validator: (v) =>
              v == null || v.isEmpty ? 'Enter a description' : null,
            ),
            const SizedBox(height: 16),

            _DarkField(
              controller: _addressCtrl,
              label: 'Address (optional)',
              hint: 'Street, City',
              icon: Icons.location_on_outlined,
            ),

            const SizedBox(height: 24),

            const Text('Category',
                style: TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 13,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.04),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: Colors.white.withOpacity(0.08)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _category,
                  dropdownColor: const Color(0xFF1E293B),
                  style: const TextStyle(color: Colors.white),
                  isExpanded: true,
                  items: _categories
                      .map((c) => DropdownMenuItem(
                    value: c,
                    child: Text(c),
                  ))
                      .toList(),
                  onChanged: (v) =>
                      setState(() => _category = v ?? _category),
                ),
              ),
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Rating',
                    style: TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 13,
                        fontWeight: FontWeight.w500)),
                Row(
                  children: [
                    const Icon(Icons.star_rounded,
                        color: Color(0xFFFFD700), size: 16),
                    const SizedBox(width: 4),
                    Text(_rating.toStringAsFixed(1),
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
              ],
            ),
            Slider(
              value: _rating,
              min: 1,
              max: 5,
              divisions: 8,
              activeColor: const Color(0xFF38BDF8),
              inactiveColor: Colors.white12,
              onChanged: (v) => setState(() => _rating = v),
            ),

            const SizedBox(height: 16),

            const Text('Tags',
                style: TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 13,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _DarkField(
                    controller: _tagCtrl,
                    label: '',
                    hint: 'Add a tag...',
                    icon: Icons.label_outline,
                    onSubmitted: (_) {
                      final t = _tagCtrl.text.trim();
                      if (t.isNotEmpty) {
                        setState(() {
                          _tags.add(t);
                          _tagCtrl.clear();
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    final t = _tagCtrl.text.trim();
                    if (t.isNotEmpty) {
                      setState(() {
                        _tags.add(t);
                        _tagCtrl.clear();
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF38BDF8),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.add,
                        color: Color(0xFF0F172A), size: 20),
                  ),
                ),
              ],
            ),
            if (_tags.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _tags.asMap().entries.map((e) {
                  return GestureDetector(
                    onTap: () =>
                        setState(() => _tags.removeAt(e.key)),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF38BDF8).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: const Color(0xFF38BDF8).withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(e.value,
                              style: const TextStyle(
                                  color: Color(0xFF38BDF8),
                                  fontSize: 12)),
                          const SizedBox(width: 4),
                          const Icon(Icons.close,
                              color: Color(0xFF38BDF8), size: 13),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],

            const SizedBox(height: 32),

            SizedBox(
              height: 54,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF38BDF8),
                  foregroundColor: const Color(0xFF0F172A),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: _save,
                child: const Text('Save Gem',
                    style: TextStyle(
                        fontWeight: FontWeight.w800, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _DarkField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final String? Function(String?)? validator;
  final int maxLines;
  final void Function(String)? onSubmitted;

  const _DarkField({
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
      style: const TextStyle(color: Colors.white, fontSize: 15),
      decoration: InputDecoration(
        labelText: label.isEmpty ? null : label,
        hintText: hint,
        labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
        hintStyle: const TextStyle(color: Color(0xFF64748B)),
        prefixIcon: Icon(icon, color: const Color(0xFF64748B), size: 20),
        filled: true,
        fillColor: Colors.white.withOpacity(0.04),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF38BDF8), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
      ),
    );
  }
}