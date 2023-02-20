import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final String? prefixText;
  final String? suffixText;
  
  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.prefixText,
    this.suffixText
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
        const SizedBox(height: 3.0),
        TextFormField(
          style: const TextStyle(color: Colors.black, fontSize: 15.0),
          keyboardType: keyboardType,
          controller: controller,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.0),
            filled: true,
            fillColor: Colors.white24,
            prefixText: prefixText,
            prefixStyle: TextStyle(color: Colors.blueGrey.shade900, fontSize: 15.0, fontWeight: FontWeight.w600),
            suffixText: suffixText,
            suffixStyle: TextStyle(color: Colors.blueGrey.shade900, fontSize: 15.0, fontWeight: FontWeight.w600),
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.black54, fontSize: 15.0, fontWeight: FontWeight.w600),
            errorStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
            errorMaxLines: 2,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide(color: Colors.blueGrey.shade800)
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide(color: Colors.deepPurple.shade500, width: 2)
            ),
          ),
          validator: (value) {
            if (value!.isEmpty) return '$label must be provided!';
            if (keyboardType == TextInputType.number) {
              if (value.contains(RegExp(r'\D+'))) return '$label must contain only numbers!';
            }
            if (keyboardType == TextInputType.name) {
              if (value.contains(RegExp(r'[^A-Za-z ]+'))) return '$label must contain only alphabets!';
            }
            else {
              if (value.contains(RegExp(r'[^A-Za-z0-9\.\- ]+'))) {
                return '$label must contain only alphabets and numbers!';
              }
            }
            return null;
          },
        ),
      ],
    );
  }
}