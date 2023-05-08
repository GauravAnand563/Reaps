import 'dart:ui';

import 'package:flutter/material.dart';
import 'constants.dart';

class FrostedGlassButton extends StatefulWidget {
  const FrostedGlassButton(
      {Key? key,
      required this.onTap,
      this.color,
      required this.label,
      this.iconData,
      this.alt,
      this.text = "Test"})
      : super(key: key);

  final IconData? iconData;
  final String text;
  final Function onTap;
  final String? alt;
  final Color? color;
  final String label;

  @override
  State<FrostedGlassButton> createState() => _FrostedGlassButtonState();
}

class _FrostedGlassButtonState extends State<FrostedGlassButton> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
        child: Container(
          // height: 50,
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 5),
          padding: const EdgeInsets.all(8),
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
                Expanded(
                  child: widget.iconData != null
                      ? Icon(
                          widget.iconData,
                          color: Colors.white,
                          size: 12,
                        )
                      : const SizedBox(),
                ),
                SizedBox(
                  width: 1,
                ),
                Expanded(
                  flex: 4,
                  child: Text(
                    widget.label,
                    style: kh2.copyWith(fontSize: 12),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    widget.text,
                    style: kh2.copyWith(
                        fontSize: 12,
                        color: widget.alt == null
                            ? Colors.blueGrey.shade100
                            : Colors.lightGreen.shade200),
                  ),
                ),
                widget.alt != null
                    ? Expanded(
                        flex: 3,
                        child: Text(
                          widget.alt!,
                          style: kh2.copyWith(
                              fontSize: 12, color: Colors.redAccent.shade200),
                        ),
                      )
                    : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
