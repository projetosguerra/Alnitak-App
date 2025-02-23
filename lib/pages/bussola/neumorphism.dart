import 'package:flutter/material.dart';

class Neumorphism extends StatelessWidget {
  const Neumorphism({
    super.key,
    required this.child,
    this.distance = 30,
    this.blur = 50,
    this.margin,
    this.padding,
    this.isReverse = false,
    this.innerShadow = false,
  });
  final Widget child;
  final double distance;
  final double blur;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final bool isReverse;
  final bool innerShadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 238, 238, 238),
        shape: BoxShape.circle,
        boxShadow: isReverse
            ? [
                BoxShadow(
                  color: const Color.fromARGB(255, 224, 224, 224),
                  blurRadius: blur,
                  offset: Offset(-distance, -distance),
                ),
                BoxShadow(
                  color: Colors.white,
                  blurRadius: blur,
                  offset: Offset(distance, distance),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.white,
                  blurRadius: blur,
                  offset: Offset(-distance, -distance),
                ),
                BoxShadow(
                  color: const Color.fromARGB(255, 213, 213, 213),
                  blurRadius: blur,
                  offset: Offset(distance, distance),
                ),
              ],
      ),
      child: innerShadow
          ? TopGradientContainer(child: child)
          : child,
    );
  }
}

class TopGradientContainer extends StatelessWidget {
  const TopGradientContainer({
    super.key,
    required this.child, this.margin, this.padding,
  });

  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 226, 226, 226),
              Colors.white,
            ],
          ),
        ),
        child: child,
      );
  }
}
