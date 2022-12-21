class Location {
  int id;
  String documentId;
  String locationName;
  double latitude;
  double longitude;
  String address;
  int numOfSessionsAtThisLocation;
  String imageUrl;


  Location({
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

  static Location fromMap(Map<String, dynamic> map) {
    return Location(
      documentId: map['documentId'],
      locationName: map['locationName'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      address: map['address'],
      numOfSessionsAtThisLocation: map['numOfSessionsAtThisLocation'],
      imageUrl: map['imageUrl'],
    );
  }
}