import 'dart:ui';

import 'package:flutter/material.dart';

import '../styles/app_theme_data.dart';

class FrostedGlassButton extends StatefulWidget {
  const FrostedGlassButton(
      {Key? key,
      required this.onTap,
      this.color,
      this.iconData,
      this.text = "Test"})
      : super(key: key);

  final IconData? iconData;
  final String text;
  final Function onTap;
  final Color? color;
  @override
  State<FrostedGlassButton> createState() => _FrostedGlassButtonState();
}

class _FrostedGlassButtonState extends State<FrostedGlassButton> {
  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.antiAlias,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 50,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: widget.color ?? Colors.black12,
          ),
          child: InkWell(
            onTap: () {
              widget.onTap();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                widget.iconData != null
                    ? Icon(widget.iconData)
                    : const SizedBox(),
                Text(
                  widget.text,
                  style: kh2.copyWith(fontSize: 15),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
