import 'package:flutter/material.dart';
import 'package:la_linguere/models/calendar_model.dart';

import '../../utils/constants/app_colors.dart';

class ComingMatchWidget extends StatelessWidget {
  const ComingMatchWidget({
    super.key,
    required this.theme,
    required this.date,
    required this.calendar,
  });

  final CalendarModel calendar;

  final ThemeData theme;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(width: 1, color: strokeColor),
      ),
      child: calendar.isHome
          ? Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // la linguere team
                Expanded(
                  flex: 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "La Linguere",
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: theme.textTheme.labelSmall!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.transparent,
                        child: Image(
                          image: AssetImage(
                            "assets/ll_splash_icon_transparent.png",
                          ),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),

                // VS & date
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      // VS
                      Text(
                        'VS',
                        style: theme.textTheme.bodyLarge!.copyWith(
                          color: Colors.black,
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
                          date,
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

                // opposing team
                Expanded(
                  flex: 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CircleAvatar(
                        radius: 24,
                        child: Image(
                          image: NetworkImage(calendar.opposingTeamLogo),
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          calendar.opposingTeamName,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: theme.textTheme.labelSmall!.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // opposing team
                Expanded(
                  flex: 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          calendar.opposingTeamName,
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
                        radius: 24,
                        child: Image(
                          image: NetworkImage(calendar.opposingTeamLogo),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
                // VS & date
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      // VS
                      Text(
                        'VS',
                        style: theme.textTheme.bodyLarge!.copyWith(
                          color: Colors.black,
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
                          date,
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
                // la linguere team
                Expanded(
                  flex: 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.transparent,
                        child: Image(
                          image: AssetImage(
                            "assets/ll_splash_icon_transparent.png",
                          ),
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "La Linguere",
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: theme.textTheme.labelSmall!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
