// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, avoid_print, file_names
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StoreTabPageAdmin extends StatelessWidget {
  Future<List<Marker>> createMarkers() async {
    final List<Marker> markers = [
      Marker(
        markerId: MarkerId('storeLocation1'),
        position: LatLng(15.9600595, 108.222599),
        infoWindow: InfoWindow(title: 'Store Location 1'),
        icon: await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(size: Size(1000, 1000)),
          'images/storemap.png',
        ),
      ),
      Marker(
        markerId: MarkerId('storeLocation2'),
        position: LatLng(15.9600595, 108.222599),
        infoWindow: InfoWindow(title: 'Store Location 2'),
        icon: await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(size: Size(48, 48)),
          'images/storemap.png',
        ),
      ),
      Marker(
        markerId: MarkerId('storeLocation2'),
        position: LatLng(15.9600595, 108.222599),
        infoWindow: InfoWindow(title: 'Store Location 2'),
        icon: await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(size: Size(48, 48)),
          'images/storemap.png',
        ),
      ),
      Marker(
        markerId: MarkerId('storeLocation3'),
        position: LatLng(15.9600595, 108.222599),
        infoWindow: InfoWindow(title: 'Store Location 2'),
        icon: await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(size: Size(48, 48)),
          'images/storemap.png',
        ),
      ),
      Marker(
        markerId: MarkerId('storeLocation4'),
        position: LatLng(15.9600595, 108.222599),
        infoWindow: InfoWindow(title: 'Store Location 2'),
        icon: await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(size: Size(48, 48)),
          'images/storemap.png',
        ),
      ),
      Marker(
        markerId: MarkerId('storeLocation5'),
        position: LatLng(15.9600595, 108.222599),
        infoWindow: InfoWindow(title: 'Store Location 2'),
        icon: await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(size: Size(48, 48)),
          'images/storemap.png',
        ),
      ),
      Marker(
        markerId: MarkerId('storeLocation6'),
        position: LatLng(15.9600595, 108.222599),
        infoWindow: InfoWindow(title: 'Store Location 2'),
        icon: await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(size: Size(48, 48)),
          'images/storemap.png',
        ),
      ),
    ];

    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Marker>>(
      future: createMarkers(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<Marker> markers = snapshot.data!;
          return Column(
            children: [
              Expanded(
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(15.9600595, 108.222599),
                    zoom: 15.0,
                  ),
                  markers: Set<Marker>.from(markers),
                ),
              ),
              Divider(
                height: 2.0,
                thickness: 2.0,
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Đã xảy ra lỗi'),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
