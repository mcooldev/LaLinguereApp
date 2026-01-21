import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:la_linguere/models/next_match_model.dart';
import 'package:la_linguere/widgets/team_next_match_widget.dart';

import '../utils/constants/app_colors.dart';

class NextMatchWomanWidget extends StatelessWidget {
  const NextMatchWomanWidget({
    super.key,
    required this.theme,
    required this.isLoading,
    required this.nextMatchWoman,
  });

  final ThemeData theme;
  final NextMatchWomanModel? nextMatchWoman;

  final bool isLoading;

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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(90),
                ),
                child: (nextMatchWoman == null || isLoading)
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(90),
                        child: Image.asset(
                          'assets/placeholder_image.png',
                          fit: BoxFit.cover,
                        ),
                      )
                    : CachedNetworkImage(
                        imageUrl: nextMatchWoman!.competitionLogo,
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
                isLoading
                    ? 'Ligue...'
                    : nextMatchWoman?.competitionName ?? 'Ligue...',
                style: theme.textTheme.titleSmall!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),

              /// day
              Text(
                isLoading
                    ? '...e Journée'
                    : '${nextMatchWoman?.day ?? '0'}e Journée',
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
                  teamLogo: nextMatchWoman?.teamLogoHome,
                  teamName: nextMatchWoman?.teamNameHome ?? 'Equipe dom.',
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
                        isLoading
                            ? "00:00"
                            : nextMatchWoman?.matchTime ?? '-N/C-',
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
                  teamLogo: nextMatchWoman?.teamLogoAway,
                  teamName: nextMatchWoman?.teamNameAway ?? 'Equipe ext.',
                  isHome: false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
