import 'package:uuid/uuid.dart';

const uuid = Uuid();
class CalendarModel {
  CalendarModel({
    required this.opposingTeamLogo,
    required this.opposingTeamName,
    required this.day,
    required this.dateMatch,
    required this.isHome,
    String? id,
  }) : id = id ?? uuid.v4();

  String id;
  final String opposingTeamLogo, opposingTeamName, day;
  final DateTime dateMatch;
  final bool isHome;
}
