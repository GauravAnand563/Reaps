import 'package:flutter/material.dart';

import '../styles/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final FormFieldSetter<String>? onSaved;
  final String? Function(String?)? validator;
  final int? minLines;

  const CustomTextField(
      {Key? key,
      required this.label,
      this.controller,
      this.onSaved,
      this.validator,
      this.minLines = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: minLines == 1 ? 60 : null,
          child: TextFormField(
            controller: controller,
            maxLines: null,
            minLines: minLines,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: validator ??
                (value) {
                  if (value!.trim().isEmpty) {
                    return "$label isRequired";
                  }
                  return null;
                },
            style: const TextStyle(
                color: AppColors.primary600, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              hintText: label,
              hintStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColors.grey500,
              ),
              errorStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.red,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide(
                  color: AppColors.grey400,
                  width: 1.5,
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide(
                  color: AppColors.primary200,
                  width: 1.5,
                ),
              ),
            ),
            onSaved: onSaved,
          ),
        ),
        const SizedBox(height: 24)
      ],
    );
  }
}
