import 'dart:async';

import 'package:flutter/material.dart';
import 'package:boat/location_service.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fisherman App',
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();

  TextEditingController _RegionController = TextEditingController();
  var selectedtype;
  final GlobalKey<FormState> _formkeyValue = new GlobalKey<FormState>();
  List<String> _boatType = <String>["B1", "B2", "B3"];

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(13.087210, 80.339886),
    zoom: 10,
  );

  static Marker get kGooglePlexMarker => Marker(
        markerId: MarkerId('-kGooglePlex'),
        infoWindow: InfoWindow(title: 'Danger'),
        icon: BitmapDescriptor.defaultMarker,
        position: LatLng(13.087210, 80.339886),
      );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Fisherman App')),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _RegionController,
                      decoration:
                          InputDecoration(hintText: 'Search Costal Region '),
                      onChanged: (value) {
                        print(value);
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.directions_boat_outlined, size: 25.0),
                        SizedBox(width: 50.0),
                        DropdownButton(
                          items: _boatType
                              .map((value) => DropdownMenuItem(
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 0, 0, 0)),
                                  ),
                                  value: value))
                              .toList(),
                          onChanged: (selectedboattype) {
                            setState(() {
                              selectedtype = selectedboattype;
                            });
                          },
                          value: selectedtype,
                          isExpanded: false,
                          hint: Text("Select the Boat Type"),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              IconButton(
                onPressed: () async {
                  var place =
                      await LocationService().getPlace(_RegionController.text);
                  _goToPlace(place);
                },
                icon: Icon(Icons.search),
              ),
            ],
          ),
          Expanded(
            child: GoogleMap(
              mapType: MapType.normal,
              markers: {
                kGooglePlexMarker,
              },
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _goToPlace(Map<String, dynamic> place) async {
    final double lat = place['geomentry']['location']['lat'];
    final double lng = place['geomentry']['location']['lng'];

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 20),
      ),
    );
  }
}
