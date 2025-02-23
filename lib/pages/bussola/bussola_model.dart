import 'dart:async';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class BussolaModel extends ChangeNotifier {
  double _heading = 0.0;
  Position? _currentPosition;
  bool _isLocationEnabled = false;

  double get heading => _heading;
  Position? get currentPosition => _currentPosition;
  bool get isLocationEnabled => _isLocationEnabled;

  StreamSubscription<CompassEvent>? _compassSubscription;
  StreamSubscription<Position>? _locationSubscription;

  void initializeServices(BuildContext context) {
    _startCompass();
    _checkLocationPermission();
  }

  void _startCompass() {
    _compassSubscription = FlutterCompass.events?.listen((CompassEvent event) {
      _heading = event.heading ?? 0;
      notifyListeners();
    });
  }

  Future<void> _checkLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _isLocationEnabled = false;
      notifyListeners();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _isLocationEnabled = false;
        notifyListeners();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _isLocationEnabled = false;
      notifyListeners();
      return;
    }

    _startLocationTracking();
  }

  void _startLocationTracking() {
    _locationSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position position) {
      _currentPosition = position;
      _isLocationEnabled = true;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _compassSubscription?.cancel();
    _locationSubscription?.cancel();
    super.dispose();
  }
}