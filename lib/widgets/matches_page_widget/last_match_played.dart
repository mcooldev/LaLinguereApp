import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:la_linguere/models/result_model.dart';

import '../../utils/constants/app_colors.dart';
import '../team_next_match_widget.dart';

class LastMatchPlayed extends StatelessWidget {
  const LastMatchPlayed({
    super.key,
    required this.theme,
    required this.result,
    required this.isLoading,
  });

  final ThemeData theme;
  final ResultModel result;

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// competition name and day
              Row(
                children: [
                  /// competition logo
                  Container(
                    width: 50,
                    height: 50,
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(90),
                    ),
                    child: Image.asset(
                      "assets/logo_ligue_1.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 8),

                  /// competition name
                  Text(
                    'Ligue 1',
                    style: theme.textTheme.titleSmall!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),

                  /// day
                  Text(
                    'Journée -N/C-',
                    style: theme.textTheme.labelLarge!.copyWith(
                      color: yellowLinguere,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              /// teams
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // team 1
                  Flexible(
                    child: TeamNextMatchWidget(
                      theme: theme,
                      teamLogo: result.teamHomeLogo,
                      teamName: result.teamHomeName,
                      isHome: true,
                    ),
                  ),
                  // results
                  Flexible(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(90),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            result.teamHomeScore,
                            style: GoogleFonts.manrope(
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            ':',
                            style: GoogleFonts.manrope(
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            result.teamAwayScore,
                            style: GoogleFonts.manrope(
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // team 2
                  Flexible(
                    child: TeamNextMatchWidget(
                      theme: theme,
                      teamLogo: result.teamAwayLogo,
                      teamName: result.teamAwayName,
                      isHome: false,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          );
  }
}
