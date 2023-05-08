import 'package:flutter/material.dart';

import '../styles/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final Function() onTap;
  final bool isPadded;

  const CustomButton({
    Key? key,
    required this.buttonText,
    required this.onTap,
    this.isPadded = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        margin: EdgeInsets.symmetric(horizontal: isPadded ? 0 : 16),
        decoration: const BoxDecoration(
          color: AppColors.primary600,
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        child: Center(
          child: Text(
            buttonText,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
