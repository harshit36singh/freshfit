import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../wardrobe_controller.dart';
import '../models/cloth_model.dart';

const _kBg = Color(0xFFF2EBE2);
const _kAccent = Color(0xFF614051);
const _kAccentFade = Color(0x99614051);

class AddClothBottomSheet extends StatefulWidget {
  final File initialImage;

  const AddClothBottomSheet({
    super.key,
    required this.initialImage,
  });

  @override
  State<AddClothBottomSheet> createState() => _AddClothBottomSheetState();
}

class _AddClothBottomSheetState extends State<AddClothBottomSheet> {
  final TextEditingController _nameController = TextEditingController();
  String? _selectedCategory;
  late File _imageFile;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _imageFile = widget.initialImage;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _addCloth() async {
    if (_nameController.text.trim().isEmpty) {
      _showSnackBar('Please enter a name');
      return;
    }
    if (_selectedCategory == null) {
      _showSnackBar('Please select a category');
      return;
    }

    setState(() => _isUploading = true);

    final success = await context.read<WardrobeController>().addCloth(
      name: _nameController.text.trim(),
      category: _selectedCategory!,
      imageFile: _imageFile,
    );

    setState(() => _isUploading = false);

    if (mounted) {
      if (success) {
        Navigator.pop(context, true);
      } else {
        _showSnackBar('Failed to add cloth');
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: _kBg,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: _kAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 620,
      decoration: const BoxDecoration(
        color: _kBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
        border: Border(
          top: BorderSide(color: _kAccent, width: 2),
          left: BorderSide(color: _kAccent, width: 2),
          right: BorderSide(color: _kAccent, width: 2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 3,
                  decoration: BoxDecoration(
                    color: _kAccent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Title row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Add Cloth',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: _kAccent,
                      letterSpacing: -1,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: _kAccent, width: 2),
                      ),
                      child: const Icon(Icons.close, color: _kAccent, size: 18),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // Image preview
              _buildImagePreview(),

              const SizedBox(height: 18),

              // Divider
              Container(height: 2, color: _kAccent),
              const SizedBox(height: 16),

              // Name label
              const Text(
                'Cloth Name',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: _kAccent,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 8),

              // Name field
              TextField(
                controller: _nameController,
                style: const TextStyle(
                  color: _kAccent,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                cursorColor: _kAccent,
                decoration: InputDecoration(
                  hintText: 'e.g., Blue Denim Jacket',
                  hintStyle: const TextStyle(
                    color: _kAccentFade,
                    fontWeight: FontWeight.w500,
                  ),
                  filled: true,
                  fillColor: Colors.transparent,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(color: _kAccent, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(color: _kAccent, width: 2),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // Category label
              const Text(
                'Category',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: _kAccent,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 10),

              // Category chips
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ClothCategory.all.map((category) {
                  final isSelected = _selectedCategory == category;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = category),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? _kAccent : Colors.transparent,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: _kAccent, width: 2),
                      ),
                      child: Text(
                        ClothCategory.getDisplayName(category),
                        style: TextStyle(
                          color: isSelected ? _kBg : _kAccent,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 28),

              // Add button
              GestureDetector(
                onTap: _isUploading ? null : _addCloth,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: _isUploading ? _kAccentFade : _kAccent,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: _kAccent, width: 2),
                  ),
                  child: Center(
                    child: _isUploading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(_kBg),
                            ),
                          )
                        : const Text(
                            'Add to Wardrobe',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: _kBg,
                              letterSpacing: 0.3,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    return Container(
      width: double.infinity,
      height: 190,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: _kAccent, width: 2),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.file(
            _imageFile,
            fit: BoxFit.cover,
          ),
          // Dark gradient at top for close button visibility
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.transparent,
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