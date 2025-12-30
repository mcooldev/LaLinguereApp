import 'package:flutter/cupertino.dart';

class ContactModel {
  ContactModel({
    required this.label,
    required this.content,
    required this.iconData,
    required this.onTap,
  });

  final String label, content;
  final IconData iconData;

  final void Function() onTap;
}
