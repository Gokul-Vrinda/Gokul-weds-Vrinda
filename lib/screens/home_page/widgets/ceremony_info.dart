import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:gokul_weds_vrinda/const/app_colors.dart'; // adjust path to your ScreenHelper
import 'package:gokul_weds_vrinda/const/screen_helper.dart';
import 'package:google_fonts/google_fonts.dart';

class CeremonyInfo extends StatelessWidget {
  const CeremonyInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = ScreenHelper.isMobile(context);
    final double screenW = ScreenHelper.screenSize(context).width;

    // Web: 700 (as before). Tab: 700 or a bit smaller on narrow tablets.
    // Mobile: full width with a small side margin.
    // final double cardWidth = isMobile
    //     ? screenW - 32
    //     : (screenW - 80).clamp(0, 700).toDouble();
    final double cardWidth = isMobile
        ? math.max(0.0, screenW - 32)
        : math.min(700.0, math.max(0.0, screenW - 80));

    final double nameSize = isMobile ? 16 : 18;
    final double smallSize = isMobile ? 12 : 13;
    final double labelSize = isMobile ? 13 : 14;

    final Widget sasiFamily = _parentsColumn(
      labelSize: labelSize,
      nameSize: nameSize,
      smallSize: smallSize,
      father: "Sasi K.C ( Late )",
      mother: "Bindu Sasi",
      house: "Kuzhikkattumolathu (h) Pazhamthottam",
    );
    final Widget sajeevanFamily = _parentsColumn(
      labelSize: labelSize,
      nameSize: nameSize,
      smallSize: smallSize,
      father: "T.S Sajeevan",
      mother: "Sunitha Sajeevan",
      house: "Thoppil (h) Thaykkattukara , Aluva",
    );

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          width: cardWidth,
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 20,
            vertical: isMobile ? 40 : 60,
          ),
          decoration: BoxDecoration(
            color: AppColors.landingDeepRed,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            spacing: isMobile ? 24 : 30,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "CEREMONY INFO",
                style: GoogleFonts.tinos(
                  fontSize: isMobile ? 18 : 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: const Color(0xFFF6EADB),
                ),
              ),

              // Parents: stacked on mobile, side by side on tab / web
              if (isMobile)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    sasiFamily,
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: SizedBox(
                        width: 50,
                        child: Divider(
                          height: 1,
                          color: AppColors.landingCard.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                    sajeevanFamily,
                  ],
                )
              // Row(
              //   spacing: 10,
              //   mainAxisSize: MainAxisSize.min,
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   children: [
              //     Flexible(child: sasiFamily),
              //     SizedBox(
              //       height: 50,
              //       child: VerticalDivider(
              //         width: 40,
              //         color: AppColors.landingCard.withValues(alpha: 0.6),
              //       ),
              //     ),
              //     Flexible(child: sajeevanFamily),
              //   ],
              // )
              else
                Row(
                  spacing: 10,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(child: sasiFamily),
                    SizedBox(
                      height: 50,
                      child: VerticalDivider(
                        width: 40,
                        color: AppColors.landingCard.withValues(alpha: 0.6),
                      ),
                    ),
                    Flexible(child: sajeevanFamily),
                  ],
                ),

              Text(
                "WE JOYFULLY ANNOUNCE\nTHE WEDDING OF OUR CHILDREN",
                textAlign: TextAlign.center,
                style: GoogleFonts.tinos(
                  fontSize: isMobile ? 13 : 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: AppColors.landingCard,
                ),
              ),
              const SizedBox(height: 10),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Gokul",
                    style: GoogleFonts.playfairDisplay(
                      fontSize: isMobile ? 48 : 64,
                      height: 1.0,
                      color: AppColors.landingCard,
                    ),
                  ),
                  SizedBox(height: isMobile ? 20 : 30),
                  Text(
                    "GROOM",
                    style: GoogleFonts.tinos(
                      fontSize: smallSize,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                      color: AppColors.landingCard.withValues(alpha: 0.6),
                    ),
                  ),
                  SizedBox(height: isMobile ? 16 : 24),
                  Text(
                    "&",
                    style: GoogleFonts.mrDeHaviland(
                      fontSize: isMobile ? 40 : 52,
                      fontStyle: FontStyle.italic,
                      color: AppColors.landingCard,
                    ),
                  ),
                  SizedBox(height: isMobile ? 16 : 24),
                  Text(
                    "Vrinda",
                    style: GoogleFonts.playfairDisplay(
                      fontSize: isMobile ? 48 : 64,
                      height: 1.0,
                      color: AppColors.landingCard,
                    ),
                  ),
                  SizedBox(height: isMobile ? 20 : 30),
                  Text(
                    "BRIDE",
                    style: GoogleFonts.tinos(
                      fontSize: smallSize,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                      color: AppColors.landingCard.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Flower: only on tab and web, fixed values exactly as the original
        if (!isMobile)
          Positioned(
            bottom: 250,
            left: 300,
            child: IgnorePointer(
              child: Transform.rotate(
                angle: 0.3,
                child: Image.asset(
                  "assets/images/Flower.png",
                  width: 800,
                  height: 680,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _parentsColumn({
    required double labelSize,
    required double nameSize,
    required double smallSize,
    required String father,
    required String mother,
    required String house,
  }) {
    final nameStyle = GoogleFonts.tinos(
      fontSize: nameSize,
      fontWeight: FontWeight.bold,
      color: AppColors.landingCard,
    );
    TextStyle softStyle(double size) => GoogleFonts.tinos(
      fontSize: size,
      color: AppColors.landingCard.withValues(alpha: 0.6),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Mr. & Mrs.", style: softStyle(labelSize)),
        const SizedBox(height: 6),
        Text(father, textAlign: TextAlign.center, style: nameStyle),
        const SizedBox(height: 6),
        Text(mother, textAlign: TextAlign.center, style: nameStyle),
        const SizedBox(height: 6),
        Text(house, textAlign: TextAlign.center, style: softStyle(smallSize)),
      ],
    );
  }
}
