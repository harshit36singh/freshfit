import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../outfit_controller.dart';

const _kBg = Color(0xFFF2EBE2);
const _kAccent = Color(0xFF614051);
const _kAccentFade = Color(0x99614051);

class OutfitHistoryScreen extends StatelessWidget {
  const OutfitHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            Expanded(child: _buildOutfitList()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 10),
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
    );
  }

  Widget _buildOutfitList() {
    return Consumer<OutfitController>(
      builder: (context, controller, _) {
        if (controller.outfits.isEmpty) return _buildEmptyState(context);

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
              child: Row(
                children: [
                  // Leading icon box
                  Container(
                    width: 54,
                    height: 54,
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: _kAccent, width: 2),
                    ),
                    child: const Icon(Icons.style, color: _kAccent, size: 24),
                  ),

                  // Title + subtitle
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            outfit.name,
                            style: const TextStyle(
                              color: _kAccent,
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            outfit.occasion ?? 'No occasion',
                            style: const TextStyle(
                              color: _kAccentFade,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Favorite toggle
                  GestureDetector(
                    onTap: () => controller.toggleFavorite(outfit.id),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Icon(
                        outfit.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: outfit.isFavorite ? _kAccent : _kAccentFade,
                        size: 22,
                      ),
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
            'Generate your first outfit',
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