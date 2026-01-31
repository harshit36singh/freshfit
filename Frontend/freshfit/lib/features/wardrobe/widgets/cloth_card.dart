import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/sizes.dart';
import '../models/cloth_model.dart';
import 'package:provider/provider.dart';
import '../wardrobe_controller.dart';

class ClothCard extends StatelessWidget {
  final ClothModel cloth;
  final VoidCallback? onTap;

  const ClothCard({
    super.key,
    required this.cloth,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          border: Border.all(
            color: AppColors.divider,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image container
            Expanded(
              child: Stack(
                children: [
                  // Cloth image
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(AppSizes.radiusLg),
                      ),
                      color: AppColors.backgroundLight,
                    ),
                    child: cloth.imageUrl != null
                        ? ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(AppSizes.radiusLg),
                            ),
                            child: Image.network(
                              cloth.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: AppColors.backgroundLight,
                                  child: const Center(
                                    child: Icon(
                                      Icons.checkroom,
                                      size: 48,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : Container(
                            color: AppColors.backgroundLight,
                            child: const Center(
                              child: Icon(
                                Icons.checkroom,
                                size: 48,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                  ),
                  
                  // Favorite button
                  Positioned(
                    top: AppSizes.paddingSm,
                    right: AppSizes.paddingSm,
                    child: GestureDetector(
                      onTap: () {
                        context.read<WardrobeController>().toggleFavorite(cloth.id);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(AppSizes.paddingSm),
                        decoration: BoxDecoration(
                          color: AppColors.black.withOpacity(0.6),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          cloth.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: cloth.isFavorite
                              ? AppColors.primary
                              : AppColors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Details
            Padding(
              padding: const EdgeInsets.all(AppSizes.paddingMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    cloth.name,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // Brand (if available)
                  if (cloth.brand != null && cloth.brand!.isNotEmpty)
                    Text(
                      cloth.brand!,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  
                  const SizedBox(height: 8),
                  
                  // Category tag
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                    ),
                    child: Text(
                      ClothCategory.getDisplayName(cloth.category),
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}