import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:la_linguere/models/calendar_model.dart';

import 'config.dart';

class CalendarService {
  late final Dio _dio;

  CalendarService._() {
    _dio = Dio(
      BaseOptions(
        baseUrl: "https://$authority",
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        responseType: ResponseType.json,
      ),
    );
    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: false),
    );
  }

  static final CalendarService _instance = CalendarService._();

  static CalendarService get instance => _instance;

  ///
  final String authority = Config.instance.baseUrl;

  final unencodedPath = "/wp-json/wp/v2/calendrier";

  final Map<String, dynamic> query = {'_fields': 'acf', 'per_page': 13};

  Future<String> fetchMedia(int mediaId) async {
    final response = await _dio.get("/wp-json/wp/v2/media/$mediaId");
    if (response.statusCode == 200) {
      final decodeData = response.data;
      return decodeData["source_url"];
    } else {
      log(" Status error while fetching media: ${response.statusCode}");
      return 'assets/placeholder_image.png';
    }
  }

  Future<List<CalendarModel>> fetchCalendar() async {
    try {
      final response = await _dio.get(unencodedPath, queryParameters: query);
      if (response.statusCode == 200) {
        final List<dynamic> decodeData = response.data;
        //
        List<CalendarModel> allCalendar = <CalendarModel>[];
        final List<Future<CalendarModel>> futures = [];
        //
        for (final data in decodeData) {
          futures.add(makeCalendar(data));
        }
        //
        log("Calendar: Successfully fetched ${allCalendar.length} matches");
        return allCalendar = await Future.wait(futures);
      } else {
        log(" Status error while fetching calendar: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      log("Error while fetching calendar: $e");
      return [];
    }
  }

  Future<CalendarModel> makeCalendar(Map<String, dynamic> data) async {
    final acf = data["acf"] as Map<String, dynamic>;
    int mediaId = 0;
    final rawMediaId = acf["logo_de_lequipe_adverse"] as int?;
    String mediaUrl = 'assets/placeholder_image.png';
    if (rawMediaId != null && rawMediaId > 0) {
      mediaId = rawMediaId;
      mediaUrl = await fetchMedia(mediaId);
    }
    final opposingTeamName = acf["nom_de_lequipe_adverse"]?.toString() ?? '';
    final day = acf["journee"]?.toString() ?? '';
    final rawDate = acf["date_et_heure_du_match"]?.toString() ?? "";
    String formattedDate = rawDate.replaceAll(" ", "T");
    final dateMatch = DateTime.tryParse(formattedDate) ?? DateTime.now();

    final isHome = acf["est_receveur"] as bool;
    //
    final calendarToAdd = CalendarModel(
      opposingTeamLogo: mediaUrl,
      opposingTeamName: opposingTeamName,
      day: day,
      dateMatch: dateMatch,
      isHome: isHome,
    );
    return calendarToAdd;
  }
}
