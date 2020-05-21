import 'dart:convert';

import 'package:client_safe/credentials.dart';
import 'package:client_safe/models/PlacesLocation.dart';
import 'package:client_safe/models/rest_models/CurrentWeather.dart';
import 'package:client_safe/models/rest_models/Forecast7Days.dart';
import 'package:client_safe/utils/UUID.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import '../../models/Location.dart';

class GoogleApiClient {
  final _baseUrl = 'https://maps.googleapis.com/maps/api/place';

  final http.Client httpClient;
  GoogleApiClient({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<List<PlacesLocation>> getLocationResults(String input) async {
    String sessionToken = Uuid().generateV4();
    final url = '$_baseUrl/autocomplete/json?input=$input&key=$PLACES_API_KEY&type=(regions)&sessiontoken=$sessionToken';
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
    final url = '$_baseUrl/details/json?key=$PLACES_API_KEY&place_id=$place_id';
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
}