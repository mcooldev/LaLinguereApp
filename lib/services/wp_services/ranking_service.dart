import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../models/ranking_model.dart';
import 'config.dart';

class RankingService {
  RankingService._();

  static final RankingService instance = RankingService._();

  final client = http.Client();


  /// Ranking variables
  final authority = Config.instance.baseUrl;
  final unencodedPath = "/wp-json/wp/v2/classement";

  final Map<String, dynamic> queryParameters = {
    '_fields': 'id,acf',
    'include': '39',
  };

  Future<RankingModel> getRanking() async {
    //
    final defaultRanking = RankingModel(place: 0, points: 0, playedMatch: 0);
    //
    try {
      final uri = Uri.https(authority, unencodedPath, queryParameters);
      final response = await client.get(uri);
      //
      if (response.statusCode == 200) {
        final List<dynamic> decodedData = jsonDecode(response.body);
        log(decodedData.toString());
        //
        final acfData = decodedData[0]['acf'];
        final id = decodedData[0]['id'];
        //
        if (acfData != null) {
          final int place =
              int.tryParse(acfData['rang_de_lequipe']?.toString() ?? '00') ??
              00;
          final int points =
              int.tryParse(acfData['nombre_de_point']?.toString() ?? '00') ??
              00;
          final int playedMatch =
              int.tryParse(
                acfData['nombre_de_matchs_joues']?.toString() ?? '00',
              ) ??
              00;
          //
          final ranking = RankingModel(
            id: id.toString(),
            place: place,
            points: points,
            playedMatch: playedMatch,
          );
          //
          log('Classement récupéré avec succès. $ranking');
          return ranking;
        } else {
          //
          log('Erreur: Un ou des champs ACF sont manquants.');
          return defaultRanking;
        }
      }
      //
      log('Erreur de requête: Statut ${response.statusCode}');
      return defaultRanking;
    } catch (e) {
      //
      log(e.toString());
      return defaultRanking;
    }
  }
}
