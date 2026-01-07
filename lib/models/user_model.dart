import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

enum MembershipType { notSubscribed, member, supporter, sambaLinguere }

List<String> membershipTypeName = [
  "Non abonné(e)",
  "Membre",
  "Supporter",
  "Samba Linguere",
];

class UserModel {
  UserModel({
    this.fullName,
    this.email,
    this.phoneNumber,
    this.lastLogin,
    this.isMember = false,
    this.membershipType = MembershipType.notSubscribed,
    String? id,
    Timestamp? createdAt,
  }) : id = id ?? uuid.v4(),
       createdAt = createdAt ?? Timestamp.now();

  final String? id, fullName, email, phoneNumber;
  final Timestamp? createdAt, lastLogin;
  bool isMember;
  MembershipType? membershipType;

  Map<String, dynamic> toJson() => {
    "id": id,
    "fullName": fullName,
    "email": email,
    "phoneNumber": phoneNumber,
    "isMember": isMember,
    "membershipType": membershipType?.index,
    "createdAt": createdAt,
    "lastLogin": lastLogin,
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["id"],
    phoneNumber: json["phoneNumber"],
    fullName: json["fullName"],
    email: json["email"],
    isMember: json["isMember"],
    membershipType: json["membershipType"] == null
        ? MembershipType.notSubscribed
        : MembershipType.values[json["membershipType"]],
    createdAt: json["createdAt"],
    lastLogin: json["lastLogin"],
  );
}
