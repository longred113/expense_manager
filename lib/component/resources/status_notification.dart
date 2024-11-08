import 'dart:ui';

import 'package:expense_manager/component/resources/custom_button.dart';
import 'package:flutter/material.dart';

class StatusNotification extends StatelessWidget {
  final bool isSuccess;
  final String title;
  final String message;
  final String textButton;
  final Function? onButtonClick;
  const StatusNotification({
    super.key,
    required this.isSuccess,
    required this.title,
    required this.message,
    required this.textButton,
    this.onButtonClick,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.all(16),
      height: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(
            isSuccess
                ? 'assets/images/dialog_icon_checked.png'
                : 'assets/images/dialog_icon_warning.png',
            width: 70,
            height: 70,
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontFamily: "SUIT",
              fontWeight: FontWeight.bold,
            ),
          ),
          Center(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: "SUIT",
              ),
            ),
          ),
          CustomButton(
            // isDeBouncer: false,
            textButton: textButton,
            onPressed: () {
              if (onButtonClick != null) {
                onButtonClick!();
              } else {
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
}
