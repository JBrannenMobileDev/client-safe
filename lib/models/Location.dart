class Location {
  int id;
  String locationName;
  double latitude;
  double longitude;
  String address;
  String imagePath;
  int numOfSessionsAtThisLocation;


  Location({
    this.id,
    this.locationName,
    this.latitude,
    this.longitude,
    this.address,
    this.imagePath,
    this.numOfSessionsAtThisLocation
  });

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'locationName': locationName,
      'latitude' : latitude,
      'longitude' : longitude,
      'address' : address,
      'imagePath' : imagePath,
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
      imagePath: map['imagePath'],
      numOfSessionsAtThisLocation: map['numOfSessionsAtThisLocation']
    );
  }
}