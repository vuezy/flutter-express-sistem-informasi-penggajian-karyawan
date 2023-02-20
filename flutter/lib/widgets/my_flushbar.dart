import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

enum FlushbarType { success, error }

class MyFlushbar extends StatelessWidget {
  final String message;
  final FlushbarType flushbarType;
  const MyFlushbar({super.key, required this.message, required this.flushbarType});

  void show(BuildContext context) {
    _buildFlushbar().show(context);
  }

  @override
  Widget build(BuildContext context) {
    return _buildFlushbar();
  }

  Flushbar _buildFlushbar() {
    return Flushbar(
      icon: flushbarType == FlushbarType.success ? 
        Icon(Icons.check_circle_outlined, color: Colors.cyan.shade800) : 
        Icon(Icons.error_outline_outlined, color: Colors.redAccent.shade700),
      messageText: Text(
        message,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: flushbarType == FlushbarType.success ? 
            Colors.cyan.shade800 : 
            Colors.redAccent.shade700,
          fontSize: 15.0
        ),
      ),
      maxWidth: 250.0,
      padding: const EdgeInsets.all(12.0),
      borderRadius: BorderRadius.circular(10.0),
      duration: const Duration(milliseconds: 2500),
      animationDuration: const Duration(milliseconds: 500),
      backgroundColor: flushbarType == FlushbarType.success ? 
        Colors.greenAccent.shade200.withOpacity(0.9) : 
        Colors.redAccent.shade100.withOpacity(0.8),
      flushbarPosition: FlushbarPosition.TOP,
    );
  }
}