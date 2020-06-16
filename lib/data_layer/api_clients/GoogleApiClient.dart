import 'dart:convert';

import 'package:client_safe/credentials.dart';
import 'package:client_safe/models/PlacesLocation.dart';
import 'package:client_safe/models/rest_models/DistanceMatrixResponse.dart';
import 'package:client_safe/utils/UUID.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import '../../models/Location.dart';

class GoogleApiClient {
  final _baseUrl = 'https://maps.googleapis.com/maps/api';

  final http.Client httpClient;
  GoogleApiClient({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<List<PlacesLocation>> getLocationResults(String input) async {
    String sessionToken = Uuid().generateV4();
    final url = '$_baseUrl/place/autocomplete/json?input=$input&key=$PLACES_API_KEY&type=(regions)&sessiontoken=$sessionToken';
    final http.Response response = await this.httpClient.get(url);

    if (response.statusCode != 200) {
      throw new Exception('error getting quotes');
    }

    final List<PlacesLocation> locations = List();
    final json = jsonDecode(response.body);
    final predictions = json['predictions'];
    for(Map<dynamic, dynamic> prediction in predictions) {

      locations.add(PlacesLocation(place_id: prediction['place_id'], description: prediction['description']));
    }
    return locations;
  }

  Future<Location> getLocationDetails(String place_id, String description) async {
    final url = '$_baseUrl/place/details/json?key=$PLACES_API_KEY&place_id=$place_id';
    final http.Response response = await this.httpClient.get(url);

    if (response.statusCode != 200) {
      throw new Exception('error getting quotes');
    }

    final json = jsonDecode(response.body);
    final Map<dynamic, dynamic> result = json['result'];
    final Map<dynamic, dynamic> geometry = result['geometry'];
    final Map<dynamic, dynamic> location = geometry['location'];
    return Location(latitude: location['lat'], longitude: location['lng'], locationName: description);
  }
  
  Future<double> getTravelDistance(LatLng startLocation, LatLng endLocation) async{
    double startLat = startLocation.latitude;
    double startLng = startLocation.longitude;
    double endLat = endLocation.latitude;
    double endLng = endLocation.longitude;
    final url = '$_baseUrl/distancematrix/json?units=imperial&key=$DISTANCE_MATRIX_API_KEY&origins=$startLat,$startLng&destinations=$endLat,$endLng';
    final http.Response response = await this.httpClient.get(url);

    if (response.statusCode != 200) {
      throw new Exception('error getting quotes');
    }

    final json = jsonDecode(response.body);
    final DistanceMatrixResponse model = DistanceMatrixResponse.fromJson(json);
    double milesTraveled = model.rows.elementAt(0).elements.elementAt(0).distance.value/1609.344;
    return milesTraveled;
  }
}