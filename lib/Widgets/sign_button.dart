import 'package:flutter/material.dart';

class SignButton extends StatelessWidget {
  final String? buttonText;
  final Color? buttonColor;
  final Color? textColor;
  final VoidCallback? onPressed;

  const SignButton(
      {super.key,
      this.buttonText,
      this.buttonColor,
      this.textColor,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
      child: Text(
        buttonText!,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: textColor, fontWeight: FontWeight.bold, fontSize: 32),
      ),
    );
  }
}
