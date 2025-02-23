import 'dart:math';
import 'package:alnitak/pages/bussola/compassViewPainter.dart';
import 'package:alnitak/pages/bussola/neumorphism.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'bussola_model.dart';

class BussolaWidget extends StatefulWidget {
  const BussolaWidget({super.key});

  @override
  State<BussolaWidget> createState() => _BussolaWidgetState();
}

class _BussolaWidgetState extends State<BussolaWidget> {
  double? direction;

  double headingToDegree(double heading) {
    return heading < 0 ? 360 - heading.abs() : heading;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: StreamBuilder<CompassEvent>(
        stream: FlutterCompass.events,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Error reading heading");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          direction = snapshot.data!.heading;

          if (direction == null) {
            return const Text("Device does not have sensors");
          }
          return Stack(
            children: [
              Neumorphism(
                margin: EdgeInsets.all(size.width * 0.06),
                padding: const EdgeInsets.all(10),
                child: Transform.rotate(
                  angle: (direction! * (pi / 180) * -1),
                  child: CustomPaint(
                    size: size,
                    painter: CompassViewPainter(color: Colors.grey),
                  ),
                ),
              ),
              CenterDisplayMeter(direction: headingToDegree(direction!)),
              Positioned.fill(
                top: size.height * 0.28, // Ajusta a posição da agulha
                child: Column(
                  children: [
                    Container(
                      width: 9, // Um pouco menor para melhor estética
                      height: 9,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade500,
                            blurRadius: 3,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 5, // Deixa mais fina para parecer uma agulha
                      height: size.height * 0.12, // Ajuste proporcional
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(10),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade500,
                            blurRadius: 3,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class CenterDisplayMeter extends StatelessWidget {
  const CenterDisplayMeter({
    super.key,
    required this.direction,
  });

  final double direction;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Neumorphism(
      margin: EdgeInsets.all(size.width * 0.27),
      distance: 2.5,
      blur: 5,
      child: Neumorphism(
        margin: EdgeInsets.all(size.width * 0.01),
        distance: 0,
        blur: 0,
        innerShadow: true,
        isReverse: true,
        child: Neumorphism(
          margin: EdgeInsets.all(size.width * 0.05),
          distance: 4,
          blur: 5,
          child: TopGradientContainer(
            padding: EdgeInsets.all(size.width * 0.02),
            child: Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(55, 159, 203, 1),
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment(-5, -5),
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromRGBO(55, 159, 203, 1),
                    Color.fromRGBO(55, 159, 203, 1),
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "${direction.toInt().toString().padLeft(3, '0')}°",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.width * 0.1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    getDirection(direction),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.width * 0.05,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String getDirection(double direction) {
    if (direction >= 337.5 || direction < 22.5) {
      return "N";
    } else if (direction >= 22.5 && direction < 67.5) {
      return "NE";
    } else if (direction >= 67.5 && direction < 112.5) {
      return "E";
    } else if (direction >= 112.5 && direction < 157.5) {
      return "SE";
    } else if (direction >= 157.5 && direction < 202.5) {
      return "S";
    } else if (direction >= 202.5 && direction < 247.5) {
      return "SW";
    } else if (direction >= 247.5 && direction < 292.5) {
      return "W";
    } else if (direction >= 292.5 && direction < 337.5) {
      return "NW";
    } else {
      return "N";
    }
  }
}
