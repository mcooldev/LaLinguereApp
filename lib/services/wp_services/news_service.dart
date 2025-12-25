import 'dart:developer';

import 'package:dio/dio.dart';

import '../../models/news_model.dart';
import 'config.dart';

class NewsService {
  ///
  late final Dio _dio;

  NewsService._() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://$authority',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        responseType: ResponseType.json,
      ),
    );
    _dio.interceptors.add(
      LogInterceptor(request: true, requestBody: true, responseBody: false),
    );
  }

  static final NewsService instance = NewsService._();

  /// News variables
  final authority = Config.instance.baseUrl;
  final unencodedPath = "/wp-json/wp/v2/actualite";

  final Map<String, dynamic> queryParameters = {'_fields': 'id,acf'};

  /// Fetch media url
  Future<String> fetchMedia(int mediaId) async {
    try {
      final response = await _dio.get('/wp-json/wp/v2/media/$mediaId');
      if (response.statusCode == 200) {
        final decodedData = response.data;
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
      final response = await _dio.get(
        unencodedPath,
        queryParameters: queryParameters,
      );
      //
      if (response.statusCode == 200) {
        final List<dynamic> decodedData = response.data;
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
