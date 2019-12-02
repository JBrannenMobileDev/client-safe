class Location {
  int id;
  String locationName;
  double latitude;
  double longitude;
  String address;
  int numOfSessionsAtThisLocation;

  Location({
    this.id,
    this.locationName,
    this.latitude,
    this.longitude,
    this.address,
    this.numOfSessionsAtThisLocation
  });

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'profileName': locationName,
      'latitude' : latitude,
      'longitude' : longitude,
      'address' : address,
      'numOfSessionsAtThisLocation' : numOfSessionsAtThisLocation
    };
  }

  static Location fromMap(Map<String, dynamic> map) {
    return Location(
      id: map['id'],
      locationName: map['locationName'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      address: map['address'],
      numOfSessionsAtThisLocation: map['numOfSessionsAtThisLocation']
    );
  }
}