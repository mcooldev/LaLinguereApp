import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:la_linguere/models/all_rank_model.dart';

class AllRankService {
  late final Dio _dio;
  static final AllRankService instance = AllRankService._();

  AllRankService._() {
    _dio = Dio(
      BaseOptions(
        baseUrl: "https://v3.football.api-sports.io",
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        responseType: ResponseType.json,
      ),
    );
    _dio.interceptors.add(
      LogInterceptor(request: true, requestBody: true, responseBody: false),
    );
  }

  final unencodedPath = "/standings";

  final headerContent = {
    "x-rapidapi-host": "v3.football.api-sports.io",
    "x-rapidapi-key": "cf2e0c9ee2782ec982c111ade340ebe2",
  };

  final queryParameters = {"league": "403", "season": "2025"};

  Future<List<AllRankModel>> fetchAllRank() async {
    try {
      //
      final response = await _dio.get(
        unencodedPath,
        options: Options(headers: headerContent),
        queryParameters: queryParameters,
      );
      //
      if (response.statusCode == 200) {
        final data = response.data;
        //
        final league = data["response"][0]["league"];
        final List<dynamic> standing = league["standings"][0];
        //
        final fetchedStanding = standing.map((s) => makeStanding(s)).toList();
        log("Fetched Standing: ${fetchedStanding.length}");
        return fetchedStanding;
      }
      return [];
    } catch (e) {
      log("Error while fetching all rank: ${e.toString()}");
      return [];
    }
  }

  AllRankModel makeStanding(Map<String, dynamic> standing) {
    final rank = standing["rank"];
    final teamName = standing["team"]["name"];
    final logo = standing["team"]["logo"];
    final points = standing["points"];
    final goalsDiff = standing["goalsDiff"];
    final all = standing["all"];
    final played = all["played"];
    //
    return AllRankModel(
      rank: rank,
      teamName: teamName,
      teamLogo: logo,
      points: points,
      goalsDiff: goalsDiff,
      playedMatch: played,
    );
  }
}
