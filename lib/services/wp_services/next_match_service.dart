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

  /// U15
  Future<NextMatchU15Model> getNextMatchU15() async {
    //
    final defaultNextMatchU15 = NextMatchU15Model(
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
        "/wp-json/wp/v2/u15",
        queryParameters: queryParameters,
      );
      //
      if (response.statusCode == 200) {
        final List<dynamic> decodedData = response.data;
        //
        final acfData = decodedData[0]['acf'] as Map<String, dynamic>?;
        if (acfData != null) {
          final fetchedMatch = await makeNextMatchU15(acfData);
          log('Next match U15 fetched successfully.');
          return fetchedMatch;
        } else {
          log('Error: Un ou des champs ACF U15 sont manquants.');
          return defaultNextMatchU15;
        }
        //
      } else {
        log('Error fetching next match U15: ${response.statusCode}');
        return defaultNextMatchU15;
      }
    } catch (e) {
      log(e.toString());
      return defaultNextMatchU15;
    }
  }

  Future<NextMatchU15Model> makeNextMatchU15(Map<String, dynamic> acfData) async {
    //
    final String competitionName = acfData['nom_de_la_competition_u15'];
    final String day = acfData['journee_u15'];
    final String matchTimeString =
        acfData['heure_du_match_u15'] as String? ?? "00:00";
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
    final String teamNameHome = acfData['nom_equipe_domicile_u15'];
    //
    final String teamNameAway = acfData['nom_equipe_exterieur_u15'];
    //
    final rawCompetitionLogo = acfData['logo_competition_u15'] as int;
    final rawTeamLogoHome = acfData['logo_equipe_domicile_u15'] as int;
    final rawTeamLogoAway = acfData['logo_equipe_exterieur_u15'] as int;
    final futures = await Future.wait([
      fetchMedia(rawCompetitionLogo),
      fetchMedia(rawTeamLogoHome),
      fetchMedia(rawTeamLogoAway),
    ]);
    final String competitionLogo = futures[0];
    final String teamLogoHome = futures[1];
    final String teamLogoAway = futures[2];
    //
    final nextMatchU15ToAdd = NextMatchU15Model(
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
    log('Next match U15 made successfully.');
    //
    return nextMatchU15ToAdd;
  }


  /// Woman team

  Future<NextMatchWomanModel> getNextMatchWoman() async {
    //
    final defaultNextMatchWoman = NextMatchWomanModel(
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
        "/wp-json/wp/v2/feminine",
        queryParameters: queryParameters,
      );
      //
      if (response.statusCode == 200) {
        final List<dynamic> decodedData = response.data;
        //
        final acfData = decodedData[0]['acf'] as Map<String, dynamic>?;
        if (acfData != null) {
          final fetchedMatch = await makeNextMatchWoman(acfData);
          log('Next match Woman fetched successfully.');
          return fetchedMatch;
        } else {
          log('Error: Un ou des champs ACF Woman sont manquants.');
          return defaultNextMatchWoman;
        }
        //
      } else {
        log('Error fetching next match Woman: ${response.statusCode}');
        return defaultNextMatchWoman;
      }
    } catch (e) {
      log(e.toString());
      return defaultNextMatchWoman;
    }
  }

  Future<NextMatchWomanModel> makeNextMatchWoman(Map<String, dynamic> acfData) async {
    //
    final String competitionName = acfData['nom_de_la_competition_woman'];
    final String day = acfData['journee_woman'];
    final String matchTimeString =
        acfData['heure_du_match_woman'] as String? ?? "00:00";
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
    final String teamNameHome = acfData['nom_equipe_domicile_woman'];
    //
    final String teamNameAway = acfData['nom_equipe_exterieur_woman'];
    //
    final rawCompetitionLogo = acfData['logo_competition_woman'] as int;
    final rawTeamLogoHome = acfData['logo_equipe_domicile_woman'] as int;
    final rawTeamLogoAway = acfData['logo_equipe_exterieur_woman'] as int;
    final futures = await Future.wait([
      fetchMedia(rawCompetitionLogo),
      fetchMedia(rawTeamLogoHome),
      fetchMedia(rawTeamLogoAway),
    ]);
    final String competitionLogo = futures[0];
    final String teamLogoHome = futures[1];
    final String teamLogoAway = futures[2];
    //
    final nextMatchWomanToAdd = NextMatchWomanModel(
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
    log('Next match Woman made successfully.');
    //
    return nextMatchWomanToAdd;
  }


}
