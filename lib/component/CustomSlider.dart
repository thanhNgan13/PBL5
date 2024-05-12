import 'package:flutter/material.dart';

class CustomSlider extends StatelessWidget {
  final String title;
  final double value;
  final ValueChanged<double> onChanged;
  final double containerWidth;
  final double screenWidth;
  final double min;
  final double max;
  final int divisions;
  final bool isEnable;
  const CustomSlider(
      {super.key,
      required this.title,
      required this.value,
      required this.onChanged,
      required this.containerWidth,
      required this.screenWidth,
      required this.min,
      required this.max,
      required this.divisions,
      this.isEnable = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth - 20,
      height: containerWidth / 2,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color.fromARGB(255, 112, 114, 116),
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xffDC4A48),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Slider(
            value: value,
            onChanged: isEnable ? onChanged : null,
            min: min,
            max: max,
            divisions: divisions,
          ),
        ],
      ),
    );
  }
}
