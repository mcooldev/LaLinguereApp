import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:la_linguere/utils/constants/app_colors.dart';
import 'package:provider/provider.dart';

import '../../../widgets/membership_widget.dart';

class MembershipPage extends StatefulWidget {
  const MembershipPage({super.key});

  @override
  State<MembershipPage> createState() => _MembershipPageState();
}

class _MembershipPageState extends State<MembershipPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, prov, _) {
        ///
        final theme = Theme.of(context);

        ///
        return Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 90),
            child: Column(
              children: [
                // headline
                Row(
                  children: [
                    Text('Nos abonnements', style: theme.textTheme.titleMedium),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        color: lightStrokeColor,
                        borderRadius: BorderRadius.circular(90),
                      ),
                      child: Row(
                        children: [
                          HugeIcon(
                            icon: HugeIcons.strokeRoundedInformationCircle,
                            color: bodyText,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'tarif annuel'.toUpperCase(),
                            style: theme.textTheme.labelSmall!.copyWith(
                              color: bodyText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                /// membership list
                // member
                MembershipWidget(
                  theme: theme,
                  titleMembershipColor: yellowLinguere,
                  priceMembershipColor: Colors.white,
                  advantageColor: Colors.white,
                  onTapMembershipBgColor: blueLinguere,
                  onTapMembershipTextColor: Colors.white,
                  advantageIconColor: yellowLinguere,
                  gradient: blackGradient,
                  imageMembership: 'assets/member_image.png',
                  titleMembership: 'member',
                  priceMembership: '24000',
                  advantagesMembership: [
                    'Lorem ipsum dolor sit amet consectetur. Quam.',
                    'Lorem ipsum dolor sit amet consectetur. Quam.',
                  ],
                  onTapMembership: () {
                    // todo: subscribe to membership
                  },
                ),
                const SizedBox(height: 16),
                // supporter
                MembershipWidget(
                  theme: theme,
                  titleMembershipColor: Colors.white,
                  priceMembershipColor: Colors.black,
                  advantageColor: Colors.black,
                  onTapMembershipBgColor: Colors.black,
                  onTapMembershipTextColor: Colors.white,
                  advantageIconColor: Colors.white,
                  gradient: yellowGradient,
                  imageMembership: 'assets/member_supporter.png',
                  titleMembership: 'supporter',
                  priceMembership: '19000',
                  advantagesMembership: [
                    'Lorem ipsum dolor sit amet consectetur. Quam.',
                    'Lorem ipsum dolor sit amet consectetur. Quam.',
                  ],
                  onTapMembership: () {
                    // todo: subscribe to membership
                  },
                ),
                const SizedBox(height: 16),
                // samba linguere
                MembershipWidget(
                  theme: theme,
                  titleMembershipColor: yellowLinguere,
                  priceMembershipColor: Colors.white,
                  advantageColor: Colors.white,
                  onTapMembershipBgColor: Colors.white,
                  onTapMembershipTextColor: darkBlue,
                  advantageIconColor: yellowLinguere,
                  gradient: blueGradient,
                  imageMembership: 'assets/member_sambalinguere.png',
                  titleMembership: 'member',
                  priceMembership: '12000',
                  advantagesMembership: [
                    'Lorem ipsum dolor sit amet consectetur. Quam.',
                    'Lorem ipsum dolor sit amet consectetur. Quam.',
                  ],
                  onTapMembership: () {
                    // todo: subscribe to membership
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
