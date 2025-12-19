import 'package:flutter/material.dart';
import 'package:la_linguere/widgets/next_match_u15_widget.dart';
import 'package:provider/provider.dart';

import '../../../../providers/foundation_provider.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../widgets/donate_widget.dart';
import '../../../../widgets/ranking_home_widget.dart';

class TeamU15View extends StatefulWidget {
  const TeamU15View({super.key});

  @override
  State<TeamU15View> createState() => _TeamU15ViewState();
}

class _TeamU15ViewState extends State<TeamU15View> {
  @override
  Widget build(BuildContext context) {
    ///
    final theme = Theme.of(context);

    ///
    return Consumer<FoundationProvider>(
      builder: (_, prov, _) {
        return SingleChildScrollView(
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
                      "À propos de l’équipe U15",
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
              NextMatchU15Widget(
                theme: theme,
                isLoading: false,
                nextMatchU15: prov.nextMatchU15,
              ),
              const SizedBox(height: 24),

              // ranking
              Text("Classement", style: theme.textTheme.titleLarge),
              const SizedBox(height: 12),
              RankingHomeWidget(rankingModel: prov.rankingU15, theme: theme),

              const SizedBox(height: 24),

              // Donate
              DonateWidget(theme: theme),
            ],
          ),
        );
      },
    );
  }
}
