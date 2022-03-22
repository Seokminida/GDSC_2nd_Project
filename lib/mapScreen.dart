import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'location_services.dart';//
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:ui' as ui;
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Google Maps Demo',
//       home: MapSample(),
//     );
//   }
// }

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();
  TextEditingController _originController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();

  Set<Marker> _markers = Set<Marker>();
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polygonLatLngs = <LatLng>[];
  bool flag = false;
  String distance = "";
  String duration = "";
  int _markerIdCounter = 1;
  int _polylineIdCounter = 1;
  BitmapDescriptor? markerPerson;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void initState() {
    _checkPermission();
    setCustomMapPin();
    super.initState();
  }

  void setCustomMapPin() async {
    markerPerson = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 5), 'assets/person1.png');
  }

  Future<Uint8List> getBytesFromAsset({String? path, int? width}) async {
    ByteData data = await rootBundle.load(path!);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<void> _setMarker(LatLng point, int num) async {
    final String markerIdVal = 'marker_$_markerIdCounter';
    _markerIdCounter++;
    var pointlat = point.latitude;
    var pointlng = point.longitude;

    if (num == 0) {
      final Uint8List customMarker = await getBytesFromAsset(
          path: "assets/midpoint.png", //paste the custom image path
          width: 100 // size of custom image as marker
          );
      setState(() {
        _markers.add(
          Marker(
            markerId: MarkerId(markerIdVal),
            position: point,
            icon: BitmapDescriptor.fromBytes(customMarker),
            infoWindow: InfoWindow(
              title: '중간지점',
              snippet: '위도: $pointlat 경도: $pointlng 위치:',
            ),
          ),
        );
      });
    } else {
      final Uint8List customMarker = await getBytesFromAsset(
          path: "assets/person1.png", //paste the custom image path
          width: 100 // size of custom image as marker
          );
      setState(() {
        _markers.add(
          Marker(
            markerId: MarkerId(markerIdVal),
            position: point,
            icon: BitmapDescriptor.fromBytes(customMarker),
            infoWindow: InfoWindow(title: markerIdVal, snippet: ''),
          ),
        );
      });
    }
  }

  void _setPolyline(List<PointLatLng> points) {
    final String polylineIdVal = 'polyline_$_polylineIdCounter';
    _polylineIdCounter++;

    _polylines.add(
      Polyline(
        polylineId: PolylineId(polylineIdVal),
        width: 2,
        color: Colors.blue,
        points: points
            .map(
              (point) => LatLng(point.latitude, point.longitude),
            )
            .toList(),
      ),
    );
  }

  void clearMap() {
    _markers.clear();
    _polylines.clear();
    _markerIdCounter = 1;
    _polylineIdCounter = 1;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Google Maps'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    TextField(
                      controller: _originController,
                      decoration: InputDecoration(hintText: ' Origin'),
                      onChanged: (value) {
                        print(value);
                      },
                    ),
                    TextField(
                      controller: _destinationController,
                      decoration: InputDecoration(hintText: ' Destination'),
                      onChanged: (value) {
                        print(value);
                      },
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () async {
                  clearMap();
                  var place1 =
                      await LocationService().getPlace(_originController.text);
                  var place2 = await LocationService()
                      .getPlace(_destinationController.text);
                  var midLat = makenum(
                      (place1['lat'] as double), (place2['lat'] as double));
                  var midLng = makenum(
                      (place1['lng'] as double), (place2['lng'] as double));

                  var directions = await LocationService()
                      .getDirections(_originController.text, midLat, midLng);

                  _setMarker(LatLng(midLat, midLng), 0);
                  _setMarker(
                      LatLng(directions['start_location']['lat'],
                          directions['start_location']['lng']),
                      1);

                  _goToPlace(
                    midLat,
                    midLng,
                  );
                  _setPolyline(directions['polyline_decoded']);

                  distance = directions['distance']['text'];
                  duration = directions['duration']['text'];

                  showToast(distance + " " + duration);

                  directions = await LocationService().getDirections(
                      _destinationController.text, midLat, midLng);
                  _setMarker(
                      LatLng(directions['start_location']['lat'],
                          directions['start_location']['lng']),
                      1);

                  _setPolyline(directions['polyline_decoded']);

                  distance = directions['distance']['text'];
                  duration = directions['duration']['text'];

                  showToast(distance + " " + duration);
                },
                icon: Icon(Icons.search),
              ),
            ],
          ),
          Expanded(
            child: GoogleMap(
              mapType: MapType.normal,
              markers: _markers,
              polylines: _polylines,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {}, label: Icon(Icons.skip_next)),
    );
  }

  double makenum(double place1, double place2) {
    double mid = 0.0;

    if (place1 < place2) {
      double num = place2 - place1;
      num = num / 2;
      mid = place1 + num;
    } else {
      double num = place1 - place2;
      num = num / 2;
      mid = place2 + num;
    }
    return mid;
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.blueGrey,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
    );
  }

  Future<void> _goToPlace(
    double lat,
    double lng,
  ) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 7),
      ),
    );

    // controller.animateCamera(
    //   CameraUpdate.newLatLngBounds(
    //       LatLngBounds(
    //         southwest: LatLng(boundsSw['lat'], boundsSw['lng']),
    //         northeast: LatLng(boundsNe['lat'], boundsNe['lng']),
    //       ),
    //       25),
    // );
  }

  _checkPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error('');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('');
    }
  }
}