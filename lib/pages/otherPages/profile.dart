import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:la_linguere/main.dart';
import 'package:la_linguere/models/user_model.dart';
import 'package:la_linguere/providers/foundation_provider.dart';
import 'package:la_linguere/services/firebase_services/auth_service.dart';
import 'package:la_linguere/utils/constants/app_colors.dart';
import 'package:la_linguere/widgets/donate_widget.dart';
import 'package:la_linguere/widgets/navigation_widget.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_providers/authentication_provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    ///
    final theme = Theme.of(context);
    //
    final loginProv = Provider.of<LoginProvider>(context, listen: false);
    //
    final foundationProv = Provider.of<FoundationProvider>(
      context,
      listen: false,
    );
    final authService = AuthService.instance;
    //
    final user = loginProv.user;
    //
    Color membershipColor() {
      if (user == null || user.hasExpired || user.isMember == false) {
        return bodyText;
      }
      switch (user.membershipType) {
        case MembershipType.notSubscribed:
          return bodyText;
        case MembershipType.member:
          return Colors.black;
        case MembershipType.supporter:
          return yellowLinguere;
        case MembershipType.sambaLinguere:
          return blueLinguere;
        default:
          return bodyText;
      }
    }

    //
    final isActive = user != null && !user.hasExpired;
    final String labelText = isActive
        ? membershipTypeName[user.membershipType?.index ?? 0]
        : membershipTypeName[0];
    //

    ///
    return Scaffold(
      /// App bar content
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Mon compte'),
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

      /// Body
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 50, 16, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// Body content
                // Ling logo
                Container(
                  width: 100,
                  height: 100,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: lightBg,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Image.asset('assets/ll_splash_icon_transparent.png'),
                ),
                const SizedBox(height: 10),

                // User full name
                Text(
                  loginProv.user?.fullName ?? "Invité",
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(height: 4),

                // user email or phone number
                Text(
                  loginProv.userEmailOrPhoneText,
                  softWrap: true,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 10),

                // user membership badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: membershipColor().withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      width: 1,
                      color: membershipColor().withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      if (isActive &&
                          user.membershipType != MembershipType.notSubscribed)
                        Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Icon(
                            Icons.verified,
                            size: 14,
                            color: membershipColor(),
                          ),
                        ),
                      Text(
                        labelText,
                        style: theme.textTheme.labelMedium!.copyWith(
                          color: membershipColor(),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Support and forget password list view
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    children: [
                      // Support list tile
                      ListTile(
                        onTap: () {
                          Navigator.pushNamed(context, '/support');
                        },
                        //
                        leading: const Icon(CupertinoIcons.question),
                        //
                        title: Text(
                          "Besoin d'aide ?",
                          style: theme.textTheme.titleSmall,
                        ),
                        //
                        trailing: Icon(
                          CupertinoIcons.chevron_right,
                          color: strokeColor,
                        ),
                      ),

                      //
                      if (isActive ||
                          loginProv.signedAsGuest)
                        Column(
                          children: [
                            Divider(thickness: 1, color: lightStrokeColor),
                            // subscribe as member list tile
                            ListTile(
                              onTap: () {
                                navKey.currentState?.pushNamedAndRemoveUntil(
                                  "/foundation",
                                  (route) => false,
                                );
                                foundationProv.setTabIndex(1);
                              },
                              //
                              leading: const HugeIcon(
                                icon: HugeIcons.strokeRoundedUserStar02,
                                color: Colors.black,
                              ),
                              //
                              title: Text(
                                "S'abonner maintenant",
                                style: theme.textTheme.titleSmall,
                              ),
                              //
                              trailing: Icon(
                                CupertinoIcons.chevron_right,
                                color: strokeColor,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // donate widget
                DonateWidget(theme: theme),
                const SizedBox(height: 24),

                // logout btn
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(width: 1, color: lightStrokeColor),
                  ),
                  child: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    children: [
                      // sign out list tile
                      ListTile(
                        onTap: () async {
                          if (loginProv.signedAsGuest == true) {
                            navKey.currentState?.pushNamed("/login");
                          } else if (loginProv.user != null) {
                            //
                            await authService.signOut();
                            navKey.currentState?.pushNamedAndRemoveUntil(
                              "/authGate",
                              (route) => false,
                            );
                          }
                        },
                        //
                        leading: Icon(
                          loginProv.signedAsGuest == true
                              ? CupertinoIcons.square_arrow_right
                              : CupertinoIcons.square_arrow_left,
                          color: loginProv.signedAsGuest
                              ? blueLinguere
                              : redLaLinguere,
                        ),
                        //
                        title: Text(
                          loginProv.signedAsGuest == true
                              ? "Se connecter"
                              : "Se déconnecter",
                          style: theme.textTheme.titleSmall!.copyWith(
                            color: loginProv.signedAsGuest
                                ? blueLinguere
                                : redLaLinguere,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // copyright
                Text(
                  "© ASCE La Linguere de Saint-Louis",
                  style: theme.textTheme.labelSmall!.copyWith(
                    color: Colors.grey.shade400,
                  ),
                ),
              ],
            ),
          ),

          /// Navigation widget
          const NavigationWidget(),
        ],
      ),
    );
  }
}
