import 'package:flutter/material.dart';

class FireFightingKnowledgePage extends StatelessWidget {
  const FireFightingKnowledgePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyWidget(),
    );
  }
}
class BodyWidget extends StatefulWidget {
  const BodyWidget({super.key});

  @override
  State<BodyWidget> createState() => _MyBodyWidgetState();
}

class _MyBodyWidgetState extends State<BodyWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}