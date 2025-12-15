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

  final String competitionLogo,
      matchTime,
      competitionName,
      day,
      teamLogoHome,
      teamNameHome,
      teamLogoAway,
      teamNameAway;
}
