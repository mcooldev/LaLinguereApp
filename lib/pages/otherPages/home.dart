import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:la_linguere/models/news_model.dart';
import 'package:la_linguere/pages/otherPages/foundation.dart';
import 'package:la_linguere/pages/otherPages/matches.dart';
import 'package:la_linguere/pages/otherPages/news_details.dart';
import 'package:la_linguere/providers/foundation_provider.dart';
import 'package:la_linguere/utils/constants/app_colors.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_providers/authentication_provider.dart';
import '../../providers/navigation_provider.dart';
import '../../providers/news_provider.dart';
import '../../providers/next_match_provider.dart';
import '../../providers/ranking_provider.dart';
import '../../widgets/navigation_widget.dart';
import '../../widgets/news_widget.dart';
import '../../widgets/next_match_widget.dart';
import '../../widgets/ranking_home_widget.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ///

  @override
  void initState() {
    super.initState();

    ///
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      //
      await Future.wait([
        context.read<NextMatchProvider>().fetchNextMatch(),
        context.read<RankingProvider>().fetchRanking(),
        context.read<NewsProvider>().fetchAllNews(),
      ]);
      //
      if (!mounted) return;
      context.read<NavigationProvider>().currentIndex = 0;
      context.read<FoundationProvider>().teamPageIndex = 0;
    });
  }

  ///
  @override
  Widget build(BuildContext context) {
    ///
    final theme = Theme.of(context);
    final navProvider = context.watch<NavigationProvider>();
    final loginProvider = Provider.of<LoginProvider>(context);

    ///
    return Scaffold(
      /// App bar
      appBar: AppBar(
        //
        automaticallyImplyActions: false,
        leading: const SizedBox.shrink(),
        leadingWidth: 0,

        /// Greeting and name
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // logo linguere
            CircleAvatar(
              radius: 26,
              backgroundColor: lightBg,
              child: SizedBox(
                height: 30,
                child: Image.asset(
                  'assets/ll_splash_icon_transparent.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(width: 10),

            // greetings
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  navProvider.greeting,
                  style: theme.textTheme.labelLarge!.copyWith(color: bodyText),
                ),
                Text(
                  loginProvider.user?.fullName.toString().split(" ")[0] ??
                      "Invité",
                  style: theme.textTheme.titleSmall!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
        //
        actionsPadding: const EdgeInsets.only(right: 16),

        /// Actions Btns
        actions: [
          /// Notification btn
          GestureDetector(
            onTap: () {
              //  todo: Notification
            },
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(90),
                border: Border.all(width: 1, color: lightStrokeColor),
              ),
              child: Icon(CupertinoIcons.bell, color: darkBlue, size: 20),
            ),
          ),
          const SizedBox(width: 8),

          /// shop btn
          GestureDetector(
            onTap: () {
              //  todo: Go to shop
              navProvider.showBottomSheet(
                context: context,
                onTapBtn: () {
                  // todo: go to la linguere website shop
                  navProvider.goToUrl(url: "https://lalinguere.net/boutique");
                  //
                  Navigator.pop(context);
                },
                btnText: "Continuer vers le site officiel",
                title: "Boutique 🛍️",
                bodyContent:
                    "Vous allez être redirigé vers le site officiel de La Linguere pour faire vos boutiques.",
                widget: Container(
                  height: 70,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  decoration: BoxDecoration(
                    color: lightBg,
                    borderRadius: BorderRadius.circular(90),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // logo phone
                      SvgPicture.asset('assets/icon_phone.svg'),
                      const SizedBox(width: 12),

                      // arrow
                      SvgPicture.asset('assets/arrow_right_shop.svg'),
                      const SizedBox(width: 12),

                      // logo web
                      SvgPicture.asset('assets/icon_www.svg'),
                    ],
                  ),
                ),
              );
            },
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(90),
                border: Border.all(width: 1, color: lightStrokeColor),
              ),
              child: Icon(CupertinoIcons.cart_badge_plus, color: darkBlue),
            ),
          ),
        ],
        //
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(16),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1, color: lightStrokeColor),
              ),
            ),
          ),
        ),
      ),

      /// body
      body: Stack(
        children: [
          /// Body content
          RefreshIndicator(
            color: Colors.white,
            backgroundColor: darkBlue,
            elevation: 0,
            edgeOffset: 0.1,
            onRefresh: () async {
              await Future.wait([
                context.read<NewsProvider>().refreshNews(),
                context.read<RankingProvider>().refreshRanking(),
                context.read<NextMatchProvider>().refreshNextMatch(),
              ]);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Next match headline
                  Text('Prochain match', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),

                  /// Next match widget
                  Consumer<NextMatchProvider>(
                    builder: (_, prov, _) {
                      return NextMatchWidget(
                        theme: theme,
                        nextMatch: prov.nextMatch,
                        isLoading: prov.isLoading,
                        onTapLiveWatch: () {
                          // todo: go to Youtube channel for live watching
                          navProvider.showBottomSheet(
                            context: context,
                            onTapBtn: () {
                              navProvider.goToUrl(
                                url:
                                    "https://www.youtube.com/@ascelinguere8675/featured",
                              );
                              //
                              Navigator.pop(context);
                            },
                            btnText: 'Continuer vers la chaine Youtube',
                            title: "Live Match  📺  🎥",
                            bodyContent:
                                "Vous allez être redirigé vers notre chaine Youtube pour suivre le match.",
                            widget: Container(
                              height: 60,
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 15,
                              ),
                              decoration: BoxDecoration(
                                color: lightBg,
                                borderRadius: BorderRadius.circular(90),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // logo linguere
                                  Flexible(
                                    child: Image.asset(
                                      'assets/ll_logo_h.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 12),

                                  // arrow
                                  SvgPicture.asset(
                                    'assets/arrow_right_livewatch.svg',
                                  ),
                                  const SizedBox(width: 12),

                                  // logo diotali
                                  SvgPicture.asset('assets/logo_youtube.svg'),
                                ],
                              ),
                            ),
                          );
                        },
                        onTapSeeOtherMatch: () {
                          navProvider.navigateWithFadeTransition(
                            context,
                            const Matches(),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  /// Ranking
                  Text('Classement', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Consumer<RankingProvider>(
                    builder: (_, prov, _) => RankingHomeWidget(
                      theme: theme,
                      rankingModel: prov.ranking,
                    ),
                  ),
                  const SizedBox(height: 24),

                  /// Last news
                  Row(
                    children: [
                      Text(
                        'Dernières actualités',
                        style: theme.textTheme.titleMedium,
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          // todo: go to news page
                          navProvider.navigateWithFadeTransition(
                            context,
                            const Foundation(),
                          );
                        },
                        child: Row(
                          children: [
                            Text(
                              'Voir tous',
                              style: theme.textTheme.labelLarge!.copyWith(
                                color: blueLinguere,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Icon(
                              CupertinoIcons.arrow_right,
                              color: blueLinguere,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Consumer<NewsProvider>(
                    builder: (_, prov, _) {
                      return ListView.separated(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: prov.newsList.length,
                        separatorBuilder: (ctx, index) =>
                            const SizedBox(height: 10),
                        itemBuilder: (ctx, index) {
                          //
                          final news = prov.newsList[index];
                          //
                          return NewsWidget(
                            onTapNews: () {
                              // todo: go to news detail page

                              final newsToDetails = NewsModel(
                                imageActu: news.imageActu,
                                titleActu: news.titleActu,
                                bodyActu: news.bodyActu,
                                dateActu: news.dateActu,
                              );

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      NewsDetails(newsModel: newsToDetails),
                                ),
                              );
                            },
                            theme: theme,
                            id: news.id,
                            imageActu: news.imageActu,
                            titleActu: news.titleActu,
                            dateActu: news.dateActu,
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          /// Floating navigation
          const NavigationWidget(),
        ],
      ),
    );
  }
}
