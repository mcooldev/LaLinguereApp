import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:la_linguere/models/all_rank_model.dart';

import '../../utils/constants/app_colors.dart';

class StandingListWidget extends StatelessWidget {
  const StandingListWidget({
    super.key,
    required this.theme,
    required this.bgColor,
    this.standing,
    required this.isHeader,
  });

  final ThemeData theme;
  final AllRankModel? standing;
  final bool isHeader;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    ///

    ///
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: bgColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// Rank, team name and logo
          Row(
            children: [
              // Position
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.white24,
                child: Text(
                  !isHeader ? standing!.rank.toString() : "#",
                  style: theme.textTheme.labelLarge!.copyWith(
                    color: !isHeader ? darkBlue : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Team logo
              if (!isHeader)
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.transparent,
                      child: standing == null
                          ? ClipRRect(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(90),
                              ),
                              child: Image.asset(
                                "assets/placeholder_image.png",
                              ),
                            )
                          : CachedNetworkImage(
                              imageUrl: standing!.teamLogo,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  Image.asset('assets/placeholder_image.png'),
                              errorWidget: (context, url, error) => Icon(
                                CupertinoIcons.photo,
                                color: strokeColor,
                              ),
                            ),
                    ),
                    const SizedBox(width: 6),
                  ],
                ),
              // Team name
              Text(
                !isHeader ? standing!.teamName : "Équipe",
                style: theme.textTheme.labelLarge!.copyWith(
                  color: !isHeader ? darkBlue : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          /// goalsDiff, points, played match
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // goalsDiff
              Text(
                !isHeader
                    ? standing!.goalsDiff.toString().padLeft(2, "0")
                    : "Gd",
                style: theme.textTheme.labelLarge!.copyWith(
                  color: !isHeader ? darkBlue : yellowLinguere,
                  fontWeight: isHeader ? FontWeight.normal : FontWeight.bold,
                ),
              ),
              SizedBox(width: isHeader ? 20 : 23),
              // points
              Text(
                !isHeader ? standing!.points.toString().padLeft(2, "0") : "Po",
                style: theme.textTheme.labelLarge!.copyWith(
                  color: !isHeader ? darkBlue : yellowLinguere,
                  fontWeight: isHeader ? FontWeight.normal : FontWeight.bold,
                ),
              ),
              SizedBox(width: isHeader ? 20 : 23),
              // played match
              Text(
                !isHeader
                    ? standing!.playedMatch.toString().padLeft(2, "0")
                    : "MJ",
                style: theme.textTheme.labelLarge!.copyWith(
                  color: !isHeader ? darkBlue : yellowLinguere,
                  fontWeight: isHeader ? FontWeight.normal : FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
