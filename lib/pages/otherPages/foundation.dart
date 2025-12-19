import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:la_linguere/pages/otherPages/foundation_tabview_pages/membership_page.dart';
import 'package:la_linguere/pages/otherPages/foundation_tabview_pages/news_page.dart';
import 'package:la_linguere/pages/otherPages/foundation_tabview_pages/president_page.dart';
import 'package:la_linguere/pages/otherPages/foundation_tabview_pages/team_views/team_page.dart';
import 'package:la_linguere/providers/navigation_provider.dart';
import 'package:provider/provider.dart';

import '../../utils/constants/app_colors.dart';
import '../../widgets/navigation_widget.dart';

class Foundation extends StatefulWidget {
  const Foundation({super.key});

  @override
  State<Foundation> createState() => _FoundationState();
}

class _FoundationState extends State<Foundation> {
  ///
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final navProvider = Provider.of<NavigationProvider>(
        context,
        listen: false,
      );
      navProvider.currentIndex = 3;
    });
  }

  ///
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
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
                    splashBorderRadius: BorderRadius.circular(90),
                    tabs: [
                      const Tab(
                        icon: HugeIcon(icon: HugeIcons.strokeRoundedNews01),
                      ),
                      const Tab(
                        icon: HugeIcon(icon: HugeIcons.strokeRoundedUserStar02),
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
        body: const Stack(
          children: [
            TabBarView(
              children: [
                NewsPage(),
                MembershipPage(),
                TeamPage(),
                PresidentPage()
              ],
            ),

            /// Floating navigation
            NavigationWidget(),
          ],
        ),
      ),
    );
  }
}
