import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../outfit_controller.dart';
import '../models/outfit_model.dart';

const _kBg = Color(0xFFF2EBE2);
const _kAccent = Color(0xFF614051);
const _kAccentFade = Color(0x99614051);

class GenerateOutfitScreen extends StatefulWidget {
  const GenerateOutfitScreen({super.key});

  @override
  State<GenerateOutfitScreen> createState() => _GenerateOutfitScreenState();
}

class _GenerateOutfitScreenState extends State<GenerateOutfitScreen> {
  String? _selectedOccasion;

  Future<void> _generateOutfit() async {
    final outfitController = context.read<OutfitController>();

    final outfit = await outfitController.generateOutfit(
      occasion: _selectedOccasion,
    );

    if (mounted) {
      if (outfit != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Outfit generated!',
              style: TextStyle(color: _kBg, fontWeight: FontWeight.w600),
            ),
            backgroundColor: _kAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            margin: const EdgeInsets.all(16),
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              outfitController.errorMessage ?? 'Failed to generate outfit',
              style: const TextStyle(color: _kBg, fontWeight: FontWeight.w600),
            ),
            backgroundColor: Colors.red.shade800,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: _kAccent, width: 2),
            ),
            child: const Icon(Icons.arrow_back_ios_new, color: _kAccent, size: 16),
          ),
        ),
        title: const Text(
          'Generate Outfit',
          style: TextStyle(
            color: _kAccent,
            fontWeight: FontWeight.w900,
            fontSize: 20,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Create the perfect outfit for any occasion',
              style: TextStyle(
                fontSize: 14,
                color: _kAccentFade,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 28),

            // Divider
            Container(height: 2, color: _kAccent),
            const SizedBox(height: 20),

            const Text(
              'Occasion',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: _kAccent,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 10),

            // Occasion chips
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: Occasion.all.map((occasion) {
                final isSelected = _selectedOccasion == occasion;
                return GestureDetector(
                  onTap: () => setState(() {
                    _selectedOccasion = isSelected ? null : occasion;
                  }),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? _kAccent : Colors.transparent,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: _kAccent, width: 2),
                    ),
                    child: Text(
                      occasion,
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

            const SizedBox(height: 32),

            // Generate button
            Consumer<OutfitController>(
              builder: (context, controller, _) {
                return GestureDetector(
                  onTap: controller.isLoading ? null : _generateOutfit,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      color: controller.isLoading ? _kAccentFade : _kAccent,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: _kAccent, width: 2),
                    ),
                    child: Center(
                      child: controller.isLoading
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(_kBg),
                              ),
                            )
                          : const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.auto_awesome, color: _kBg, size: 18),
                                SizedBox(width: 8),
                                Text(
                                  'Generate Outfit',
                                  style: TextStyle(
                                    color: _kBg,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}