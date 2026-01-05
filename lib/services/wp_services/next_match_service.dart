import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:la_linguere/models/next_match_model.dart';

import 'config.dart';

class NextMatchService {
  late final Dio _dio;

  NextMatchService._() {
    _dio = Dio(
      BaseOptions(
        baseUrl: "https://$authority",
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        responseType: ResponseType.json,
      ),
    );
    _dio.interceptors.add(
      LogInterceptor(request: true, requestBody: true, responseBody: false),
    );
  }

  static final NextMatchService instance = NextMatchService._();

  final authority = Config.instance.baseUrl;
  final unencodedPath = "/wp-json/wp/v2/next-match";
  final Map<String, dynamic> queryParameters = {'_fields': 'acf'};

  /// Fetch media url
  Future<String> fetchMedia(int mediaId) async {
    try {
      final response = await _dio.get('/wp-json/wp/v2/media/$mediaId');
      if (response.statusCode == 200) {
        final decodedData = response.data;
        return decodedData['source_url'] ?? '';
      }
      return '';
    } catch (e) {
      log("Erreur Media $mediaId: $e");
      return '';
    }
  }

  /// Get next match
  Future<NextMatchModel> getNextMatch() async {
    //
    final defaultNextMatch = NextMatchModel(
      competitionLogo: '',
      competitionName: '',
      day: '',
      matchTime: '',
      teamLogoHome: '',
      teamNameHome: '',
      teamLogoAway: '',
      teamNameAway: '',
    );
    //
    try {
      //
      final response = await _dio.get(
        "/wp-json/wp/v2/next-match",
        queryParameters: queryParameters,
      );
      //
      if (response.statusCode == 200) {
        final List<dynamic> decodedData = response.data;
        //
        final acfData = decodedData[0]['acf'] as Map<String, dynamic>?;
        if (acfData != null) {
          final fetchedMatch = await makeNextMatch(acfData);
          log('Next match fetched successfully.');
          return fetchedMatch;
        } else {
          log('Error: Un ou des champs ACF sont manquants.');
          return defaultNextMatch;
        }
        //
      } else {
        log('Error fetching next match: ${response.statusCode}');
        return defaultNextMatch;
      }
    } catch (e) {
      log(e.toString());
      return defaultNextMatch;
    }
  }

  Future<NextMatchModel> makeNextMatch(Map<String, dynamic> acfData) async {
    //
    final String competitionName = acfData['nom_de_la_competition'];
    final String day = acfData['journee'];
    final String matchTimeString =
        acfData['heure_du_match'] as String? ?? "00:00";
    int hours = 0;
    int minutes = 0;
    if (matchTimeString.contains(":")) {
      final parts = matchTimeString.split(':');
      hours = int.tryParse(parts[0]) ?? 0;
      if (parts.length > 2) {
        minutes = int.tryParse(parts[1]) ?? 0;
      }
    }
    final String matchTime =
        '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
    final String teamNameHome = acfData['nom_equipe_domicile'];
    //
    final String teamNameAway = acfData['nom_equipe_exterieur'];
    //
    final rawCompetitionLogo = acfData['logo_competition'] as int;
    final rawTeamLogoHome = acfData['logo_equipe_domicile'] as int;
    final rawTeamLogoAway = acfData['logo_equipe_exterieur'] as int;
    final futures = await Future.wait([
      fetchMedia(rawCompetitionLogo),
      fetchMedia(rawTeamLogoHome),
      fetchMedia(rawTeamLogoAway),
    ]);
    final String competitionLogo = futures[0];
    final String teamLogoHome = futures[1];
    final String teamLogoAway = futures[2];
    //
    final nextMatchToAdd = NextMatchModel(
      competitionLogo: competitionLogo,
      competitionName: competitionName,
      day: day,
      matchTime: matchTime,
      teamLogoHome: teamLogoHome,
      teamNameHome: teamNameHome,
      teamLogoAway: teamLogoAway,
      teamNameAway: teamNameAway,
    );
    //
    log('Next match made successfully.');
    //
    return nextMatchToAdd;
  }
}
