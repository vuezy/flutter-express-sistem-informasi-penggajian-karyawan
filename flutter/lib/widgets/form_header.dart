import 'package:flutter/material.dart';

class FormHeader extends StatelessWidget {
  final String title;
  final bool showId;
  final int? id;
  const FormHeader({super.key, required this.title, this.showId = false, this.id});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: showId ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: () { Navigator.of(context).pop(); },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.arrow_back, color: Colors.deepPurple.shade900,),
                const SizedBox(width: 10.0,),
                Text('Back', style: TextStyle(fontSize: 16.0, color: Colors.deepPurple.shade900))
              ],
            )
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Playfair Display',
            fontSize: 32.0,
            fontWeight: FontWeight.w600,
            color: Colors.blueGrey.shade900
          ),
        ),
        const SizedBox(height: 5.0,),

        if (showId == true)
        RichText(
          text: TextSpan(
            style: TextStyle(fontSize: 20.0, color: Colors.blueGrey.shade900),
            children: [
              const TextSpan(
                text: 'ID: ',
                style: TextStyle(fontWeight: FontWeight.w800)
              ),
              TextSpan(
                text: id.toString(),
                style: const TextStyle(fontWeight: FontWeight.w500)
              ),
            ]
          )
        ),
        const SizedBox(height: 20.0,)
      ],
    );
  }
}