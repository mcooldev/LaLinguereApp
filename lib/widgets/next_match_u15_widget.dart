import 'package:flutter/material.dart';
import 'package:la_linguere/models/next_match_model.dart';
import 'package:la_linguere/widgets/team_next_match_widget.dart';

import '../utils/constants/app_colors.dart';

class NextMatchU15Widget extends StatefulWidget {
  const NextMatchU15Widget({
    super.key,
    required this.theme,
    required this.isLoading,
    required this.nextMatchU15,
  });

  final ThemeData theme;
  final NextMatchU15Model? nextMatchU15;

  final bool isLoading;

  @override
  State<NextMatchU15Widget> createState() => _NextMatchU15WidgetState();
}

class _NextMatchU15WidgetState extends State<NextMatchU15Widget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/next_match_bg.png'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: widget.isLoading
          ? const Center(
        child: CircularProgressIndicator.adaptive(
          backgroundColor: Colors.white,
        ),
      )
          : Column(
        children: [
          /// competition name and day
          Row(
            children: [
              /// competition logo
              CircleAvatar(
                radius: 24,
                backgroundImage:
                (widget.nextMatchU15?.competitionLogo != null &&
                    widget.nextMatchU15!.competitionLogo.startsWith('http'))
                    ? NetworkImage(widget.nextMatchU15!.competitionLogo)
                    : const AssetImage('assets/placeholder_image.png')
                as ImageProvider,
                backgroundColor: Colors.white,
              ),
              const SizedBox(width: 8),

              /// competition name
              Text(
                widget.nextMatchU15?.competitionName ??
                    'Aucune Compet.',
                style: widget.theme.textTheme.titleSmall!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),

              /// day
              Text(
                '${widget.nextMatchU15?.day ?? '0'}e Journée',
                style: widget.theme.textTheme.labelLarge!.copyWith(
                  color: yellowLinguere,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          /// teams
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // team 1
              Flexible(
                flex: 2,
                child: TeamNextMatchWidget(
                  theme: widget.theme,
                  teamLogo: widget.nextMatchU15?.teamLogoHome,
                  teamName:
                  widget.nextMatchU15?.teamNameHome ??
                      'Equipe dom.',
                  isHome: true,
                ),
              ),
              // VS and time
              Flexible(
                flex: 1,
                child: Column(
                  children: [
                    // VS
                    Text(
                      'VS',
                      style: widget.theme.textTheme.bodyLarge!.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Time
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(90),
                      ),
                      child: Text(
                        widget.nextMatchU15?.matchTime ?? '-N/C-',
                        style: widget.theme.textTheme.labelSmall!
                            .copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // team 2
              Flexible(
                flex: 2,
                child: TeamNextMatchWidget(
                  theme: widget.theme,
                  teamLogo: widget.nextMatchU15?.teamLogoAway,
                  teamName:
                  widget.nextMatchU15?.teamNameAway ??
                      'Equipe ext.',
                  isHome: false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
