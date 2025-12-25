import 'package:flutter/material.dart';
import 'package:la_linguere/providers/all_rank_provider.dart';
import 'package:la_linguere/utils/constants/app_colors.dart';
import 'package:provider/provider.dart';

import '../../../../widgets/matches_page_widget/standing_list_widget.dart';

class RankingView extends StatefulWidget {
  const RankingView({super.key});

  @override
  State<RankingView> createState() => _RankingViewState();
}

class _RankingViewState extends State<RankingView> {
  ///
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AllRankProvider>().getAllStanding();
    });
  }

  ///
  @override
  Widget build(BuildContext context) {
    ///
    final theme = Theme.of(context);

    ///
    return Consumer<AllRankProvider>(
      builder: (_, prov, _) {
        return RefreshIndicator(
          color: Colors.white,
          backgroundColor: darkBlue,
          elevation: 0,
          //
          onRefresh: () async {
            await prov.refresh();
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(0, 24, 0, 120),
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// headline
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Classement actuel',
                    style: theme.textTheme.titleLarge,
                  ),
                ),
                const SizedBox(height: 16),

                /// Standing table header
                StandingListWidget(
                  theme: theme,
                  isHeader: true,
                  bgColor: darkBlue,
                ),

                /// Standing list
                ListView.builder(
                  itemCount: prov.standingList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, i) {
                    //
                    final standing = prov.standingList[i];
                    final color = i % 2 == 0 ? Colors.white : lightBlueBg;

                    //
                    return StandingListWidget(
                      theme: theme,
                      bgColor: color,
                      isHeader: false,
                      standing: standing,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
