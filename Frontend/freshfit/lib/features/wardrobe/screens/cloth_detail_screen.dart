import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/sizes.dart';
import '../models/cloth_model.dart';
import '../wardrobe_controller.dart';

class ClothDetailScreen extends StatelessWidget {
  final ClothModel cloth;

  const ClothDetailScreen({super.key, required this.cloth});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App bar with image
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildImage(),
            ),
            actions: [
              Consumer<WardrobeController>(
                builder: (context, controller, child) {
                  final clothData = controller.getClothById(cloth.id);
                  return IconButton(
                    onPressed: () {
                      controller.toggleFavorite(cloth.id);
                    },
                    icon: Icon(
                      clothData?.isFavorite == true
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: AppColors.primary,
                    ),
                  );
                },
              ),
              IconButton(
                onPressed: () {
                  _showDeleteDialog(context);
                },
                icon: const Icon(Icons.delete_outline, color: AppColors.error),
              ),
            ],
          ),
          
          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.paddingLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    cloth.name,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Brand
                  if (cloth.brand != null && cloth.brand!.isNotEmpty)
                    Text(
                      cloth.brand!,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  
                  const SizedBox(height: AppSizes.spacingXl),
                  
                  // Details
                  _buildDetailRow('Category', ClothCategory.getDisplayName(cloth.category)),
                  _buildDetailRow('Color', cloth.color),
                  if (cloth.size != null && cloth.size!.isNotEmpty) 
                    _buildDetailRow('Size', cloth.size!),
                  if (cloth.season != null && cloth.season!.isNotEmpty) 
                    _buildDetailRow('Season', cloth.season!),
                  _buildDetailRow(
                    'Added',
                    '${cloth.addedDate.day}/${cloth.addedDate.month}/${cloth.addedDate.year}',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    if (cloth.imageUrl != null && cloth.imageUrl!.isNotEmpty) {
      return Image.network(
        cloth.imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: AppColors.surface,
            child: const Center(
              child: Icon(Icons.checkroom, size: 80, color: AppColors.textSecondary),
            ),
          );
        },
      );
    } else if (cloth.imagePath != null && cloth.imagePath!.isNotEmpty) {
      // Try to load from file path
      if (cloth.imagePath!.startsWith('http')) {
        return Image.network(
          cloth.imagePath!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: AppColors.surface,
              child: const Center(
                child: Icon(Icons.checkroom, size: 80, color: AppColors.textSecondary),
              ),
            );
          },
        );
      } else {
        return Image.file(
          File(cloth.imagePath!),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: AppColors.surface,
              child: const Center(
                child: Icon(Icons.checkroom, size: 80, color: AppColors.textSecondary),
              ),
            );
          },
        );
      }
    }
    
    return Container(
      color: AppColors.surface,
      child: const Center(
        child: Icon(Icons.checkroom, size: 80, color: AppColors.textSecondary),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.spacingLg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Delete Cloth', style: TextStyle(color: AppColors.textPrimary)),
        content: const Text(
          'Are you sure you want to delete this item?',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<WardrobeController>().deleteCloth(cloth.id);
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close detail screen
            },
            child: const Text('Delete', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}