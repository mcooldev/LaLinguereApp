import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../providers/navigation_provider.dart';
import '../../providers/next_match_provider.dart';
import '../../utils/constants/app_colors.dart';
import '../team_next_match_widget.dart';

class NextMatch extends StatefulWidget {
  const NextMatch({super.key});

  @override
  State<NextMatch> createState() => _NextMatchState();
}

class _NextMatchState extends State<NextMatch> {
  @override
  Widget build(BuildContext context) {
    ///
    final theme = Theme.of(context);
    final navProvider = Provider.of<NavigationProvider>(context, listen: false);

    ///
    return Consumer<NextMatchProvider>(
      builder: (_, prov, _) {
        //
        final nextMatch = prov.nextMatch;
        final isLoading = prov.isLoading;
        //
        return Column(
          children: [
            /// competition name and day
            Row(
              children: [
                /// competition logo
                Container(
                  width: 50,
                  height: 50,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(90),
                  ),
                  child: (nextMatch?.competitionLogo == null || isLoading)
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
                  isLoading ? 'Ligue...' : nextMatch!.competitionName,
                  style: theme.textTheme.titleSmall!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),

                /// day
                Text(
                  isLoading ? '...e Journée' : '${nextMatch?.day}e Journée',
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
                    teamLogo: nextMatch?.teamLogoHome,
                    teamName: nextMatch?.teamNameHome ?? "",
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
                          nextMatch?.matchTime ?? "00:00",
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
                    teamName: nextMatch?.teamNameAway ?? "",
                    isHome: false,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            /// live watch btn
            MaterialButton(
              onPressed: () {
                navProvider.showBottomSheet(
                  context: context,
                  onTapBtn: () {
                    navProvider.goToUrl(
                      url: "https://www.youtube.com/@ascelinguere8675/featured",
                    );
                    //
                    Navigator.pop(context);
                  },
                  btnText: 'Continuer vers la chaine Youtube',
                  title: "Live Match  📺  🎥",
                  bodyContent:
                      "Vous allez être redirigé vers notre chaine Youtube pour suivre le match.",
                  widget: Container(
                    height: 60,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    decoration: BoxDecoration(
                      color: lightBg,
                      borderRadius: BorderRadius.circular(90),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // logo linguere
                        Flexible(
                          child: Image.asset(
                            'assets/ll_logo_h.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),

                        // arrow
                        SvgPicture.asset('assets/arrow_right_livewatch.svg'),
                        const SizedBox(width: 12),

                        // logo diotali
                        SvgPicture.asset('assets/logo_youtube.svg'),
                      ],
                    ),
                  ),
                );
              },
              color: redLaLinguere,
              height: 48,
              minWidth: double.infinity,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(90),
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
          ],
        );
      },
    );
  }
}
