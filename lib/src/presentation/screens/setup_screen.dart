import 'package:flutter/material.dart';

class SetupScreen extends StatelessWidget {
  const SetupScreen({super.key});

    // Informed consent
    // Get relevant user data (Home location)
    // Mabye permissions

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Setup screen',
      home: Scaffold(
        body: Center(
          child: Text('This is the setup screen'),
        ),
      ),
    );
  }
}
