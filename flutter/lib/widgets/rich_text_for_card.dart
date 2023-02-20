import 'package:flutter/material.dart';

class RichTextForCard extends StatelessWidget {
  final String label;
  final double labelSize;
  final FontWeight labelWeight;
  final String value;
  final double valueSize;
  final FontWeight valueWeight;
  final Color valueColor;

  const RichTextForCard({
    super.key,
    required this.label,
    this.labelSize = 17.0,
    this.labelWeight = FontWeight.w500,
    required this.value,
    this.valueSize = 16.0,
    this.valueWeight = FontWeight.w700,
    required this.valueColor
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: valueSize,
          color: Colors.blueGrey.shade900, 
          fontWeight: labelWeight
        ),
        children: [
          TextSpan(text: label, style: TextStyle(fontSize: labelSize)),
          TextSpan(text: value, style: TextStyle(color: valueColor, fontWeight: valueWeight)),
        ]
      )
    );
  }
}