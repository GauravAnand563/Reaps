import 'package:flutter/material.dart';

class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader(
      {Key? key, required this.child, required this.isLoading})
      : super(key: key);
  final Widget child;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        (isLoading)
            ? Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.white,
                child: Center(child: const CircularProgressIndicator()),
              )
            : const SizedBox(),
        IgnorePointer(
          ignoring: isLoading,
          child: Opacity(
            opacity: isLoading ? 0.3 : 1,
            child: child,
          ),
        ),
      ],
    );
  }
}
