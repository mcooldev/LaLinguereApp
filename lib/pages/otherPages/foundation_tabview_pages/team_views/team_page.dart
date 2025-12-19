import 'package:flutter/material.dart';
import 'package:la_linguere/providers/foundation_provider.dart';
import 'package:la_linguere/utils/constants/app_colors.dart';
import 'package:provider/provider.dart';

class TeamPage extends StatefulWidget {
  const TeamPage({super.key});

  @override
  State<TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  @override
  Widget build(BuildContext context) {
    ///
    final theme = Theme.of(context);

    ///
    return Scaffold(
      body: Consumer<FoundationProvider>(
        builder: (_, prov, _) {
          return Stack(
            children: [
              /// Views
              PageView(children: [prov.teamPages[prov.teamPageIndex]]),

              /// Category (history, woman team, U15)
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: lightBg,
                    border: Border(
                      bottom: BorderSide(width: 1, color: strokeColor),
                    ),
                  ),
                  child: Row(
                    children: List.generate(
                      prov.teamPageTitles.length,
                      (i) => Expanded(
                        child: GestureDetector(
                          onTap: () {
                            prov.teamPageIndex = i;
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: i == 2 ? 0 : 8),
                            height: 44,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: prov.teamPageIndex == i
                                  ? darkBlue
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(90),
                            ),
                            child: Text(
                              prov.teamPageTitles[i],
                              style: theme.textTheme.labelLarge!.copyWith(
                                color: prov.teamPageIndex == i
                                    ? Colors.white
                                    : bodyText,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
