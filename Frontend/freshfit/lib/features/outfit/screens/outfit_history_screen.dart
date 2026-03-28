import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../outfit_controller.dart';

const _kBg = Color(0xFFF2EBE2);
const _kAccent = Color(0xFF614051);
const _kAccentFade = Color(0x99614051);

class OutfitHistoryScreen extends StatefulWidget {
  const OutfitHistoryScreen({super.key});

  @override
  State<OutfitHistoryScreen> createState() => _OutfitHistoryScreenState();
}

class _OutfitHistoryScreenState extends State<OutfitHistoryScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch outfits from backend when screen loads
    Future.microtask(() => context.read<OutfitController>().fetchOutfits());
  }

  Future<void> _generateOutfit() async {
    final controller = context.read<OutfitController>();
    final outfit = await controller.generateOutfit();
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
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              controller.errorMessage ?? 'Failed to generate outfit',
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
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Expanded(child: _buildOutfitList()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'My Outfits',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: _kAccent,
                    letterSpacing: -1,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 4),
                Consumer<OutfitController>(
                  builder: (context, controller, _) => Text(
                    '${controller.outfits.length} outfits',
                    style: const TextStyle(
                      fontSize: 13,
                      color: _kAccentFade,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Generate outfit button
          Consumer<OutfitController>(
            builder: (context, controller, _) {
              return GestureDetector(
                onTap: controller.isLoading ? null : _generateOutfit,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: controller.isLoading ? _kAccentFade : _kAccent,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: _kAccent, width: 2),
                  ),
                  child: controller.isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(_kBg),
                          ),
                        )
                      : const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.auto_awesome, color: _kBg, size: 16),
                            SizedBox(width: 6),
                            Text(
                              'Generate',
                              style: TextStyle(
                                color: _kBg,
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOutfitList() {
    return Consumer<OutfitController>(
      builder: (context, controller, _) {
        if (controller.isLoading && controller.outfits.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: _kAccent),
          );
        }

        if (controller.outfits.isEmpty) return _buildEmptyState();

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(18, 4, 18, 100),
          itemCount: controller.outfits.length,
          itemBuilder: (context, index) {
            final outfit = controller.outfits[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: _kAccent, width: 2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + favorite row
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            outfit.name,
                            style: const TextStyle(
                              color: _kAccent,
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => controller.toggleFavorite(outfit.id),
                          child: Icon(
                            outfit.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: outfit.isFavorite ? _kAccent : _kAccentFade,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Clothes thumbnails row
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                    child: Row(
                      children: [
                        ...outfit.clothes.map((cloth) => _clothThumb(cloth)),
                        const SizedBox(width: 10),
                        Text(
                          outfit.occasion ?? 'No occasion',
                          style: const TextStyle(
                            color: _kAccentFade,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _clothThumb(cloth) {
    return Container(
      width: 48,
      height: 48,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: _kAccent, width: 2),
      ),
      clipBehavior: Clip.antiAlias,
      child: cloth.imageUrl != null
          ? Image.network(
              cloth.imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.checkroom,
                color: _kAccent,
                size: 20,
              ),
            )
          : const Icon(Icons.checkroom, color: _kAccent, size: 20),
    );
  }

  Widget _buildEmptyState() {
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
              border: Border.all(color: _kAccent, width: 2),
            ),
            child: const Icon(Icons.style_outlined, size: 52, color: _kAccent),
          ),
          const SizedBox(height: 20),
          const Text(
            'No outfits yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: _kAccent,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Tap Generate to create your first outfit',
            style: TextStyle(
              fontSize: 13,
              color: _kAccentFade,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}