import 'package:flutter/material.dart';
import 'package:la_linguere/models/news_model.dart';
import 'package:la_linguere/providers/news_provider.dart';
import 'package:provider/provider.dart';

import '../../utils/constants/app_colors.dart';

class NewsDetails extends StatefulWidget {
  const NewsDetails({super.key, required this.newsModel});

  final NewsModel newsModel;

  @override
  State<NewsDetails> createState() => _NewsDetailsState();
}

class _NewsDetailsState extends State<NewsDetails> {
  @override
  Widget build(BuildContext context) {
    ///
    final theme = Theme.of(context);

    ///
    return Consumer<NewsProvider>(
      builder: (_, prov, _) {
        return Scaffold(
          /// App bar
          appBar: AppBar(
            title: const Text('Actualité'),
            centerTitle: false,
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
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // news image
                Container(
                  width: double.infinity,
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    image: DecorationImage(
                      image: NetworkImage(widget.newsModel.imageActu),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // category and date
                Text(
                  prov.dateFormat(widget.newsModel.dateActu),
                  style: theme.textTheme.labelMedium!.copyWith(
                    color: bodyText,
                  ),
                ),
                const SizedBox(height: 12),
                // title actu
                Text(
                  widget.newsModel.titleActu,
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                // body content actu
                Text(
                  widget.newsModel.bodyActu,
                  style: theme.textTheme.bodyMedium!.copyWith(color: bodyText),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
