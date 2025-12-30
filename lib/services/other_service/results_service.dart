import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:la_linguere/models/result_model.dart';

class ResultsService {
  late final Dio _dio;
  static final ResultsService instance = ResultsService._();

  ResultsService._() {
    _dio = Dio(
      BaseOptions(
        baseUrl: "https://www.thesportsdb.com/api/v1/json/$freeApiKey",
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        responseType: ResponseType.json,
      ),
    );
    _dio.interceptors.add(
      LogInterceptor(request: true, requestBody: true, responseBody: false),
    );
  }

  final freeApiKey = "123";
  final unencodedPath = "/eventsseason.php";

  final queryParameters = {"id": "4754", "s": "2024-2025"};

  Future<List<ResultModel>> getResults() async {
    try {
      final response = await _dio.get(
        unencodedPath,
        queryParameters: queryParameters,
      );
      //
      if (response.statusCode == 200) {
        final data = response.data;
        final List<dynamic> events = data["events"];
        return events.map<ResultModel>((e) => ResultModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      log("Error while getting results: $e");
      return [];
    }
  }
}
