import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:la_linguere/models/next_match_model.dart';
import 'package:la_linguere/widgets/team_next_match_widget.dart';

import '../utils/constants/app_colors.dart';

class NextMatchWidget extends StatelessWidget {
  const NextMatchWidget({
    super.key,
    required this.theme,
    required this.isLoading,
    required this.nextMatch,
    this.onTapLiveWatch,
    this.onTapSeeOtherMatch,
  });

  final ThemeData theme;
  final NextMatchModel? nextMatch;

  final bool isLoading;

  final void Function()? onTapLiveWatch;
  final void Function()? onTapSeeOtherMatch;

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
              Container(
                width: 50,
                height: 50,
                padding: const EdgeInsets.all(6),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(90),
                ),
                child: nextMatch == null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(90),
                        child: Image.asset(
                          'assets/placeholder_image.png',
                          fit: BoxFit.cover,
                        ),
                      )
                    : CachedNetworkImage(
                        imageUrl: nextMatch!.competitionLogo,
                        fit: BoxFit.contain,
                        placeholder: (context, url) =>
                            const CupertinoActivityIndicator(
                              color: Colors.white,
                            ),
                        errorWidget: (context, url, error) => const Icon(
                          CupertinoIcons.exclamationmark_circle,
                          color: Colors.white,
                        ),
                      ),
              ),
              const SizedBox(width: 8),

              /// competition name
              Text(
                nextMatch?.competitionName ?? '',
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
                flex: 2,
                child: TeamNextMatchWidget(
                  theme: theme,
                  teamLogo: nextMatch?.teamLogoHome ?? '',
                  teamName: nextMatch?.teamNameHome ?? 'Equipe dom.',
                  isHome: true,
                ),
              ),
              // VS and time
              Flexible(
                flex: 1,
                child: Column(
                  children: [
                    // VS
                    Text(
                      'VS',
                      style: theme.textTheme.bodyLarge!.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Time
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(90),
                      ),
                      child: Text(
                        nextMatch?.matchTime ?? '-N/C-',
                        style: theme.textTheme.labelSmall!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // team 2
              Flexible(
                flex: 2,
                child: TeamNextMatchWidget(
                  theme: theme,
                  teamLogo: nextMatch?.teamLogoAway,
                  teamName: nextMatch?.teamNameAway ?? 'Equipe ext.',
                  isHome: false,
                ),
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
          // See other match btn
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
