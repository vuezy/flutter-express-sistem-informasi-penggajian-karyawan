import 'package:flutter/material.dart';

enum GradientType { light, normal, dark }

class BackgroundImage extends StatelessWidget {
  final String image;
  final Widget child;
  final GradientType gradientType;

  const BackgroundImage({
    super.key,
    required this.image,
    required this.child,
    this.gradientType = GradientType.normal
  });

  LinearGradient _gradient() {
    switch (gradientType) {
      case GradientType.normal:
        return const LinearGradient(
          begin: Alignment.center,
          end: Alignment.bottomCenter,
          colors: [Colors.black45, Colors.black87]
        );
      
      case GradientType.light:
        return LinearGradient(
          begin: Alignment.center,
          end: Alignment.bottomCenter,
          colors: [
            Colors.purpleAccent.shade200.withOpacity(0.2),
            Colors.purpleAccent.shade100.withOpacity(0.4),
            Colors.white30,
            Colors.white24,
            Colors.white12,
          ]
        );
      
      case GradientType.dark:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black87, Colors.black54, Colors.black]
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover
        )
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: _gradient()
        ),
        child: child
      )
    );
  }
}