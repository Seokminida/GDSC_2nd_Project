import 'dart:async';
import 'dart:typed_data';
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
      String place =
          await LocationService().getPlaceAddress(pointlat, pointlng) as String;

      setState(() {
        _markers.add(
          Marker(
            markerId: MarkerId(markerIdVal),
            position: point,
            icon: BitmapDescriptor.fromBytes(customMarker),
            infoWindow: InfoWindow(
              title: '중간지점',
              snippet: '위도: $pointlat 경도: $pointlng 위치: $place',
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
                        height: 630,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 30,
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
                              primary: Colors.yellow[700],
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
                              primary: Colors.yellow[700],
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
                              primary: Colors.yellow[700],
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
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.yellow[700],
        onPressed: () {
          FlutterDialog();
        },
        label: Icon(Icons.search),
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

  void FlutterDialog() {
    showDialog(
      context: context,
      //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Expanded(
            child: Container(
              width: 350,
              height: 500,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  Expanded(
                    child: Container(
                      width: 350,
                      height: 40,
                      child: MaterialButton(
                        child: Text(
                          "중간장소 찾기",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                          clearMap();
                          var place1 = await LocationService()
                              .getPlace(_originController.text);
                          var place2 = await LocationService()
                              .getPlace(_destinationController.text);
                          var midLat = makenum((place1['lat'] as double),
                              (place2['lat'] as double));
                          var midLng = makenum((place1['lng'] as double),
                              (place2['lng'] as double));

                          var directions = await LocationService()
                              .getDirections(
                                  _originController.text, midLat, midLng);

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
                              LatLng(
                                directions['start_location']['lat'],
                                directions['start_location']['lng'],
                              ),
                              1);

                          _setPolyline(directions['polyline_decoded']);

                          distance = directions['distance']['text'];
                          duration = directions['duration']['text'];

                          showToast(distance + " " + duration);
                        },
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
