import 'package:expense_manager/component/resources/app_color.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String textButton;
  final VoidCallback onPressed;
  const CustomButton({
    super.key,
    required this.textButton,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: const LinearGradient(
          colors: [Color(0xFF07d681), Color(0xFF07a98b)],
        ),
      ),
      width: MediaQuery.of(context).size.width,
      child: TextButton(
        onPressed: () {
          onPressed();
        },
        child: Text(
          textButton,
          style: const TextStyle(
            color: AppColors.contentColorWhite,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
