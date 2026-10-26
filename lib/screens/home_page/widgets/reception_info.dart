import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gokul_weds_vrinda/const/app_colors.dart';
import 'package:gokul_weds_vrinda/const/screen_helper.dart';
import 'package:gokul_weds_vrinda/screens/home_page/widgets/calendar_reception_info.dart';
import 'package:google_fonts/google_fonts.dart';

class ReceptionInfo extends StatefulWidget {
  const ReceptionInfo({super.key});

  @override
  State<ReceptionInfo> createState() => _ReceptionInfoState();
}

class _ReceptionInfoState extends State<ReceptionInfo> {
  final DateTime _target = DateTime(2026, 11, 15);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Just triggers a rebuild every second
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final diff = _target.difference(now);

    final dayAfter = DateTime(2026, 11, 16);

    final isBefore = diff > Duration.zero;
    final isToday = !isBefore && now.isBefore(dayAfter);

    final days = diff.inDays;
    final hours = diff.inHours % 24;
    final minutes = diff.inMinutes % 60;
    final seconds = diff.inSeconds % 60;

    String label;
    String message;

    if (isBefore) {
      label = 'Countdown';
      message = '$days days $hours hours $minutes min $seconds sec';
    } else if (isToday) {
      label = "The Big Day";
      message = 'We\'re getting married today!';
    } else {
      label = 'Just Married';
      message = 'Thank you for celebrating with us!';
    }

    final bool isMobile = ScreenHelper.isMobile(context);
    final double screenW = ScreenHelper.screenSize(context).width;

    // Web: 700 (as before). Tab: 700 or a bit smaller on narrow tablets.
    // Mobile: full width with a small side margin.
    final double cardWidth = isMobile
        ? screenW - 32
        : (screenW - 80).clamp(0, 800).toDouble();

    final double fontSize = (screenW * 0.045).clamp(20.0, 34.0).toDouble();

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          width: cardWidth,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          decoration: BoxDecoration(
            color: AppColors.landingDeepRed,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'RECEPTION INFO',
                style: GoogleFonts.tinos(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: const Color(0xFFF6EADB),
                ),
              ),
              Text(
                'THE RECEPTION WILL TAKE PLACE\u00A0AT:',
                textAlign: TextAlign.center,
                style: GoogleFonts.tinos(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w400,
                  letterSpacing: fontSize * 0.032,
                  height: 1.25,
                  color: const Color(0xFFF6EADB),
                ),
              ),
              Row(
                spacing: 45,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "05:30",
                    style: GoogleFonts.tinos(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1.1,
                      color: const Color(0xFFF6EADB).withValues(alpha: 0.6),
                    ),
                  ),
                  Text(
                    "SUNDAY",
                    style: GoogleFonts.tinos(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1.1,
                      color: const Color(0xFFF6EADB).withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "15",
                    style: GoogleFonts.libreCaslonText(
                      fontSize: 48,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1.1,
                      color: const Color(0xFFF6EADB),
                    ),
                  ),
                  SizedBox(
                    height: 60,
                    child: VerticalDivider(
                      width: 40,
                      color: AppColors.landingCard,
                    ),
                  ),
                  Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "NOVEMBER",
                        style: GoogleFonts.tinos(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.1,
                          color: const Color(0xFFF6EADB),
                        ),
                      ),
                      Text(
                        "2026",
                        style: GoogleFonts.libreCaslonText(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 1.1,
                          color: const Color(0xFFF6EADB),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                label,
                style: GoogleFonts.tinos(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1.1,
                  color: const Color(0xFFF6EADB).withValues(alpha: 0.6),
                ),
              ),
              Text(
                message,
                //'$days days $hours hours $minutes min $seconds sec',
                style: GoogleFonts.tinos(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1.1,
                  color: const Color(0xFFF6EADB),
                ),
              ),

              CalendarReceptionInfo(),
              SizedBox(height: 50),
            ],
          ),
        ),
        Positioned(
          bottom: 200,
          right: 450,
          child: IgnorePointer(
            child: Transform.rotate(
              angle: 0.3,
              child: Image.asset(
                "assets/images/Flower.png",
                width: 700,
                height: 580,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
