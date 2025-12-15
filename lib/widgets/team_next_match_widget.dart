import 'package:flutter/material.dart';

class TeamNextMatchWidget extends StatelessWidget {
  const TeamNextMatchWidget({
    super.key,
    required this.theme,
    required this.teamLogo,
    required this.teamName,
    required this.isHome,
  });

  final ThemeData theme;
  final String teamLogo;
  final String teamName;
  final bool isHome;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// team logo
        Container(
          height: 50,
          width: 44,
          clipBehavior: Clip.none,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(teamLogo),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 4),

        /// team name
        Text(
          teamName,
          style: theme.textTheme.labelMedium!.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),

        /// home or away
        Text(
          isHome ? 'Domicile' : 'Exterieur',
          style: theme.textTheme.labelSmall!.copyWith(
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
