import 'package:flutter/material.dart';

class DropdownField<T> extends StatelessWidget {
  final String label;
  final T value;
  final List<Map<String, dynamic>> items;
  final void Function(T?) onChanged;

  const DropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.blueGrey.shade900,
            fontSize: 18.0,
            fontWeight: FontWeight.w600
          )
        ),
        const SizedBox(height: 3.0,),
        Container(
          height: 40.0,
          constraints: const BoxConstraints(minWidth: 150.0),
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          decoration: BoxDecoration(
            color: Colors.white24,
            border: Border.all(color: Colors.blueGrey.shade800),
            borderRadius: BorderRadius.circular(15.0)
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              style: const TextStyle(
                fontSize: 15.0,
                color: Colors.black87,
                fontWeight: FontWeight.w500
              ),
              dropdownColor: Colors.deepPurple.shade200.withOpacity(0.85),
              menuMaxHeight: 200.0,
              value: value,
              items: items.map((item) => DropdownMenuItem(
                value: item['value'] as T,
                child: Text(item['text'].toString()),
              )).toList(),
              onChanged: onChanged
            ),
          ),
        ),
      ],
    );
  }
}