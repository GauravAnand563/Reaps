import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'states.dart';

import 'constants.dart';
import 'main.dart';

class LocationChanger extends StatelessWidget {
  const LocationChanger({
    super.key,
    required this.selectedLocationIndex,
  });

  final int selectedLocationIndex;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      onTap: () {
        showModalBottomSheet<void>(
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            ),
            context: context,
            builder: (context) {
              return Container(
                height: 400,
                decoration: const BoxDecoration(
                    color: kScaffoldBackgroundColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25))),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      Text(
                        'Choose Location',
                        style: kh4.copyWith(color: Colors.blueGrey.shade100),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      LocationChip(
                        text: locations[selectedLocationIndex],
                        index: selectedLocationIndex,
                      ),
                      for (int i = 0; i < locations.length; i++)
                        (i != selectedLocationIndex)
                            ? InkWell(
                                onTap: () {
                                  Provider.of<LocationIndex>(context,
                                          listen: false)
                                      .setIndex(i);
                                  Navigator.pop(context);
                                },
                                child: LocationChip(
                                  text: locations[i],
                                  index: i,
                                ))
                            : Container()
                    ],
                  ),
                ),
              );
            });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            locations[Provider.of<LocationIndex>(context).selectedIndex],
            style: kh2,
          ),
          const SizedBox(width: 10),
          const Icon(
            Icons.arrow_drop_down,
            size: 20,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}

class LocationChip extends StatefulWidget {
  LocationChip({super.key, required this.text, required this.index});

  // bool isSelected;
  String text;
  int index;

  @override
  State<LocationChip> createState() => _LocationChipState();
}

class _LocationChipState extends State<LocationChip> {
  @override
  Widget build(BuildContext context) {
    int currentIndex = Provider.of<LocationIndex>(context).selectedIndex;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      height: 60,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        // color: currentIndex == widget.index
        //     ? kSecondaryColor
        //     : Colors.blueGrey.shade900,
        gradient: (currentIndex == widget.index)
            ? const LinearGradient(
                colors: [
                  Color.fromARGB(255, 78, 253, 151),
                  Color(0xff06C0B5),
                ],
              )
            : null,
        borderRadius: const BorderRadius.all(
          Radius.circular(
            12,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 24,
            width: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: currentIndex == widget.index
                    ? Colors.white
                    : Colors.blueGrey.shade400,
                width: 1.5,
              ),
            ),
            child: Center(
              child: Container(
                height: 12,
                width: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: currentIndex == widget.index ? Colors.white : null,
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Text(
            widget.text,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: currentIndex == widget.index
                    ? Colors.white
                    : Colors.white30),
          ),
        ],
      ),
    );
  }
}
