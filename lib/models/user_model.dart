import 'package:uuid/uuid.dart';

const uuid = Uuid();

class UserModel {
  UserModel({
    this.fullName,
    required this.phoneNumber,
    String? id,
  }) : id = id ?? uuid.v4();

  final String? id, fullName;
  final String phoneNumber;
}
