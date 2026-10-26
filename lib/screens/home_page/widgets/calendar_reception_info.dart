import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CalendarReceptionInfo extends StatelessWidget {
  const CalendarReceptionInfo({super.key});
  static const int year = 2026;
  static const int month = 11;
  static const int highlightDay = 15;

  static const Color maroon = Color(0xFF4A0E1A);
  static const Color cream = Color(0xFFECE7DA);
  static const Color lineLight = Color(0xFFD5C3BC);

  static const List<String> weekdays = [
    'Mo',
    'Tu',
    'We',
    'Th',
    'Fr',
    'Sa',
    'Su',
  ];

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(year, month, 1);
    final daysInMonth = DateTime(year, month + 1, 0).day; // 30
    final leadingBlanks = firstDay.weekday - 1; // Monday = 0 blanks
    final totalCells = leadingBlanks + daysInMonth;

    return Container(
      constraints: const BoxConstraints(maxWidth: 450),
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      decoration: BoxDecoration(
        color: cream,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          Text(
            'November 2026',
            style: GoogleFonts.theNautigal(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w400,
              letterSpacing: 1.1,
              fontSize: 26,
              color: maroon,
            ),
          ),
          const SizedBox(height: 12),
          Container(height: 1, color: lineLight),
          const SizedBox(height: 12),

          // Weekday headers
          Row(
            children: weekdays
                .map(
                  (d) => Expanded(
                    child: Center(
                      child: Text(
                        d,
                        style: GoogleFonts.tinos(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 1.1,
                          color: maroon.withValues(alpha: 0.55),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 10),
          Container(height: 2, color: maroon),
          const SizedBox(height: 8),

          // Days grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: totalCells,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisExtent: 52,
            ),
            itemBuilder: (context, index) {
              if (index < leadingBlanks) return const SizedBox.shrink();
              final day = index - leadingBlanks + 1;
              return _DayCell(day: day, isHighlighted: day == highlightDay);
            },
          ),
        ],
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  final int day;
  final bool isHighlighted;

  const _DayCell({required this.day, required this.isHighlighted});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (isHighlighted)
            const Icon(
              Icons.favorite,
              size: 44,
              color: CalendarReceptionInfo.maroon,
            ),
          Text(
            '$day',
            style: GoogleFonts.tinos(
              fontSize: 16,
              letterSpacing: 1.1,
              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.w500,
              color: isHighlighted
                  ? CalendarReceptionInfo.cream
                  : CalendarReceptionInfo.maroon,
            ),
          ),
        ],
      ),
    );
  }
}
