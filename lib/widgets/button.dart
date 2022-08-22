import 'package:flutter/material.dart';

class VioletButton extends StatelessWidget {
  final String text;
  final Function() onPressed;

  VioletButton({
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) => ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: Colors.purple,
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Text(text),
        ),
      );
}
