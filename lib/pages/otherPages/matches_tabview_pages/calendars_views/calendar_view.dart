import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:la_linguere/providers/matches_provider.dart';
import 'package:la_linguere/utils/constants/app_colors.dart';
import 'package:provider/provider.dart';

import '../../../../providers/next_match_provider.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
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
            await Future.wait([
              context.read<NextMatchProvider>().refreshNextMatch(),
              prov.refreshCalendar(),
            ]);
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Matchs à venir', style: theme.textTheme.titleLarge),
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
                  GroupedListView(
                    key: UniqueKey(),
                    padding: const EdgeInsets.all(0),
                    useStickyGroupSeparators: false,
                    elements: prov.calendarList,
                    //
                    groupBy: (calendar) => calendar.day.startsWith('J')
                        ? calendar.day.substring(1)
                        : calendar.day,
                    //
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    //
                    groupSeparatorBuilder: (String val) {
                      //
                      String suffixDay = (val == "1") ? "ère" : "e";

                      //
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: yellowLinguere,
                              borderRadius: BorderRadius.circular(60),
                            ),
                            child: Text(
                              "$val$suffixDay Journée",
                              style: theme.textTheme.labelSmall!.copyWith(
                                color: darkBlue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    //
                    floatingHeader: false,
                    itemBuilder: (context, calendar) {
                      //
                      final date =
                          "${prov.dateFormat(calendar.dateMatch).split(" ")[0]} ${prov.dateFormat(calendar.dateMatch).split(" ")[1]}";
                      //
                      return Container(
                        margin: const EdgeInsets.only(bottom: 24),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
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
                                          style: theme.textTheme.labelSmall!
                                              .copyWith(
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
                                          style: theme.textTheme.bodyLarge!
                                              .copyWith(color: Colors.black),
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
                                            borderRadius: BorderRadius.circular(
                                              90,
                                            ),
                                          ),
                                          child: Text(
                                            date,
                                            style: theme.textTheme.labelSmall!
                                                .copyWith(
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
                                            image: NetworkImage(
                                              calendar.opposingTeamLogo,
                                            ),
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
                                            style: theme.textTheme.labelSmall!
                                                .copyWith(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        CircleAvatar(
                                          radius: 24,
                                          child: Image(
                                            image: NetworkImage(
                                              calendar.opposingTeamLogo,
                                            ),
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
                                          style: theme.textTheme.bodyLarge!
                                              .copyWith(color: Colors.black),
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
                                            borderRadius: BorderRadius.circular(
                                              90,
                                            ),
                                          ),
                                          child: Text(
                                            date,
                                            style: theme.textTheme.labelSmall!
                                                .copyWith(
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
                                          style: theme.textTheme.labelSmall!
                                              .copyWith(
                                                fontWeight: FontWeight.w600,
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
                        Text('Pas de match pour le moment'),
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
