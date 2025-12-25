import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/next_match_model.dart';
import '../../utils/constants/app_colors.dart';
import '../team_next_match_widget.dart';

class LastMatchPlayed extends StatelessWidget {
  const LastMatchPlayed({
    super.key,
    required this.theme,
    this.nextMatch,
    required this.isLoading,
  });

  final ThemeData theme;
  final NextMatchModel? nextMatch;

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator.adaptive(
              backgroundColor: Colors.white,
            ),
          )
        : Column(
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
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(90),
                    ),
                    child: nextMatch?.competitionLogo == null
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(90),
                      child: Image.asset(
                        'assets/placeholder_image.png',
                        fit: BoxFit.cover,
                      ),
                    )
                        : CachedNetworkImage(
                      imageUrl: nextMatch!.competitionLogo,
                      placeholder: (context, url) =>
                          Image.asset('assets/placeholder_image.png'),
                      errorWidget: (context, url, error) => const Icon(
                        CupertinoIcons.nosign,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  /// competition name
                  Text(
                    nextMatch?.competitionName ?? 'Aucune Compet.',
                    style: theme.textTheme.titleSmall!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),

                  /// day
                  Text(
                    '${nextMatch?.day ?? '0'}e Journée',
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
                      teamLogo: nextMatch?.teamLogoHome,
                      teamName: nextMatch?.teamNameHome ?? 'Equipe dom.',
                      isHome: true,
                    ),
                  ),
                  // VS and time
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
                            '1',
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
                            '2',
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
                      teamLogo: nextMatch?.teamLogoAway,
                      teamName: nextMatch?.teamNameAway ?? 'Equipe ext.',
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
