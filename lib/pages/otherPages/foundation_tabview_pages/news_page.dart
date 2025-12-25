import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:la_linguere/models/news_model.dart';
import 'package:la_linguere/pages/otherPages/news_details.dart';
import 'package:la_linguere/providers/news_provider.dart';
import 'package:la_linguere/utils/constants/app_colors.dart';
import 'package:provider/provider.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  @override
  Widget build(BuildContext context) {
    ///
    final theme = Theme.of(context);

    ///
    return Consumer<NewsProvider>(
      builder: (_, prov, _) => Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 90),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // headline
              Text('Nos actualités', style: theme.textTheme.titleLarge),
              const SizedBox(height: 24),

              // news list
              ListView.separated(
                itemCount: prov.newsList.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (ctx, index) =>
                    Divider(thickness: 1, color: strokeColor, height: 50),
                itemBuilder: (ctx, index) {
                  //
                  final news = prov.newsList[index];

                  //
                  return GestureDetector(
                    onTap: () {
                      // todo: go to news detail page
                      final newsToDetails = NewsModel(
                        imageActu: news.imageActu,
                        titleActu: news.titleActu,
                        bodyActu: news.bodyActu,
                        dateActu: news.dateActu,
                      );
                      //
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) =>
                              NewsDetails(newsModel: newsToDetails),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // news image
                        Container(
                          width: double.infinity,
                          height: 250,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: lightBg,
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: CachedNetworkImage(
                            imageUrl: news.imageActu,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Image.asset(
                              'assets/placeholder_image.png',
                              fit: BoxFit.cover,
                            ),
                            errorWidget: (context, child, url) => Icon(
                              CupertinoIcons.photo,
                              color: strokeColor,
                              size: 70,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // date
                        Text(
                          prov.dateFormat(news.dateActu),
                          style: theme.textTheme.labelMedium!.copyWith(
                            color: bodyText,
                          ),
                        ),
                        const SizedBox(height: 10),
                        // title actu
                        Text(
                          news.titleActu,
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 10),
                        // body content actu
                        Text(
                          news.bodyActu,
                          style: theme.textTheme.bodyMedium!.copyWith(
                            color: bodyText,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
