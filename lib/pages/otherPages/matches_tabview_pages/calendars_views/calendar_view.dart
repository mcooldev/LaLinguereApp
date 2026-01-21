import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:la_linguere/providers/matches_provider.dart';
import 'package:la_linguere/utils/constants/app_colors.dart';
import 'package:provider/provider.dart';

import '../../../../providers/next_match_provider.dart';
import '../../../../widgets/matches_page_widget/coming_match_widget.dart';

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
                if (prov.matchesViewIndex == 0)
                  if (prov.isLoading)
                    Center(
                      child: Column(
                        children: [
                          const CircularProgressIndicator.adaptive(),
                          const SizedBox(height: 16),
                          Text(
                            'Chargement des données...',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    )
                  else
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
                                prov.isLoading
                                    ? "...e Journée"
                                    : "$val$suffixDay Journée",
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
                        return ComingMatchWidget(
                          theme: theme,
                          date: date,
                          calendar: calendar,
                          isLoading: prov.isLoading,
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
