import 'package:flutter/material.dart';

class CustomButtonWidget extends StatelessWidget {
  const CustomButtonWidget({
    required this.onPressed,
    required this.text,
    Key? key,
  }) : super(key: key);
  final VoidCallback? onPressed;
  final Widget text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: TextButton(
          onPressed: onPressed!,
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: Colors.black54,
            elevation: 3,
            shadowColor: Colors.grey[100],
          ),
          child: text),
    );
  }
}
