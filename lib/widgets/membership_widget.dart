import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MembershipWidget extends StatelessWidget {
  const MembershipWidget({
    super.key,
    required this.theme,
    required this.imageMembership,
    required this.titleMembership,
    required this.priceMembership,
    required this.advantagesMembership,
    required this.onTapMembership,
    required this.gradient,
    required this.titleMembershipColor,
    required this.priceMembershipColor,
    required this.advantageColor,
    required this.onTapMembershipBgColor,
    required this.onTapMembershipTextColor,
    required this.advantageIconColor,
  });

  final ThemeData theme;

  final String imageMembership, titleMembership, priceMembership;
  final List<String> advantagesMembership;
  final void Function() onTapMembership;
  final Gradient gradient;

  final Color titleMembershipColor,
      priceMembershipColor,
      advantageColor,
      onTapMembershipBgColor,
      onTapMembershipTextColor,
      advantageIconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
      child: Column(
        children: [
          // image membership
          Container(
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imageMembership),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // other contents
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(gradient: gradient),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // title membership
                Text(
                  'abonnement $titleMembership'.toUpperCase(),
                  style: theme.textTheme.labelLarge!.copyWith(
                    color: titleMembershipColor,
                  ),
                ),
                const SizedBox(height: 2),

                // price
                Text(
                  '$priceMembership fcfa'.toUpperCase(),
                  style: theme.textTheme.headlineLarge!.copyWith(
                    color: priceMembershipColor,
                  ),
                ),
                const SizedBox(height: 20),

                // advantages headline & divider Row
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(90),
                    color: Colors.white10,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'avantages'.toUpperCase(),
                        style: theme.textTheme.labelSmall!.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Divider(thickness: 1, color: Colors.white54),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // list of advantages
                ListView.builder(
                  itemCount: advantagesMembership.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(0),
                  itemBuilder: (ctx, index) {
                    //
                    final advantage = advantagesMembership[index];

                    //
                    return ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      leading: Icon(
                        CupertinoIcons.check_mark_circled_solid,
                        color: advantageIconColor,
                      ),
                      title: Text(
                        advantage,
                        style: theme.textTheme.labelMedium!.copyWith(
                          color: advantageColor,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),

                // subscription button
                MaterialButton(
                  onPressed: onTapMembership,
                  color: onTapMembershipBgColor,
                  height: 48,
                  elevation: 0,
                  minWidth: double.infinity,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(90),
                  ),
                  child: Text(
                    'Souscrire à l’abonnement',
                    style: theme.textTheme.labelLarge!.copyWith(
                      color: onTapMembershipTextColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
