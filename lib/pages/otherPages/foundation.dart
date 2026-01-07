import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:la_linguere/pages/otherPages/foundation_tabview_pages/membership_page.dart';
import 'package:la_linguere/pages/otherPages/foundation_tabview_pages/news_page.dart';
import 'package:la_linguere/pages/otherPages/foundation_tabview_pages/president_page.dart';
import 'package:la_linguere/pages/otherPages/foundation_tabview_pages/team_views/team_page.dart';
import 'package:la_linguere/providers/foundation_provider.dart';
import 'package:la_linguere/providers/navigation_provider.dart';
import 'package:provider/provider.dart';

import '../../utils/constants/app_colors.dart';
import '../../widgets/navigation_widget.dart';

class Foundation extends StatefulWidget {
  const Foundation({super.key});

  @override
  State<Foundation> createState() => _FoundationState();
}

class _FoundationState extends State<Foundation>
    with SingleTickerProviderStateMixin {
  ///
  late FoundationProvider foundation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FoundationProvider>().initTab(this);
      //
      if (!mounted) return;
      context.read<NavigationProvider>().currentIndex = 3;
      //
      foundation = context.read<FoundationProvider>();
    });
  }

  @override
  void dispose() {
    foundation.resetTabIndex();
    super.dispose();
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Consumer<FoundationProvider>(
      builder: (_, prov, _) {
        if (prov.tabController == null) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        return Scaffold(
          /// App bar content
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: const Text('La fondation'),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(40),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1, color: lightStrokeColor),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    TabBar(
                      controller: prov.tabController,
                      splashBorderRadius: BorderRadius.circular(90),
                      tabs: [
                        const Tab(
                          icon: HugeIcon(icon: HugeIcons.strokeRoundedNews01),
                        ),
                        const Tab(
                          icon: HugeIcon(
                            icon: HugeIcons.strokeRoundedUserStar02,
                          ),
                        ),
                        const Tab(
                          icon: HugeIcon(icon: HugeIcons.strokeRoundedTShirt),
                        ),
                        const Tab(
                          icon: HugeIcon(
                            icon: HugeIcons.strokeRoundedUserFullView,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// Body content
          body: Stack(
            children: [
              TabBarView(
                controller: prov.tabController,
                children: [
                  const NewsPage(),
                  const MembershipPage(),
                  const TeamPage(),
                  const PresidentPage(),
                ],
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
