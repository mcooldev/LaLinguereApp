import 'package:uuid/uuid.dart';

const uuid = Uuid();

class NewsModel {
  NewsModel({
    required this.imageActu,
    required this.titleActu,
    required this.bodyActu,
    required this.dateActu,
    String? id,
  }) : id = id ?? uuid.v4();

  final String id;
  final String imageActu;
  final String titleActu;
  final String bodyActu;
  final DateTime dateActu;

}
