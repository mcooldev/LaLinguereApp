import 'package:uuid/uuid.dart';

const uuid = Uuid();

class ResultModel {
  ResultModel({
    required this.teamHomeName,
    required this.teamHomeLogo,
    required this.teamHomeScore,
    required this.teamAwayName,
    required this.teamAwayLogo,
    required this.teamAwayScore,
    String? id,
  }) : id = id ?? uuid.v4();

  final String id;
  final String teamHomeName, teamHomeLogo, teamHomeScore;
  final String teamAwayName, teamAwayLogo, teamAwayScore;

  factory ResultModel.fromJson(Map<String, dynamic> json) => ResultModel(
    id: json['idEvent'] as String? ?? uuid.v4(),
    teamHomeName: json['strHomeTeam'] as String? ?? '',
    teamHomeLogo: json['strHomeTeamBadge'] as String? ?? '',
    teamHomeScore: json['intHomeScore'] as String? ?? '0',
    teamAwayName: json['strAwayTeam'] as String? ?? '',
    teamAwayLogo: json['strAwayTeamBadge'] as String? ?? '',
    teamAwayScore: json['intAwayScore'] as String? ?? '0',
  );
}
