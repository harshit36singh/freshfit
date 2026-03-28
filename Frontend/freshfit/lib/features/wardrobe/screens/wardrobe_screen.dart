import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/sizes.dart';
import '../wardrobe_controller.dart';
import '../models/cloth_model.dart';
import '../widgets/cloth_card.dart';
import '../widgets/filter_chip.dart';
import 'cloth_detail_screen.dart';

const _kBg = Color(0xFFF2EBE2);        // white beige
const _kAccent = Color(0xFF614051);     // eggplant
const _kBlack = Color(0xFF614051);      // eggplant for borders/text
const _kBlack45 = Color(0x99614051);    // eggplant at ~60% opacity

class WardrobeScreen extends StatelessWidget {
  const WardrobeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            _buildFilters(context),
            Expanded(child: _buildClothesGrid(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Wardrobe',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: _kBlack,
                    letterSpacing: -1,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 4),
                Consumer<WardrobeController>(
                  builder: (context, controller, _) => Text(
                    '${controller.filteredClothes.length} items',
                    style: const TextStyle(
                      fontSize: 13,
                      color: _kBlack45,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Favorites toggle — bordered box style
          Consumer<WardrobeController>(
            builder: (context, controller, _) {
              final active = controller.showFavoritesOnly;
              return GestureDetector(
                onTap: controller.toggleFavoritesOnly,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: active ? _kBlack : Colors.transparent,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: _kBlack, width: 2),
                  ),
                  child: Icon(
                    active ? Icons.favorite : Icons.favorite_border,
                    color: active ? _kBg : _kBlack,
                    size: 22,
                  ),
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
      builder: (context, controller, _) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
          child: Row(
            children: [
              _filterPill(
                label: 'All',
                isSelected: controller.selectedCategory == null,
                onTap: () => controller.setCategory(null),
              ),
              const SizedBox(width: 8),
              ...ClothCategory.all.map((category) {
                final isSelected = controller.selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _filterPill(
                    label: ClothCategory.getDisplayName(category),
                    isSelected: isSelected,
                    onTap: () => controller.setCategory(isSelected ? null : category),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _filterPill({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? _kBlack : Colors.transparent,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: _kBlack, width: 2),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: isSelected ? _kBg : _kBlack,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }

  Widget _buildClothesGrid(BuildContext context) {
    return Consumer<WardrobeController>(
      builder: (context, controller, _) {
        if (controller.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: _kBlack),
          );
        }

        if (controller.filteredClothes.isEmpty) {
          return _buildEmptyState(context);
        }

        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 100),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: controller.filteredClothes.length,
          itemBuilder: (context, index) {
            final cloth = controller.filteredClothes[index];
            return _borderedCard(
              child: ClothCard(
                cloth: cloth,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ClothDetailScreen(cloth: cloth),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// Wraps any card widget with the Screenpage-style black border box
  Widget _borderedCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: _kBlack, width: 2),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: _kBlack, width: 2),
            ),
            child: const Icon(
              Icons.checkroom_outlined,
              size: 52,
              color: _kBlack,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'No clothes yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: _kBlack,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Add your first item to get started',
            style: TextStyle(
              fontSize: 13,
              color: _kBlack45,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}