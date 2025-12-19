import 'package:flutter/cupertino.dart';

class ContactModel {
  ContactModel({
    required this.label,
    required this.content,
    required this.iconData,
  });

  final String label, content;
  final IconData iconData;
}
