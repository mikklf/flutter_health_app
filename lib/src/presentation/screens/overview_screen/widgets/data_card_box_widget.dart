import 'package:flutter/material.dart';

class DataCardBoxWidget extends StatelessWidget {
  final Widget? child;

  const DataCardBoxWidget({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 250,
        child: Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: child,
          ),
        ));
  }
}
