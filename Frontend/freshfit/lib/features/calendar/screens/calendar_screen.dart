import 'package:flutter/material.dart';
import 'package:freshfit/core/constants/colors.dart';
import 'package:freshfit/core/constants/sizes.dart';
import 'package:freshfit/features/outfit/outfit_controller.dart';
import 'package:provider/provider.dart';
import '../calendar_controller.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

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
                    child: Text(
                      'Outfit Calendar',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -1,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Simple calendar view
            _buildCalendar(),
            
            const SizedBox(height: AppSizes.spacingLg),
            
            // Selected day's outfit
            Expanded(
              child: _buildSelectedDayOutfit(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.paddingLg),
      padding: const EdgeInsets.all(AppSizes.paddingLg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      child: Column(
        children: [
          // Month/Year header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _focusedDay = DateTime(
                      _focusedDay.year,
                      _focusedDay.month - 1,
                    );
                  });
                },
                icon: const Icon(Icons.chevron_left, color: AppColors.textPrimary),
              ),
              Text(
                '${_getMonthName(_focusedDay.month)} ${_focusedDay.year}',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _focusedDay = DateTime(
                      _focusedDay.year,
                      _focusedDay.month + 1,
                    );
                  });
                },
                icon: const Icon(Icons.chevron_right, color: AppColors.textPrimary),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Simple grid representation
          Text(
            'Tap a date to schedule an outfit',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedDayOutfit() {
    return Consumer<CalendarController>(
      builder: (context, controller, child) {
        final selectedDate = controller.selectedDate;
        final outfit = controller.getOutfitForDate(selectedDate);

        if (outfit == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.event_available,
                  size: 64,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(height: 16),
                Text(
                  'No outfit scheduled',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    _showOutfitPicker(context, selectedDate);
                  },
                  icon: const Icon(Icons.add, color: AppColors.black),
                  label: const Text('Schedule Outfit'),
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(AppSizes.paddingLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Scheduled Outfit',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 16),
              Card(
                color: AppColors.surface,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(AppSizes.paddingMd),
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
                    icon: const Icon(Icons.close, color: AppColors.error),
                    onPressed: () {
                      controller.removeScheduledOutfit(selectedDate);
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showOutfitPicker(BuildContext context, DateTime date) {
    final outfitController = context.read<OutfitController>();
    
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.radiusXl)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSizes.paddingLg),
                child: Text(
                  'Select Outfit',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              ...outfitController.outfits.map((outfit) {
                return ListTile(
                  title: Text(
                    outfit.name,
                    style: const TextStyle(color: AppColors.textPrimary),
                  ),
                  subtitle: Text(
                    outfit.occasion ?? 'No occasion',
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  onTap: () {
                    context.read<CalendarController>().scheduleOutfit(date, outfit);
                    Navigator.pop(context);
                  },
                );
              }),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }
}