import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:la_linguere/widgets/team_next_match_widget.dart';

import '../utils/constants/app_colors.dart';

class NextMatchWidget extends StatelessWidget {
  const NextMatchWidget({
    super.key,
    required this.theme,
    required this.competitionLogo,
    required this.competitionName,
    required this.day,
    required this.matchTime,
    required this.teamLogoHome,
    required this.teamNameHome,
    required this.teamLogoAway,
    required this.teamNameAway,
    required this.onTapLiveWatch,
    required this.onTapSeeOtherMatch,
  });

  final ThemeData theme;
  final String competitionLogo,
      competitionName,
      day,
      matchTime,
      teamLogoHome,
      teamNameHome,
      teamLogoAway,
      teamNameAway;
  final void Function() onTapLiveWatch;
  final void Function() onTapSeeOtherMatch;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/next_match_bg.png'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          /// competition name and day
          Row(
            children: [
              /// competition logo
              CircleAvatar(
                radius: 24,
                backgroundImage: AssetImage(competitionLogo),
              ),
              const SizedBox(width: 8),

              /// competition name
              Text(
                competitionName,
                style: theme.textTheme.titleSmall!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),

              /// day
              Text(
                '${day}e Journée',
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
              TeamNextMatchWidget(
                theme: theme,
                teamLogo: teamLogoHome,
                teamName: teamNameHome,
                isHome: true,
              ),
              // VS and time
              Column(
                children: [
                  Text(
                    'VS',
                    style: theme.textTheme.bodyLarge!.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(90),
                    ),
                    child: Text(
                      matchTime,
                      style: theme.textTheme.labelSmall!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),

              // team 2
              TeamNextMatchWidget(
                theme: theme,
                teamLogo: teamLogoAway,
                teamName: teamNameAway,
                isHome: false,
              ),
            ],
          ),
          const SizedBox(height: 20),

          /// live watch btn & see other match btn
          MaterialButton(
            onPressed: onTapLiveWatch,
            color: redLaLinguere,
            height: 48,
            minWidth: double.infinity,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(90),
              side: const BorderSide(width: 1, color: Colors.white24),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Suivre le match',
                  style: theme.textTheme.labelLarge!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 10),
                SvgPicture.asset('assets/live_video_icon.svg'),
              ],
            ),
          ),
          const SizedBox(height: 8),
          MaterialButton(
            onPressed: onTapSeeOtherMatch,
            color: Colors.transparent,
            height: 48,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(90),
              side: const BorderSide(width: 1, color: Colors.white24),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Voir les autres matchs',
                  style: theme.textTheme.labelLarge!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(
                  CupertinoIcons.arrow_right,
                  color: Colors.white,
                  size: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
