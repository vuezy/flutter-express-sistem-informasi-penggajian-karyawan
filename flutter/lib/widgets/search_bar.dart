import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final void Function(String?) onSubmitted;
  const SearchBar({super.key, required this.controller, required this.hintText, required this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        constraints: const BoxConstraints(maxHeight: 45.0),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 15.0),
        prefixIcon: const Icon(Icons.search, size: 24.0,),
        filled: true,
        fillColor: Colors.white24,
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black54, fontSize: 15.0),
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
      onSubmitted: onSubmitted,
    );
  }
}