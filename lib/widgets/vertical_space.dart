import 'package:flutter/material.dart';

class VerticalSpace extends StatelessWidget {
  final double value;
  final BuildContext ctx;

  const VerticalSpace({super.key, required this.value, required this.ctx});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: value);
  }
}
