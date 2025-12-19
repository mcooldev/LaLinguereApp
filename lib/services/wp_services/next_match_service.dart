import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:la_linguere/models/next_match_model.dart';

import 'config.dart';

class NextMatchService {
  NextMatchService._();

  static final NextMatchService instance = NextMatchService._();

  final client = http.Client();

  final authority = Config.instance.baseUrl;
  final unencodedPath = "/wp-json/wp/v2/next-match";
  final Map<String, dynamic> queryParameters = {'_fields': 'acf'};

  /// Fetch media url
  Future<String> fetchMedia(int mediaId) async {
    final defaultMedia = 'assets/placeholder_image.png';
    try {
      final uri = Uri.https(authority, '/wp-json/wp/v2/media/$mediaId');
      final response = await client.get(uri);
      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        return decodedData['source_url'];
      } else {
        log('Error fetching media: ${response.statusCode}');
        return defaultMedia;
      }
    } catch (e) {
      log(e.toString());
      return defaultMedia;
    }
  }

  /// Get next match
  Future<NextMatchModel> getNextMatch() async {
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
    try {
      final uri = Uri.https(authority, unencodedPath, queryParameters);
      final response = await client.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> decodedData = jsonDecode(response.body);
        if (decodedData.isEmpty) {
          log('No data found for the next match.');
          return defaultNextMatch;
        }
        //
        final acfData = decodedData[0]['acf'];
        if (acfData != null) {
          //
          final competitionLogoInt = acfData['logo_competition'];
          final String competitionLogo = await fetchMedia(competitionLogoInt);
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
          //
          final teamLogoHomeInt = acfData['logo_equipe_domicile'];
          final teamLogoAwayInt = acfData['logo_equipe_exterieur'];
          final logos = await Future.wait([
            fetchMedia(teamLogoHomeInt),
            fetchMedia(teamLogoAwayInt),
          ]);
          final String teamLogoHome = logos[0];
          final String teamLogoAway = logos[1];
          //
          final String teamNameHome = acfData['nom_equipe_domicile'];
          //
          final String teamNameAway = acfData['nom_equipe_exterieur'];
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

          return nextMatchToAdd;
        } else {
          log('Error: Un ou des champs ACF sont manquants.');
          return defaultNextMatch;
        }
      } else {
        log('Error fetching next match: ${response.statusCode}');
        return defaultNextMatch;
      }
    } catch (e) {
      log(e.toString());
      return defaultNextMatch;
    }
  }
}
