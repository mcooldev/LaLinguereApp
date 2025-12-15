import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../pages/otherPages/foundation.dart';
import '../pages/otherPages/home.dart';
import '../pages/otherPages/matches.dart';
import '../pages/otherPages/profile.dart';
import '../providers/navigation_provider.dart';
import '../utils/constants/app_colors.dart';

class NavigationWidget extends StatelessWidget {
  const NavigationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (_, prov, _) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 32),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: darkBlue,
              borderRadius: BorderRadius.circular(90),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(prov.navItems.length, (index) {
                //
                final item = prov.navItems[index];
                bool isIndexed = prov.currentIndex == index;
                //
                return GestureDetector(
                  onTap: () {
                    prov.currentIndex = index;
                    //
                    switch (index) {
                      case 0:
                        prov.navigateWithFadeTransition(context, const Home());
                        break;
                      case 1:
                        prov.navigateWithFadeTransition(
                          context,
                          const Matches(),
                        );
                        break;
                      case 2:
                        prov.showBottomSheet(
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                Flexible(
                                  child: SvgPicture.asset(
                                    'assets/arrow_right_ticket.svg',
                                  ),
                                ),
                                const SizedBox(width: 12),

                                // logo diotali
                                Flexible(
                                  child: Image.asset(
                                    'assets/logo_diotali_event.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          context: context,
                          onTapBtn: () {
                            prov.goToUrl(url: "https://event.diotali.com");
                            //
                            Navigator.pop(context);
                          },
                          btnText: 'Continuer vers diotaliEvent',
                          title: "Billetterie 🎫",
                          bodyContent:
                              "Vous allez être redirigé vers le site officiel de diotaliEvent pour effectuer votre achat.",
                        );
                        break;
                      case 3:
                        prov.navigateWithFadeTransition(
                          context,
                          const Foundation(),
                        );
                        break;
                      case 4:
                        prov.navigateWithFadeTransition(
                          context,
                          const Profile(),
                        );
                        break;
                    }
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: isIndexed ? Colors.white : darkBlue,
                      borderRadius: BorderRadius.circular(90),
                    ),
                    child: Icon(
                      item,
                      color: isIndexed ? darkBlue : Colors.white,
                    ),
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }
}
