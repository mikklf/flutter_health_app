import 'package:flutter/material.dart';

class SetupTaskWidget extends StatelessWidget {
  final String title;
  final String description;
  final String? completionText;
  final String buttonText;
  final IconData icon;
  final void Function() onPressed;
  final bool isFinished;
  final bool canResubmit;

  const SetupTaskWidget({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.onPressed,
    required this.isFinished,
    this.completionText,
    this.canResubmit = false,
    this.buttonText = "Start",
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: isFinished
                ? const Icon(Icons.check_circle, color: Colors.green)
                : Icon(icon),
            title: Text(title),
            subtitle: Text(description),
          ),
          const Divider(indent: 16, endIndent: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (!isFinished || (isFinished && canResubmit))
                _startButton()
              else
                _finishText(),
              if (completionText != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(completionText!),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _startButton() {
    return TextButton(
      onPressed: onPressed,
      child: Text(buttonText),
    );
  }

  Widget _finishText() {
    return const TextButton(
      onPressed: null,
      child: Text('Done'),
    );
  }
}