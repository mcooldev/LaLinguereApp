import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:la_linguere/models/next_match_model.dart';
import 'package:la_linguere/widgets/team_next_match_widget.dart';

import '../utils/constants/app_colors.dart';

class NextMatchWidget extends StatefulWidget {
  const NextMatchWidget({
    super.key,
    required this.theme,
    required this.isLoading,
    required this.nextMatch,
    this.onTapLiveWatch,
    this.onTapSeeOtherMatch,
  });

  final ThemeData theme;
  final NextMatchModel? nextMatch;

  final bool isLoading;

  final void Function()? onTapLiveWatch;
  final void Function()? onTapSeeOtherMatch;

  @override
  State<NextMatchWidget> createState() => _NextMatchWidgetState();
}

class _NextMatchWidgetState extends State<NextMatchWidget> {
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
                          widget.nextMatch?.competitionLogo != null &&
                              widget.nextMatch!.competitionLogo.isNotEmpty
                          ? NetworkImage(widget.nextMatch!.competitionLogo)
                          : const AssetImage('assets/placeholder_image.png')
                                as ImageProvider,
                      backgroundColor: Colors.white,
                    ),
                    const SizedBox(width: 8),

                    /// competition name
                    Text(
                      widget.nextMatch?.competitionName ?? 'Aucune Compet.',
                      style: widget.theme.textTheme.titleSmall!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),

                    /// day
                    Text(
                      '${widget.nextMatch?.day ?? '0'}e Journée',
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
                        teamLogo: widget.nextMatch?.teamLogoHome ?? '',
                        teamName:
                            widget.nextMatch?.teamNameHome ?? 'Equipe dom.',
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
                              widget.nextMatch?.matchTime ?? '-N/C-',
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
                        teamLogo: widget.nextMatch?.teamLogoAway ?? '',
                        teamName:
                            widget.nextMatch?.teamNameAway ?? 'Equipe ext.',
                        isHome: false,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                /// live watch btn & see other match btn
                MaterialButton(
                  onPressed: widget.onTapLiveWatch,
                  color: redLaLinguere,
                  height: 48,
                  minWidth: double.infinity,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(90),
                    side: const BorderSide(
                      width: 1,
                      color: Colors.white24,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Suivre le match',
                        style: widget.theme.textTheme.labelLarge!
                            .copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 10),
                      SvgPicture.asset('assets/live_video_icon.svg'),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // See other match btn
                MaterialButton(
                  onPressed: widget.onTapSeeOtherMatch,
                  color: Colors.transparent,
                  height: 48,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(90),
                    side: const BorderSide(
                      width: 1,
                      color: Colors.white24,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Voir les autres matchs',
                        style: widget.theme.textTheme.labelLarge!
                            .copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(
                        CupertinoIcons.arrow_right,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
