import 'package:flutter/material.dart';

class CustomSwitchButton extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;
  final double containerWidth;

  const CustomSwitchButton({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    required this.containerWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: containerWidth,
      height: containerWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color.fromARGB(255, 112, 114, 116),
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Color(0xffDC4A48),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            Transform.scale(
              scale: 1.2,
              child: Switch(
                value: value,
                activeTrackColor: Colors.green,
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
