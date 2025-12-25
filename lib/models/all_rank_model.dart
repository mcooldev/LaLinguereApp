import 'package:uuid/uuid.dart';

const uuid = Uuid();

class AllRankModel {
  AllRankModel({
    required this.teamName,
    required this.teamLogo,
    required this.rank,
    required this.goalsDiff,
    required this.points,
    required this.playedMatch,
    String? id,
  }) : id = id ?? uuid.v4();

  final String id;
  final String teamName, teamLogo;
  final int rank, goalsDiff, points, playedMatch;
}
