import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:la_linguere/models/ranking_model.dart';

import '../utils/constants/app_colors.dart';

class RankingHomeWidget extends StatelessWidget {
  const RankingHomeWidget({
    super.key,
    required this.rankingModel,
    required this.theme,
  });

  final ThemeData theme;

  final RankingModel? rankingModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/classement_bg.png'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
      child: Row(
        children: [
          // Position
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                rankingModel?.place.toString().padLeft(2, '0') ?? '00',
                style: theme.textTheme.titleMedium!.copyWith(
                  color: Colors.white,
                ),
              ),
              Text(
                'PLACE',
                style: theme.textTheme.labelSmall!.copyWith(
                  color: yellowLinguere,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          // Points
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                rankingModel?.points.toString().padLeft(2, '0') ?? '00',
                style: theme.textTheme.titleMedium!.copyWith(
                  color: Colors.white,
                ),
              ),
              Text(
                'POINTS',
                style: theme.textTheme.labelSmall!.copyWith(
                  color: yellowLinguere,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          // Played matches
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                rankingModel?.playedMatch.toString().padLeft(2, '0') ?? '00',
                style: theme.textTheme.titleMedium!.copyWith(
                  color: Colors.white,
                ),
              ),
              Text(
                'joués'.toUpperCase(),
                style: theme.textTheme.labelSmall!.copyWith(
                  color: yellowLinguere,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const Spacer(),

          // See all ranking btn
          MaterialButton(
            onPressed: () {
              // todo: see all ranking
            },
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
                  'Voir tous',
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
