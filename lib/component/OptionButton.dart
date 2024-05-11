// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OptionButton extends StatelessWidget {
  final String title;
  final String iconUrl;
  final VoidCallback onPressed;

  const OptionButton(
      {super.key,
      required this.title,
      required this.iconUrl,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: InkWell(
        onTap: onPressed,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset(iconUrl),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(fontSize: 20, color: Colors.black),
                      softWrap: true, // Cho phép văn bản tự xuống dòng
                    ),
                  ),
                  IconButton(
                      onPressed: onPressed,
                      icon: Image.asset('assets/icons/next.png'))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
