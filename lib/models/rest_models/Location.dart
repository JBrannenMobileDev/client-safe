class Location {
  final String name;
  final String country;
  final String region;
  final String lat;
  final String lon;
  final String timezone_id;
  final String localtime; //Format = 2019-09-07 08:14
  final int localtime_epoch; //format = 1567844040,
  final String utc_offset;

  const Location({
    this.name,
    this.country,
    this.region,
    this.lat,
    this.lon,
    this.timezone_id,
    this.localtime,
    this.localtime_epoch,
    this.utc_offset,
  });

  static Location fromJson(dynamic json) {
    return Location(
      name: json['name'],
      country: json['country'],
      region: json['region'],
      lat: json['lat'],
      lon: json['lon'],
      timezone_id: json['timezone_id'],
      localtime: json['localtime'],
      localtime_epoch: json['localtime_epoch'],
      utc_offset: json['utc_offset'],
    );
  }
}