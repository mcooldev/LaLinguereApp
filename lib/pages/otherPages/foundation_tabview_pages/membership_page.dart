import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:la_linguere/models/user_model.dart';
import 'package:la_linguere/pages/membership_payment_pages/payment_page.dart';
import 'package:la_linguere/providers/auth_providers/authentication_provider.dart';
import 'package:la_linguere/utils/constants/app_colors.dart';
import 'package:provider/provider.dart';

import '../../../widgets/membership_widget.dart';

class MembershipPage extends StatefulWidget {
  const MembershipPage({super.key});

  @override
  State<MembershipPage> createState() => _MembershipPageState();
}

class _MembershipPageState extends State<MembershipPage> {
  ///
  void showModalPayment(
    BuildContext context, {
    required String subsName,
    required String subsAmount,
  }) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (context) => PaymentPage(
        subsName: subsName,
        subsAmount: subsAmount,
        isDonation: false,
      ),
    );
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(
      builder: (_, prov, _) {
        ///
        final theme = Theme.of(context);
        final isActive = prov.user != null && prov.user!.isMember && !prov.user!.hasExpired;

        ///
        return Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 120),
            child: Column(
              children: [
                // headline
                Row(
                  children: [
                    Text('Nos abonnements', style: theme.textTheme.titleLarge),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 8,
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
                  titleMembership:
                      membershipTypeName[MembershipType.member.index],
                  priceMembership: '24000',
                  advantagesMembership: [
                    'Lorem ipsum dolor sit amet consectetur. Quam.',
                    'Lorem ipsum dolor sit amet consectetur. Quam.',
                  ],
                  isActive: isActive,
                  onTapMembership: isActive
                      ? null
                      : () => showModalPayment(
                          context,
                          subsName:
                              membershipTypeName[MembershipType.member.index],
                          subsAmount: '24000',
                        ),
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
                  titleMembership:
                      membershipTypeName[MembershipType.supporter.index],
                  priceMembership: '19000',
                  advantagesMembership: [
                    'Lorem ipsum dolor sit amet consectetur. Quam.',
                    'Lorem ipsum dolor sit amet consectetur. Quam.',
                  ],
                  isActive: isActive,
                  onTapMembership: isActive
                      ? null
                      : () => showModalPayment(
                          context,
                          subsName:
                              membershipTypeName[MembershipType
                                  .supporter
                                  .index],
                          subsAmount: '19000',
                        ),
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
                  titleMembership:
                      membershipTypeName[MembershipType.sambaLinguere.index],
                  priceMembership: '12000',
                  advantagesMembership: [
                    'Lorem ipsum dolor sit amet consectetur. Quam.',
                    'Lorem ipsum dolor sit amet consectetur. Quam.',
                  ],
                  isActive: isActive,
                  onTapMembership: isActive
                      ? null
                      : () => showModalPayment(
                          context,
                          subsName:
                              membershipTypeName[MembershipType
                                  .sambaLinguere
                                  .index],
                          subsAmount: '12000',
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
