import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../pages/membership_payment_pages/payment_page.dart';
import '../providers/membership_provider.dart';
import '../utils/constants/app_colors.dart';

class DonateWidget extends StatefulWidget {
  const DonateWidget({super.key, required this.theme});

  final ThemeData theme;

  @override
  State<DonateWidget> createState() => _DonateWidgetState();
}

class _DonateWidgetState extends State<DonateWidget> {
  ///
  void showModalPayment(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (context) =>
          const PaymentPage(subsName: "", subsAmount: "", isDonation: true),
    );
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Consumer<MembershipProvider>(
      builder: (_, prov, _) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: yellowGradient,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            children: [
              // Icon & headline
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // icon
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.white,
                    child: SvgPicture.asset('assets/donate_hand_heart.svg'),
                  ),
                  const SizedBox(width: 10),

                  // headline
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Faites un don',
                        style: widget.theme.textTheme.titleSmall,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Soutenez votre club',
                        style: widget.theme.textTheme.labelMedium,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // body text
              Text(
                "Votre soutien nous permet de faire grandir le club et d'améliorer les installations pour le confort de nos joueurs et de nos supporters.",
                style: widget.theme.textTheme.bodyMedium!.copyWith(
                  color: Colors.black,
                ),
                softWrap: true,
              ),
              const SizedBox(height: 16),

              // Btn
              MaterialButton(
                onPressed: () {
                  //
                  showModalPayment(context);
                },
                color: Colors.black,
                height: 48,
                minWidth: double.infinity,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(90),
                  side: const BorderSide(width: 1, color: Colors.white24),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Faire un don maintenant',
                      style: widget.theme.textTheme.labelLarge!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 10),
                    SvgPicture.asset('assets/donate_icon.svg'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
