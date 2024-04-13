class LocationDandy {
  int? id;
  String? documentId;
  String? locationName;
  double? latitude;
  double? longitude;
  String? address;
  int? numOfSessionsAtThisLocation;
  String? imageUrl;


  LocationDandy.LocationDandy({
    this.id,
    this.documentId,
    this.locationName,
    this.latitude,
    this.longitude,
    this.address,
    this.numOfSessionsAtThisLocation,
    this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'documentId' : documentId,
      'locationName': locationName,
      'latitude' : latitude,
      'longitude' : longitude,
      'address' : address,
      'numOfSessionsAtThisLocation' : numOfSessionsAtThisLocation,
      'imageUrl' : imageUrl,
    };
  }

  static LocationDandy fromMap(Map<String, dynamic> map) {
    return LocationDandy.LocationDandy(
      documentId: map['documentId'],
      locationName: map['locationName'],
      latitude: map['latitude']?.toDouble(),
      longitude: map['longitude']?.toDouble(),
      address: map['address'],
      numOfSessionsAtThisLocation: map['numOfSessionsAtThisLocation'],
      imageUrl: map['imageUrl'],
    );
  }
}