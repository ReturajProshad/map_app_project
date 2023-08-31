import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final GoogleMapController _googleMapController;
  late Location _location;
  late LatLng _currentLatLng;
  final List<LatLng> _polylineCoordinates = [];

  @override
  void initState() {
    super.initState();
    _location = Location();
    _currentLatLng = const LatLng(24.250151813382207, 89.92231210838047);
    _startLocationUpdates();
  }

  void _startLocationUpdates() {
    _location.onLocationChanged.listen((LocationData locationData) {
      setState(() {
        _currentLatLng =
            LatLng(locationData.latitude!, locationData.longitude!);
        _polylineCoordinates.add(_currentLatLng);
      });

      _googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _currentLatLng, zoom: 15),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Map Screen'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _currentLatLng,
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        // buildingsEnabled: true,
        zoomControlsEnabled: true,
        zoomGesturesEnabled: true,
        trafficEnabled: false,
        onMapCreated: (GoogleMapController controller) {
          _googleMapController = controller;
        },
        compassEnabled: true,
        markers: {
          Marker(
            markerId: MarkerId('current-location'),
            position: _currentLatLng,
            infoWindow: InfoWindow(
              title: 'My Current Location',
              snippet:
                  'Lat: ${_currentLatLng.latitude}, Lng: ${_currentLatLng.longitude}',
            ),
          ),
        },
        polylines: {
          Polyline(
            polylineId: PolylineId('route'),
            color: Colors.blue,
            width: 5,
            points: _polylineCoordinates,
          ),
        },
      ),
    );
  }
}
