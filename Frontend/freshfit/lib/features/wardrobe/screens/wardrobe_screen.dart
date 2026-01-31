import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/sizes.dart';
import '../wardrobe_controller.dart';
import '../models/cloth_model.dart';
import '../widgets/cloth_card.dart';
import '../widgets/filter_chip.dart';
import 'cloth_detail_screen.dart';

class WardrobeScreen extends StatelessWidget {
  const WardrobeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),
            
            // Filter chips
            _buildFilters(context),
            
            // Clothes grid
            Expanded(
              child: _buildClothesGrid(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.paddingLg),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Wardrobe',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1,
                      ),
                ),
                const SizedBox(height: 4),
                Consumer<WardrobeController>(
                  builder: (context, controller, child) {
                    return Text(
                      '${controller.filteredClothes.length} items',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    );
                  },
                ),
              ],
            ),
          ),
          
          // Favorites toggle
          Consumer<WardrobeController>(
            builder: (context, controller, child) {
              return IconButton(
                onPressed: controller.toggleFavoritesOnly,
                icon: Icon(
                  controller.showFavoritesOnly
                      ? Icons.favorite
                      : Icons.favorite_border,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: controller.showFavoritesOnly
                      ? AppColors.primary.withOpacity(0.2)
                      : AppColors.surface,
                  foregroundColor: controller.showFavoritesOnly
                      ? AppColors.primary
                      : AppColors.textPrimary,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(BuildContext context) {
    return Consumer<WardrobeController>(
      builder: (context, controller, child) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingLg),
          child: Row(
            children: [
              // All filter
              FilterChipWidget(
                label: 'All',
                isSelected: controller.selectedCategory == null,
                onTap: () => controller.setCategory(null),
              ),
              
              const SizedBox(width: 8),
              
              // Category filters
              ...ClothCategory.all.map((category) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChipWidget(
                    label: ClothCategory.getDisplayName(category),
                    isSelected: controller.selectedCategory == category,
                    onTap: () {
                      if (controller.selectedCategory == category) {
                        controller.setCategory(null);
                      } else {
                        controller.setCategory(category);
                      }
                    },
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildClothesGrid(BuildContext context) {
    return Consumer<WardrobeController>(
      builder: (context, controller, child) {
        if (controller.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (controller.filteredClothes.isEmpty) {
          return _buildEmptyState(context);
        }

        return GridView.builder(
          padding: const EdgeInsets.all(AppSizes.paddingLg),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: AppSizes.spacingMd,
            mainAxisSpacing: AppSizes.spacingMd,
          ),
          itemCount: controller.filteredClothes.length,
          itemBuilder: (context, index) {
            final cloth = controller.filteredClothes[index];
            return ClothCard(
              cloth: cloth,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ClothDetailScreen(cloth: cloth),
                  ),
                );
              },
            );
          },
        );
      },
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
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.checkroom_outlined,
              size: 60,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSizes.spacingLg),
          Text(
            'No clothes yet',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: AppSizes.spacingSm),
          Text(
            'Add your first item to get started',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }
}