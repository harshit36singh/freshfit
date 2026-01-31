import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/sizes.dart';
import '../outfit_controller.dart';

class OutfitHistoryScreen extends StatelessWidget {
  const OutfitHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(AppSizes.paddingLg),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'My Outfits',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                                letterSpacing: -1,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Consumer<OutfitController>(
                          builder: (context, controller, child) {
                            return Text(
                              '${controller.outfits.length} outfits',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Outfits list
            Expanded(
              child: Consumer<OutfitController>(
                builder: (context, controller, child) {
                  if (controller.outfits.isEmpty) {
                    return _buildEmptyState(context);
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(AppSizes.paddingLg),
                    itemCount: controller.outfits.length,
                    itemBuilder: (context, index) {
                      final outfit = controller.outfits[index];
                      return Card(
                        color: AppColors.surface,
                        margin: const EdgeInsets.only(bottom: AppSizes.spacingMd),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(AppSizes.paddingMd),
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                            ),
                            child: const Icon(
                              Icons.style,
                              color: AppColors.primary,
                            ),
                          ),
                          title: Text(
                            outfit.name,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            outfit.occasion ?? 'No occasion',
                            style: const TextStyle(color: AppColors.textSecondary),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              outfit.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: outfit.isFavorite
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                            ),
                            onPressed: () {
                              controller.toggleFavorite(outfit.id);
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: const BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.style_outlined,
              size: 60,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSizes.spacingLg),
          Text(
            'No outfits yet',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: AppSizes.spacingSm),
          Text(
            'Generate your first outfit',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }
}