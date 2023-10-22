import 'dart:convert';

import 'package:dandylight/credentials.dart';
import 'package:dandylight/models/PlacesLocation.dart';
import 'package:dandylight/models/rest_models/DistanceMatrixResponse.dart';
import 'package:dandylight/utils/UUID.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import '../../models/LocationDandy.dart';

class GoogleApiClient {
  final _baseUrl = 'https://maps.googleapis.com/maps/api';

  final http.Client httpClient;
  GoogleApiClient({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<List<PlacesLocation>> getLocationResults(String input) async {
    String requestString = input.replaceAll(" ", "%20");
    final url = '$_baseUrl/place/findplacefromtext/json?fields=formatted_address%2Cname%2Crating%2Cgeometry&input=$requestString&inputtype=textquery&key=$PLACES_API_KEY';
    final http.Response response = await this.httpClient.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw new Exception('error getting places');
    }

    final List<PlacesLocation> locations = [];
    final json = jsonDecode(response.body);
    final candidates = json['candidates'];
    for(Map<dynamic, dynamic> candidate in candidates) {
      Map<dynamic, dynamic> geometry = candidate['geometry'];
      Map<dynamic, dynamic> location = geometry['location'];
      locations.add(
          PlacesLocation(
              address: candidate['formatted_address'],
              name: candidate['name'],
              lat: location['lat'],
              lon: location['lng'],
          )
      );
    }
    return locations;
  }

  Future<LocationDandy> getLocationDetails(String place_id, String description) async {
    final url = '$_baseUrl/place/details/json?key=$PLACES_API_KEY&place_id=$place_id';
    final http.Response response = await this.httpClient.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw new Exception('error getting quotes');
    }

    final json = jsonDecode(response.body);
    final Map<dynamic, dynamic> result = json['result'];
    final Map<dynamic, dynamic> geometry = result['geometry'];
    final Map<dynamic, dynamic> location = geometry['location'];
    return LocationDandy.LocationDandy(latitude: location['lat'], longitude: location['lng'], locationName: description);
  }
  
  Future<double> getTravelDistance(LatLng startLocation, LatLng endLocation) async{
    double startLat = startLocation.latitude;
    double startLng = startLocation.longitude;
    double endLat = endLocation.latitude;
    double endLng = endLocation.longitude;
    final url = '$_baseUrl/distancematrix/json?units=imperial&key=$DISTANCE_MATRIX_API_KEY&origins=$startLat,$startLng&destinations=$endLat,$endLng';
    final http.Response response = await this.httpClient.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw new Exception('error getting quotes');
    }

    final json = jsonDecode(response.body);
    final DistanceMatrixResponse model = DistanceMatrixResponse.fromJson(json);
    double milesTraveled = model.rows.elementAt(0).elements.elementAt(0).distance.value/1609.344;
    return milesTraveled;
  }
}