import 'dart:io';
import 'package:flutter/material.dart';
import 'package:freshfit/core/constants/colors.dart';
import 'package:freshfit/core/services/camera_service.dart';
import 'package:freshfit/features/dailyshowcase/daily_showcase_screen.dart';
import 'package:freshfit/features/wardrobe/screens/add_cloth_screen.dart';
import 'package:freshfit/features/wardrobe/screens/wardrobe_screen.dart' as addsheet;
import '../core/constants/colors.dart';
import '../core/services/camera_service.dart';
import '../features/outfit/screens/outfit_history_screen.dart';
import '../features/calendar/screens/calendar_screen.dart';
import '../features/wardrobe/widgets/add_cloth_bottomsheet.dart'as addbottom;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          IndexedStack(
            index: _selectedIndex,
            children: _screens,
          ),
          
          // Overlay backdrop
          if (_showAddOptions)
            GestureDetector(
              onTap: _toggleAddOptions,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  color: Colors.black.withOpacity(0.9),
                ),
              ),
            ),
          
          // Floating action buttons
          if (_showAddOptions)
            Positioned(
              right: 210,
              bottom: 90, // Position above the add button
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
                  const SizedBox(height: 12),
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
        ],
      ),
      bottomNavigationBar: _bottomBarWithAdd(context),
    );
  }

  Widget _buildFloatingOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.black, size: 20),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomBarWithAdd(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // ➕ Add Button with rotation animation
          _addButton(context),
          const SizedBox(width: 12),
          // Navbar pill
          Expanded(child: _buildFloatingNavBar()),
        ],
      ),
    );
  }

  Widget _buildFloatingNavBar() {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(Icons.checkroom_outlined, Icons.checkroom, 'Wardrobe', 0),
          _navItem(Icons.style_outlined, Icons.style, 'Outfits', 1),
          _navItem(Icons.calendar_today_outlined, Icons.calendar_today, 'Calendar', 2),
          _navItem(Icons.threed_rotation_outlined, Icons.threed_rotation, '3D', 3),
        ],
      ),
    );
  }

  Widget _navItem(
    IconData icon,
    IconData activeIcon,
    String label,
    int index,
  ) {
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              size: 20,
              color: isSelected ? AppColors.black : AppColors.textSecondary,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _addButton(BuildContext context) {
    return GestureDetector(
      onTap: _toggleAddOptions,
      child: AnimatedRotation(
        turns: _showAddOptions ? 0.125 : 0, // 45 degree rotation (1/8 turn)
        duration: const Duration(milliseconds: 250),
        child: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(
            Icons.add,
            color: Colors.black,
            size: 26,
          ),
        ),
      ),
    );
  }

  void _openAddClothSheet(BuildContext context, File image) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => addbottom.AddClothBottomSheet(initialImage: image),
    );
  }
}