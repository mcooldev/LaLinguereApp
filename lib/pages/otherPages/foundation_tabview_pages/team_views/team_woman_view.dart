import 'package:flutter/material.dart';
import 'package:la_linguere/widgets/next_match_woman_widget.dart';
import 'package:provider/provider.dart';

import '../../../../providers/next_match_provider.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../widgets/donate_widget.dart';

class TeamWomanView extends StatefulWidget {
  const TeamWomanView({super.key});

  @override
  State<TeamWomanView> createState() => _TeamWomanViewState();
}

class _TeamWomanViewState extends State<TeamWomanView> {
  @override
  Widget build(BuildContext context) {
    ///
    final theme = Theme.of(context);

    ///
    return Consumer<NextMatchProvider>(
      builder: (_, prov, _) {
        return RefreshIndicator(
          color: Colors.white,
          backgroundColor: darkBlue,
          elevation: 0,
          edgeOffset: 50,
          onRefresh: () async {
            await Future.wait([prov.refreshNextMatchWoman()]);
          },
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            padding: const EdgeInsets.fromLTRB(16.0, 94, 16, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // About
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: lightBg,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // headline
                      Text(
                        "À propos de l’équipe féminine",
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),

                      // body text
                      Text(
                        "Lorem ipsum dolor sit amet consectetur. Velit pharetra ac amet vel in rhoncus sodales tempor faucibus. Quam pharetra orci nunc mauris euismod id semper. Suspendisse morbi integer sagittis viverra blandit sed sed est. Scelerisque nisl diam facilisi velit et. Lacus in blandit amet elit.",
                        softWrap: true,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Next match
                Text("Prochain match", style: theme.textTheme.titleLarge),
                const SizedBox(height: 12),
                NextMatchWomanWidget(
                  theme: theme,
                  isLoading: prov.isLoadingWoman,
                  nextMatchWoman: prov.nextMatchWoman,
                ),
                const SizedBox(height: 24),

                // Donate
                DonateWidget(theme: theme),
              ],
            ),
          ),
        );
      },
    );
  }
}
