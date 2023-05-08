import 'package:flutter/material.dart';
import '../styles/app_colors.dart';

class DefaultToolbar extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final bool showBackButton;

  const DefaultToolbar({
    Key? key,
    required this.title,
    this.trailing,
    this.showBackButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(vertical: 8),
      color: AppColors.primary400,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            showBackButton
                ? InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColors.accent100,
                      size: 20,
                    ),
                  )
                : const SizedBox(
                    width: 20,
                  ),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.accent100,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            trailing ?? const SizedBox(width: 20)
          ],
        ),
      ),
    );
  }
}
