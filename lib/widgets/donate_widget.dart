import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/constants/app_colors.dart';

class DonateWidget extends StatelessWidget {
  const DonateWidget({
    super.key,
    required this.theme,
  });

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
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
                    style: theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Soutenez votre club',
                    style: theme.textTheme.labelMedium,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // body text
          Text(
            "Votre soutien nous permet de faire grandir le club et d'améliorer les installations pour le confort de nos joueurs et de nos supporters.",
            style: theme.textTheme.bodyMedium!.copyWith(
              color: Colors.black,
            ),
            softWrap: true,
          ),
          const SizedBox(height: 16),

          // Btn
          MaterialButton(
            onPressed: (){
              // todo: make a donation
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
                  style: theme.textTheme.labelLarge!.copyWith(
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
  }
}