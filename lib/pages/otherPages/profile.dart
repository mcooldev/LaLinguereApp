import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:la_linguere/utils/constants/app_colors.dart';
import 'package:la_linguere/widgets/donate_widget.dart';
import 'package:la_linguere/widgets/navigation_widget.dart';

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

    ///
    return Scaffold(
      /// App bar content
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
                Text("Mouhamadou Coulibaly", style: theme.textTheme.titleSmall),
                const SizedBox(height: 4),

                // user email or phone number
                Text(
                  "m.coulibaly@diotali.com",
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 10),

                // user membership badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: lightBlueBg,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    "Samba linguere",
                    style: theme.textTheme.labelMedium!.copyWith(
                      color: blueLinguere,
                      fontWeight: FontWeight.w600,
                    ),
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
                    border: Border.all(width: 1, color: lightStrokeColor),
                  ),
                  child: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    children: [
                      // Support list tile
                      ListTile(
                        onTap: () {
                          // todo: open support page
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
                      Divider(thickness: 1, color: lightStrokeColor),
                      // Forget password list tile
                      ListTile(
                        onTap: () {
                          // todo: open forget password page
                        },
                        //
                        leading: const Icon(CupertinoIcons.lock),
                        //
                        title: Text(
                          "Mot de passe oublié",
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
                        onTap: () {
                          // todo: logout user
                        },
                        //
                        leading: const Icon(
                          CupertinoIcons.square_arrow_left,
                          color: Colors.red,
                        ),
                        //
                        title: Text(
                          "Se déconnecter",
                          style: theme.textTheme.titleSmall!.copyWith(
                            color: Colors.red,
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
                    color: Colors.grey.shade400
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
