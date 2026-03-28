import 'dart:io';
import 'package:flutter/material.dart';
import 'package:freshfit/core/constants/colors.dart';
import 'package:freshfit/core/services/camera_service.dart';
import 'package:freshfit/features/dailyshowcase/daily_showcase_screen.dart';
import 'package:freshfit/features/wardrobe/screens/add_cloth_screen.dart';
import 'package:freshfit/features/wardrobe/screens/wardrobe_screen.dart'
    as addsheet;
import '../core/services/camera_service.dart';
import '../features/outfit/screens/outfit_history_screen.dart';
import '../features/calendar/screens/calendar_screen.dart';
import '../features/wardrobe/widgets/add_cloth_bottomsheet.dart' as addbottom;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _showAddOptions = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  final List<Widget> _screens = [
    addsheet.WardrobeScreen(),
    OutfitHistoryScreen(),
    CalendarScreen(),
    ThreeDPage(),
  ];

  // Nav items matching original tabs
  final List<_NavItem> _navItems = const [
    _NavItem(
      icon: Icons.checkroom_outlined,
      activeIcon: Icons.checkroom,
      label: 'Wardrobe',
    ),
    _NavItem(
      icon: Icons.style_outlined,
      activeIcon: Icons.style,
      label: 'Outfits',
    ),
    _NavItem(
      icon: Icons.calendar_today_outlined,
      activeIcon: Icons.calendar_today,
      label: 'Calendar',
    ),
    _NavItem(
      icon: Icons.threed_rotation_outlined,
      activeIcon: Icons.threed_rotation,
      label: '3D',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  void _toggleAddOptions() {
    setState(() {
      _showAddOptions = !_showAddOptions;
      if (_showAddOptions) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _openAddClothSheet(BuildContext context, File image) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => addbottom.AddClothBottomSheet(initialImage: image),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── Yellow-green gradient background (from Screenpage) ──
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF2EBE2), Color(0xFFF2EBE2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Positioned.fill(
          //   child: Opacity(
          //     opacity: 0.4,
          //     child: Image.asset('assets/back1.jpg', fit: BoxFit.cover),
          //   ),
          // ),

          // ── Main screen content ──
          IndexedStack(index: _selectedIndex, children: _screens),

          // ── Backdrop when add options open ──
          if (_showAddOptions)
            GestureDetector(
              onTap: _toggleAddOptions,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Container(color: Colors.black.withOpacity(0.85)),
              ),
            ),

          // ── Floating add option buttons ──
          if (_showAddOptions)
            Positioned(
              left: 16,
              right: 16,
              bottom: 90,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFloatingOption(
                        icon: Icons.camera_alt,
                        label: 'Take Photo',
                        onTap: () async {
                          _toggleAddOptions();
                          final file = await CameraService.takePhoto();
                          if (file != null && context.mounted) {
                            _openAddClothSheet(context, file);
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      _buildFloatingOption(
                        icon: Icons.photo_library,
                        label: 'Choose from Gallery',
                        onTap: () async {
                          _toggleAddOptions();
                          final file = await CameraService.pickFromGallery();
                          if (file != null && context.mounted) {
                            _openAddClothSheet(context, file);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // ── Bottom nav + add button ──
          Positioned(left: 0, right: 0, bottom: 0, child: _buildBottomBar()),
        ],
      ),
    );
  }

  /// Add option pill — styled with black border, transparent bg (Screenpage card style)
  Widget _buildFloatingOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF2EBE2), // white beige
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: const Color(0xFF614051),
            width: 2,
          ), // eggplant border
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: const Color(0xFF614051),
              size: 20,
            ), // eggplant icon
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF614051), // eggplant text
                fontWeight: FontWeight.w700,
                fontSize: 14,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Bottom bar: add button + flat bordered nav (Screenpage NavBar style)
  Widget _buildBottomBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.transparent,
        border: Border(
          top: BorderSide(color: Colors.black, width: 2),
          bottom: BorderSide(color: Colors.black, width: 2),
        ),
      ),
      child: Row(
        children: [
          // ── Add button (left side, same rotation logic) ──
          GestureDetector(
            onTap: _toggleAddOptions,
            child: AnimatedRotation(
              turns: _showAddOptions ? 0.125 : 0,
              duration: const Duration(milliseconds: 250),
              child: Container(
                width: 52,
                height: 52,
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Icon(
                  Icons.add,
                  color: Color(0xFFF2EBE2), // white beige
                  size: 28,
                ),
              ),
            ),
          ),

          // ── Nav items ──
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_navItems.length, (index) {
                final item = _navItems[index];
                final isSelected = _selectedIndex == index;
                return GestureDetector(
                  onTap: () => _onItemTapped(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      isSelected ? item.activeIcon : item.icon,
                      color: isSelected ? Colors.black : Colors.black45,
                      size: 28,
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

// Simple data class for nav items
class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
