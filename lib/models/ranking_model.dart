import 'package:uuid/uuid.dart';

const  uuid = Uuid();
class RankingModel {
  RankingModel({
    required this.place,
    required this.points,
    required this.playedMatch,
    String? id,
  }) : id = id ?? uuid.v4();

  final String id;
  final int place;
  final int points;
  final int playedMatch;
}
