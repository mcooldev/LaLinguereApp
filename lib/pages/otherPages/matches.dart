import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:la_linguere/pages/otherPages/matches_tabview_pages/calendars_views/calendar_view.dart';
import 'package:la_linguere/pages/otherPages/matches_tabview_pages/ranking_views/ranking_view.dart';
import 'package:la_linguere/pages/otherPages/matches_tabview_pages/results_views/result_view.dart';
import 'package:la_linguere/widgets/matches_page_widget/last_match_played.dart';
import 'package:la_linguere/widgets/matches_page_widget/next_match.dart';
import 'package:provider/provider.dart';

import '../../providers/matches_provider.dart';
import '../../providers/navigation_provider.dart';
import '../../providers/next_match_provider.dart';
import '../../providers/ranking_provider.dart';
import '../../utils/constants/app_colors.dart';
import '../../widgets/matches_page_widget/actual_ranking_widget.dart';
import '../../widgets/navigation_widget.dart';

class Matches extends StatefulWidget {
  const Matches({super.key});

  @override
  State<Matches> createState() => _MatchesState();
}

class _MatchesState extends State<Matches> with SingleTickerProviderStateMixin {
  ///
  late MatchesProvider matchesProvider;

  @override
  void initState() {
    super.initState();
    //
    matchesProvider = Provider.of<MatchesProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //
      if (!mounted) return;
      context.read<MatchesProvider>().initTabController(this);
      //
      await Future.wait([
        context.read<NextMatchProvider>().fetchNextMatch(),
        context.read<MatchesProvider>().fetchCalendar(),
        context.read<MatchesProvider>().fetchResults(),
      ]);
      //
      if (!mounted) return;
      context.read<NavigationProvider>().currentIndex = 1;
    });
  }

  @override
  void dispose() {
    matchesProvider.resetTabIndex();
    super.dispose();
  }

  ///
  @override
  Widget build(BuildContext context) {
    ///
    final theme = Theme.of(context);
    bool isLoading = Provider.of<NextMatchProvider>(
      context,
      listen: false,
    ).isLoading;
    final rankingProvider = context.watch<RankingProvider>();

    ///
    return Consumer<MatchesProvider>(
      builder: (_, prov, _) {
        if (prov.tabController == null) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        return Scaffold(
          /// Body content
          body: Stack(
            fit: StackFit.expand,
            children: [
              /// Nested scroll view
              NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      backgroundColor: darkBlue,
                      expandedHeight: 370,
                      pinned: true,
                      floating: false,
                      centerTitle: true,
                      title: Text(
                        prov.appBarTitle,
                        style: const TextStyle(color: Colors.white),
                      ),
                      automaticallyImplyLeading: false,

                      /// App bar content
                      flexibleSpace: FlexibleSpaceBar(
                        background: Stack(
                          fit: StackFit.expand,
                          children: [
                            /// Images background
                            Image.asset(
                              (prov.tabController != null &&
                                      prov.tabController!.index != 2)
                                  ? 'assets/next_match_bg.png'
                                  : 'assets/ll_banner_image.webp',
                              fit: BoxFit.cover,
                            ),

                            /// Background gradient overlay
                            if (prov.tabController != null &&
                                prov.tabController!.index == 2)
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    stops: const [0.0, 1.0],
                                    colors: [
                                      Colors.black.withValues(alpha: 0.3),
                                      Colors.black.withValues(alpha: 0.75),
                                    ],
                                  ),
                                ),
                              ),

                            /// Bottom content
                            Positioned(
                              bottom: 75,
                              left: 20,
                              right: 20,
                              child:
                                  (prov.tabController != null &&
                                      prov.tabController!.index == 0)
                                  ? const NextMatch()
                                  : (prov.tabController != null &&
                                        prov.tabController!.index == 1)
                                  ? LastMatchPlayed(
                                      theme: theme,
                                      isLoading: isLoading,
                                      result: prov.linguereResult,
                                    )
                                  : ActualRankingWidget(
                                      rankingProvider: rankingProvider,
                                    ),
                            ),
                          ],
                        ),
                      ),

                      /// Tab bar items
                      bottom: PreferredSize(
                        preferredSize: const Size.fromHeight(50),
                        child: Container(
                          color: Colors.white,
                          child: TabBar(
                            controller: prov.tabController,
                            labelStyle: GoogleFonts.manrope(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            splashBorderRadius: BorderRadius.circular(90),
                            tabs: [
                              const Tab(text: 'Calendrier'),
                              const Tab(text: 'Résultats'),
                              const Tab(text: 'Classement'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ];
                },
                body: Column(
                  children: [
                    /// Competition categories (Ligue 1, Coupe du Sénégal)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: lightBg,
                        border: Border(
                          bottom: BorderSide(width: 1, color: lightStrokeColor),
                        ),
                      ),
                      child: Row(
                        children: List.generate(
                          prov.matchesViewTitles.length,
                          (i) => Expanded(
                            child: GestureDetector(
                              onTap: () {
                                prov.matchesViewIndex = i;
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: i == 1 ? 0 : 8),
                                height: 44,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: prov.matchesViewIndex == i
                                      ? darkBlue
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(90),
                                ),
                                child: Text(
                                  prov.matchesViewTitles[i],
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: theme.textTheme.labelLarge!.copyWith(
                                    color: prov.matchesViewIndex == i
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

                    /// Tab bar views
                    Expanded(
                      child: TabBarView(
                        controller: prov.tabController,
                        children: [
                          // Calendar view
                          const CalendarView(),
                          // Results view
                          const ResultView(),
                          // Ranking view
                          const RankingView(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              /// Floating navigation
              const NavigationWidget(),
            ],
          ),
        );
      },
    );
  }
}
