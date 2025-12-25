import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../providers/ranking_provider.dart';
import '../../utils/constants/app_colors.dart';

class ActualRankingWidget extends StatelessWidget {
  const ActualRankingWidget({super.key, required this.rankingProvider});

  final RankingProvider rankingProvider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 55,
          child: Image.asset('assets/ll_splash_icon_transparent.png'),
        ),
        const SizedBox(height: 4),
        Text(
          'ASCE La Linguere',
          style: GoogleFonts.manrope(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text.rich(
          TextSpan(
            text: 'Place actuelle : ',
            style: GoogleFonts.manrope(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Colors.white70,
            ),
            children: [
              TextSpan(
                text: "${rankingProvider.ranking?.place ?? '00'}e",
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: yellowLinguere,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
