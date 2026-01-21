import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:la_linguere/providers/news_provider.dart';
import 'package:provider/provider.dart';

import '../utils/constants/app_colors.dart';

class NewsWidget extends StatelessWidget {
  const NewsWidget({
    super.key,
    this.id,
    required this.theme,
    required this.imageActu,
    required this.titleActu,
    required this.dateActu,
    required this.onTapNews,
  });

  final ThemeData theme;

  final String? id;
  final String? imageActu;
  final String titleActu;
  final DateTime dateActu;

  final void Function() onTapNews;

  @override
  Widget build(BuildContext context) {
    ///

    ///
    return Consumer<NewsProvider>(
      builder: (_, prov, _) {
        return GestureDetector(
          onTap: onTapNews,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: lightBg,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                // News image
                Container(
                  width: 112,
                  height: 112,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.white,
                  ),
                  child: (imageActu == null || prov.isLoading)
                      ? Image.asset(
                          'assets/placeholder_image.png',
                          fit: BoxFit.cover,
                        )
                      : CachedNetworkImage(
                          imageUrl: imageActu!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Image.asset(
                            'assets/placeholder_image.png',
                            fit: BoxFit.cover,
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(CupertinoIcons.photo, color: strokeColor),
                        ),
                ),
                const SizedBox(width: 10),

                // News content
                Flexible(
                  child: SizedBox(
                    height: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        // news date
                        Text(
                          prov.isLoading ? "00/00/0000" : prov.dateFormat(dateActu),
                          style: theme.textTheme.labelMedium!.copyWith(
                            color: bodyText,
                          ),
                        ),

                        // news title
                        Text(
                          prov.isLoading ? "Titre..." : titleActu,
                          style: theme.textTheme.bodyLarge!.copyWith(
                            height: 1.3,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
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
