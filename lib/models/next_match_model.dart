class NextMatchModel {
  NextMatchModel({
    required this.competitionLogo,
    required this.competitionName,
    required this.day,
    required this.matchTime,
    required this.teamLogoHome,
    required this.teamNameHome,
    required this.teamLogoAway,
    required this.teamNameAway,
  });

  final String teamLogoAway,
      teamLogoHome,
      competitionLogo,
      matchTime,
      competitionName,
      day,
      teamNameHome,
      teamNameAway;
}

class NextMatchWomanModel extends NextMatchModel {
  NextMatchWomanModel({
    required super.competitionLogo,
    required super.competitionName,
    required super.day,
    required super.matchTime,
    required super.teamLogoHome,
    required super.teamNameHome,
    required super.teamLogoAway,
    required super.teamNameAway,
  });
}

class NextMatchU15Model extends NextMatchModel {
  NextMatchU15Model({
    required super.competitionLogo,
    required super.competitionName,
    required super.day,
    required super.matchTime,
    required super.teamLogoHome,
    required super.teamNameHome,
    required super.teamLogoAway,
    required super.teamNameAway,
  });
}
