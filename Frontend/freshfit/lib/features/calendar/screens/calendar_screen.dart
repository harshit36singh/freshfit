import 'package:flutter/material.dart';
import 'package:freshfit/features/outfit/outfit_controller.dart';
import 'package:provider/provider.dart';
import '../calendar_controller.dart';

const _kBg = Color(0xFFF2EBE2);
const _kAccent = Color(0xFF614051);
const _kAccentFade = Color(0x99614051);

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
      backgroundColor: _kBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 10),
            _buildCalendar(),
            const SizedBox(height: 16),
            Expanded(child: _buildSelectedDayOutfit()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
      child: const Text(
        'Outfit Calendar',
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w900,
          color: _kAccent,
          letterSpacing: -1,
          height: 1.1,
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: _kAccent, width: 2),
      ),
      child: Column(
        children: [
          // Month nav row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => setState(() {
                  _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1);
                }),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: const Icon(Icons.chevron_left, color: _kAccent, size: 24),
                ),
              ),
              Text(
                '${_getMonthName(_focusedDay.month)} ${_focusedDay.year}',
                style: const TextStyle(
                  color: _kAccent,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              GestureDetector(
                onTap: () => setState(() {
                  _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1);
                }),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: const Icon(Icons.chevron_right, color: _kAccent, size: 24),
                ),
              ),
            ],
          ),

          // Divider
          Container(height: 2, color: _kAccent),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            child: const Text(
              'Tap a date to schedule an outfit',
              style: TextStyle(
                color: _kAccentFade,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedDayOutfit() {
    return Consumer<CalendarController>(
      builder: (context, controller, _) {
        final selectedDate = controller.selectedDate;
        final outfit = controller.getOutfitForDate(selectedDate);

        if (outfit == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: _kAccent, width: 2),
                  ),
                  child: const Icon(Icons.event_available, size: 40, color: _kAccent),
                ),
                const SizedBox(height: 16),
                const Text(
                  'No outfit scheduled',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: _kAccent,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => _showOutfitPicker(context, selectedDate),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: _kAccent,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: _kAccent, width: 2),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.add, color: _kBg, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Schedule Outfit',
                          style: TextStyle(
                            color: _kBg,
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Scheduled Outfit',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: _kAccent,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: _kAccent, width: 2),
                ),
                child: Row(
                  children: [
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
                    GestureDetector(
                      onTap: () => controller.removeScheduledOutfit(selectedDate),
                      child: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Icon(Icons.close, color: _kAccent, size: 20),
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
  }

  void _showOutfitPicker(BuildContext context, DateTime date) {
    final outfitController = context.read<OutfitController>();

    showModalBottomSheet(
      context: context,
      backgroundColor: _kBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
        side: BorderSide(color: _kAccent, width: 2),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),
                child: const Text(
                  'Select Outfit',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: _kAccent,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              Container(height: 2, color: _kAccent),
              ...outfitController.outfits.map((outfit) {
                return GestureDetector(
                  onTap: () {
                    context.read<CalendarController>().scheduleOutfit(date, outfit);
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: _kAccentFade, width: 1),
                      ),
                    ),
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
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
}