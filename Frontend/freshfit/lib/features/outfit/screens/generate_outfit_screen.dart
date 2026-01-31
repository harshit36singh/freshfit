import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/sizes.dart';
import '../outfit_controller.dart';
import '../../wardrobe/wardrobe_controller.dart';
import '../models/outfit_model.dart';

class GenerateOutfitScreen extends StatefulWidget {
  const GenerateOutfitScreen({super.key});

  @override
  State<GenerateOutfitScreen> createState() => _GenerateOutfitScreenState();
}

class _GenerateOutfitScreenState extends State<GenerateOutfitScreen> {
  String? _selectedOccasion;
  String? _selectedSeason;

  void _generateOutfit() {
    final wardrobeController = context.read<WardrobeController>();
    final outfitController = context.read<OutfitController>();

    final outfit = outfitController.generateOutfit(
      availableClothes: wardrobeController.allClothes,
      occasion: _selectedOccasion,
      season: _selectedSeason,
    );

    if (outfit != null) {
      outfitController.addOutfit(outfit);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Outfit generated successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Not enough clothes to generate outfit'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate Outfit'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Let AI create the perfect outfit for you',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            
            const SizedBox(height: AppSizes.spacingXl),
            
            // Occasion selector
            Text(
              'Occasion',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: Occasion.all.map((occasion) {
                return FilterChip(
                  label: Text(occasion),
                  selected: _selectedOccasion == occasion,
                  onSelected: (selected) {
                    setState(() => _selectedOccasion = selected ? occasion : null);
                  },
                  selectedColor: AppColors.primary,
                  backgroundColor: AppColors.surface,
                  labelStyle: TextStyle(
                    color: _selectedOccasion == occasion
                        ? AppColors.black
                        : AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                );
              }).toList(),
            ),
            
            const SizedBox(height: AppSizes.spacingXl),
            
            // Generate button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _generateOutfit,
                child: const Text('Generate Outfit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}