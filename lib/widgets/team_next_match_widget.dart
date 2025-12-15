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
  final String? teamLogo;
  final String teamName;
  final bool isHome;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.35,
      child: Column(
        children: [
          /// team logo
          Container(
            height: 50,
            width: 50,
            clipBehavior: Clip.none,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(90),
              image: DecorationImage(
                image: teamLogo!.isNotEmpty && teamLogo != null
                    ? NetworkImage(teamLogo!)
                    : const AssetImage('assets/placeholder_image.png')
                          as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 4),

          /// team name
          Text(
            teamName,
            textAlign: TextAlign.center,
            maxLines: 2,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
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
      ),
    );
  }
}
