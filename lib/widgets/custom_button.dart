import 'package:flutter/material.dart';
import 'package:flappy_bird_project/widgets/custom_button.dart';
import 'package:flappy_bird_project/utils/constants.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final double width;
  final double height;

  const CustomButton({
    Key? key,
    required this.onTap,
    required this.text,
    this.width = 200,
    this.height = 60,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: GameColors.buttonColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
