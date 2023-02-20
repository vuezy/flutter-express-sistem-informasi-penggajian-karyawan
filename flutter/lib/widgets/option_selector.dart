import 'package:flutter/material.dart';

enum DropdownDirection { vertical, horizontal }

class OptionSelector extends StatelessWidget {
  final DropdownDirection dropdownDirection;
  final String label;
  final double labelSize;
  final double? dropdownWidth;
  final String currentValue;
  final List<String> items;
  final void Function(String?) onChanged;
  
  const OptionSelector({
    super.key,
    this.dropdownDirection = DropdownDirection.vertical,
    required this.label,
    this.labelSize = 15.0,
    this.dropdownWidth,
    required this.currentValue,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    switch (dropdownDirection) {
      case DropdownDirection.vertical:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _buildDropdownField()
        );

      case DropdownDirection.horizontal:
        return Row(
          children: _buildDropdownField()
        );
    }
  }

  List<Widget> _buildDropdownField() {
    return [
      Text(
        label,
        style: TextStyle(
          color: Colors.blueGrey.shade900,
          fontWeight: FontWeight.bold,
          fontSize: labelSize
        )
      ),
      Container(
        width: dropdownWidth,
        height: 30.0,
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
          color: Colors.white24,
          border: Border.all(color: Colors.blueGrey.shade800),
          borderRadius: BorderRadius.circular(15.0)
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            style: TextStyle(
              fontSize: 15.0,
              color: Colors.blueGrey.shade900,
              fontWeight: FontWeight.w500
            ),
            dropdownColor: Colors.deepPurple.shade200.withOpacity(0.85),
            menuMaxHeight: 200.0,
            value: currentValue,
            items: items.map((item) => DropdownMenuItem(
              value: item,
              child: Text(item),
            )).toList(),
            onChanged: onChanged
          ),
        ),
      ),
    ];
  }
}