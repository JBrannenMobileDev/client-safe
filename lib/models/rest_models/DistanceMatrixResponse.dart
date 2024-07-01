// To parse this JSON data, do
//
//     final distanceMatrixResponse = distanceMatrixResponseFromJson(jsonString);

import 'dart:convert';

DistanceMatrixResponse distanceMatrixResponseFromJson(String str) => DistanceMatrixResponse.fromJson(json.decode(str));

String distanceMatrixResponseToJson(DistanceMatrixResponse data) => json.encode(data.toJson());

class DistanceMatrixResponse {
  DistanceMatrixResponse({
    this.destinationAddresses,
    this.originAddresses,
    this.rows,
    this.status,
  });

  List<String>? destinationAddresses;
  List<String>? originAddresses;
  List<Row>? rows;
  String? status;

  factory DistanceMatrixResponse.fromJson(Map<String, dynamic> json) => DistanceMatrixResponse(
    destinationAddresses: List<String>.from(json["destination_addresses"].map((x) => x)),
    originAddresses: List<String>.from(json["origin_addresses"].map((x) => x)),
    rows: List<Row>.from(json["rows"].map((x) => Row.fromJson(x))),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "destination_addresses": List<dynamic>.from(destinationAddresses!.map((x) => x)),
    "origin_addresses": List<dynamic>.from(originAddresses!.map((x) => x)),
    "rows": List<dynamic>.from(rows!.map((x) => x.toJson())),
    "status": status,
  };
}

class Row {
  Row({
    required this.elements,
  });

  List<Element> elements;

  factory Row.fromJson(Map<String, dynamic> json) => Row(
    elements: List<Element>.from(json["elements"].map((x) => Element.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "elements": List<dynamic>.from(elements.map((x) => x.toJson())),
  };
}

class Element {
  Element({
    required this.distance,
    required this.duration,
    required this.status,
  });

  Distance distance;
  Distance duration;
  String status;

  factory Element.fromJson(Map<String, dynamic> json) => Element(
    distance: Distance.fromJson(json["distance"] ?? Distance(text: '', value: 0)) ,
    duration: Distance.fromJson(json["duration"] ?? Duration()),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "distance": distance.toJson(),
    "duration": duration.toJson(),
    "status": status,
  };
}

class Distance {
  Distance({
    required this.text,
    required this.value,
  });

  String text;
  int value;

  factory Distance.fromJson(Map<String, dynamic> json) => Distance(
    text: json["text"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "text": text,
    "value": value,
  };
}