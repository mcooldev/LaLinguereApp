import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../models/news_model.dart';
import 'config.dart';

class NewsService {
  ///
  NewsService._();

  static final NewsService instance = NewsService._();

  /// News variables
  final authority = Config.instance.baseUrl;
  final unencodedPath = "/wp-json/wp/v2/actualite";

  final Map<String, dynamic> queryParameters = {'_fields': 'id,acf'};

  /// Fetch media url
  Future<String> fetchMedia(int mediaId) async {
    try {
      final uri = Uri.https(authority, '/wp-json/wp/v2/media/$mediaId');
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        return decodedData['source_url'];
      }
      return '';
    } catch (e) {
      log(e.toString());
      return '';
    }
  }

  /// Get all news
  Future<List<NewsModel>> getNews() async {
    try {
      //
      final uri = Uri.https(authority, unencodedPath, queryParameters);
      final response = await http.get(uri);
      //
      if (response.statusCode == 200) {
        final List<dynamic> decodedData = jsonDecode(response.body);
        log(decodedData.toString());
        //
        final allNews = <Future<NewsModel>>[];
        //
        for (var data in decodedData) {
          allNews.add(makeNewsItem(data));
        }
        //
        final news = await Future.wait(allNews);
        return news;
      }
      return [];
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  /// Make news item
  Future<NewsModel> makeNewsItem(Map<String, dynamic> data) async {
    final id = data['id'];
    final title = data['acf']['titre'];
    final description = data['acf']['contenu_actu'];
    final dateString = data['acf']['date_actu'];
    final date = DateTime.parse(dateString);
    final imageId = data['acf']['image'] as int;
    final imageUrl = await fetchMedia(imageId);

    final newsToAdd = NewsModel(
      id: id.toString(),
      imageActu: imageUrl,
      titleActu: title,
      bodyActu: description,
      dateActu: date,
    );
    return newsToAdd;
  }
}
