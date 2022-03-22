import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class LocationService {
  final String key = "AIzaSyAH4OoHMF1XV-nbZm7ouu6XZuX3EmO4FyE";

  Future<String> getPlaceId(String input) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&key=$key';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var placeId = json['candidates'][0]['place_id'] as String;
    return placeId;
  }

  Future<Map<String, dynamic>> getPlace(String input) async {
    final placeId = await getPlaceId(input);

    final String url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key';

    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var results = json['result']['geometry']['location'];

    // print(results);
    return results;
  }

  // Future<String> getPlaceAddress(double lat, double lng) async {
  //   final url =
  //       'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$key';
  //   var response = await http.get(Uri.parse(url));
  //   var json = convert.jsonDecode(response.body);
  //   return json['results'][0]['address_components'][1]['long_name'];
  // }

  Future<Map<String, dynamic>> getDirections(
      String origin, double midLat, double midLng) async {
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$midLat, $midLng&key=$key';

    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);

    print(json.toString());

    var results = {
      // 'bounds_ne': json['routes'][0]['bounds']['northeast'],
      // 'bounds_sw': json['routes'][0]['bounds']['southwest'],
      'start_location': json['routes'][0]['legs'][0]['start_location'],
      'end_location': json['routes'][0]['legs'][0]['end_location'],
      'distance': json['routes'][0]['legs'][0]['distance'],
      'duration': json['routes'][0]['legs'][0]['duration'],
      'polyline': json['routes'][0]['overview_polyline']['points'],
      'polyline_decoded': PolylinePoints()
          .decodePolyline(json['routes'][0]['overview_polyline']['points']),
    };

    print(results);
    return results;
  }
}