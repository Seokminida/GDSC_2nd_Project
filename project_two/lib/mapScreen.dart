import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'location_services.dart'; //
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:ui' as ui;
import 'myPage.dart'; //

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
    target: LatLng(39.8520507, -105.7820674),
    zoom: 4,
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
      final Uint8List customMarker =
          await getBytesFromAsset(path: "assets/midpoint.png", width: 100);
      String placeMarker =
          await LocationService().getPlaceAddress(pointlat, pointlng) as String;

      setState(() {
        _markers.add(
          Marker(
            markerId: MarkerId(markerIdVal),
            position: point,
            icon: BitmapDescriptor.fromBytes(customMarker),
            infoWindow: InfoWindow(
              title: '중간지점',
              snippet: '위도: $pointlat 경도: $pointlng 위치: $placeMarker',
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

  String lat = "";
  String lng = "";
  String place = "";

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('We Meet?'),
        backgroundColor: Color.fromARGB(200, 50, 180, 150),
        elevation: 0.0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyPage(),
                ),
              );
            },
            icon: Icon(Icons.person),
          )
        ],
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
                      decoration: InputDecoration(hintText: ' 내 위치'),
                      onChanged: (value) {
                        print(value);
                      },
                    ),
                    TextField(
                      controller: _destinationController,
                      decoration: InputDecoration(hintText: ' 추가 위치'),
                      onChanged: (value) {
                        print(value);
                      },
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  registerDetails(lat, lng, place);
                },
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
                  LocationService()
                      .getPlaceAddress(midLat, midLng)
                      .then((value) => place = value);
                  lat = midLat.toString();
                  lng = midLng.toString();
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
            child: Stack(
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  zoomGesturesEnabled: true,
                  zoomControlsEnabled: false,
                  markers: _markers,
                  polylines: _polylines,
                  initialCameraPosition: _kGooglePlex,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
                Container(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 535,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 40,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              final GoogleMapController controller =
                                  await _controller.future;

                              controller.animateCamera(
                                CameraUpdate.newCameraPosition(_kGooglePlex),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(200, 50, 180, 150),
                              elevation: 0,
                            ),
                            child: Icon(Icons.pin_drop),
                          ),
                          SizedBox(
                            width: 40,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              final GoogleMapController controller =
                                  await _controller.future;
                              controller.animateCamera(
                                CameraUpdate.zoomIn(),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(200, 50, 180, 150),
                              elevation: 0,
                            ),
                            child: Icon(Icons.add),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              final GoogleMapController controller =
                                  await _controller.future;
                              controller.animateCamera(
                                CameraUpdate.zoomOut(),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(200, 50, 180, 150),
                              elevation: 0,
                            ),
                            child: Icon(Icons.remove),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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

  void registerDetails(String lat, String lng, String place) {
    final CollectionReference _user = FirebaseFirestore.instance
        .collection('user')
        .doc('${FirebaseAuth.instance.currentUser!.uid}')
        .collection('route');

    _user.doc().set(
      {
        'lat': lat,
        'lng': lng,
        'place': place,
      },
    );
  }
}
