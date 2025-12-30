import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../providers/matches_provider.dart';
import '../../../../utils/constants/app_colors.dart';

class ResultView extends StatefulWidget {
  const ResultView({super.key});

  @override
  State<ResultView> createState() => _ResultViewState();
}

class _ResultViewState extends State<ResultView> {

  @override
  Widget build(BuildContext context) {
    ///
    final theme = Theme.of(context);

    ///
    return Consumer<MatchesProvider>(
      builder: (_, prov, _) {
        return RefreshIndicator(
          color: Colors.white,
          backgroundColor: darkBlue,
          elevation: 0,
          onRefresh: () async {
            await Future.wait([prov.refreshResults()]);
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Score des matchs joués',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                // Grouped list here
                if (prov.isLoading)
                  const Center(
                    child: Column(
                      children: [
                        CircularProgressIndicator.adaptive(),
                        SizedBox(height: 12),
                        Text('Chargement des matchs en cours...'),
                      ],
                    ),
                  )
                else if (prov.matchesViewIndex == 0)
                  ListView.builder(
                    itemCount: prov.resultsList.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final match = prov.resultsList[index];
                      //
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(width: 1, color: lightStrokeColor),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // team home
                            Expanded(
                              flex: 3,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Flexible(
                                    child: Text(
                                      match.teamHomeName,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: theme.textTheme.labelSmall!.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  CircleAvatar(
                                    radius: 18,
                                    backgroundColor: Colors.transparent,
                                    child: CachedNetworkImage(
                                      imageUrl: match.teamHomeLogo,
                                      placeholder: (context, url) =>
                                          Image.asset(
                                            'assets/placeholder_image.png',
                                          ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(
                                            CupertinoIcons.nosign,
                                            color: Colors.white,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // results
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: lightBg,
                                  borderRadius: BorderRadius.circular(90),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      match.teamHomeScore,
                                      style: GoogleFonts.manrope(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: redLaLinguere,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      ':',
                                      style: GoogleFonts.manrope(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: redLaLinguere,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      match.teamAwayScore,
                                      style: GoogleFonts.manrope(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: redLaLinguere,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // team away
                            Expanded(
                              flex: 3,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 18,
                                    backgroundColor: Colors.transparent,
                                    child: CachedNetworkImage(
                                      imageUrl: match.teamAwayLogo,
                                      placeholder: (context, url) =>
                                          Image.asset(
                                            'assets/placeholder_image.png',
                                          ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(
                                            CupertinoIcons.nosign,
                                            color: Colors.white,
                                          ),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      match.teamAwayName,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: theme.textTheme.labelSmall!
                                          .copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                else if (prov.matchesViewIndex == 1)
                  const Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 200,
                          width: 250,
                          child: Image(
                            image: AssetImage('assets/empty_goal.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                        Text('Pas de match joué pour le moment'),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
