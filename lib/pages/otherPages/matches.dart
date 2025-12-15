import 'package:flutter/material.dart';

class Matches extends StatefulWidget {
  const Matches({super.key});

  @override
  State<Matches> createState() => _MatchesState();
}

class _MatchesState extends State<Matches> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// App bar content
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),

      /// Body content
      body: const Center(child: Text('matchs'),),

    );
  }
}
