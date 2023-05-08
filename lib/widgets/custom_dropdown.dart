import 'package:flutter/material.dart';

import '../styles/app_colors.dart';

class CustomDropdown extends StatelessWidget {
  final List<String> items;
  final String hintText;
  final FormFieldSetter<String>? onSaved;

  const CustomDropdown({
    Key? key,
    required this.items,
    required this.hintText,
    this.onSaved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ));

    return Container(
      height: 60,
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.only(left: 15, right: 15),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
        border: Border.all(
          color: AppColors.grey400,
          width: 1.5,
        ),
      ),
      child: Center(
        child: DropdownButtonFormField<String>(
            iconEnabledColor: Colors.black,
            decoration: const InputDecoration(
              border: InputBorder.none,
              errorStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.red,
              ),
            ),
            hint: Text(
              hintText,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColors.grey500,
              ),
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null) {
                return "$hintText is required";
              }
              return null;
            },
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
            ),
            isExpanded: true,
            items: items.map(_buildMenuItem).toList(),
            onChanged: (selectedValue) {
              if (onSaved != null) {
                onSaved!(selectedValue);
              }
            }),
      ),
    );
  }
}
