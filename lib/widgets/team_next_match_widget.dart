import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
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
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(90),
              color: Colors.white24,
            ),
            child: teamLogo == null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(90),
                    child: Image.asset(
                      'assets/placeholder_image.png',
                      fit: BoxFit.cover,
                    ),
                  )
                : CachedNetworkImage(
                    imageUrl: teamLogo!,
                    placeholder: (context, url) =>
                        Image.asset('assets/placeholder_image.png'),
                    errorWidget: (context, url, error) =>
                        const Icon(CupertinoIcons.nosign, color: Colors.white),
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
