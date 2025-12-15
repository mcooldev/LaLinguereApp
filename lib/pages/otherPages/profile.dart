import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// App bar content
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),

      /// Body cotent
      body: const Center(child: Text('profil'),),


    );
  }
}
