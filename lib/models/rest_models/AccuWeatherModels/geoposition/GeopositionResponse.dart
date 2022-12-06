import 'package:dandylight/models/rest_models/AccuWeatherModels/geoposition/AdministrativeArea.dart';
import 'package:dandylight/models/rest_models/AccuWeatherModels/geoposition/Country.dart';
import 'package:dandylight/models/rest_models/AccuWeatherModels/geoposition/GeoPosition.dart';
import 'package:dandylight/models/rest_models/AccuWeatherModels/geoposition/Region.dart';
import 'package:dandylight/models/rest_models/AccuWeatherModels/geoposition/SupplementalAdminAreas.dart';
import 'package:dandylight/models/rest_models/AccuWeatherModels/geoposition/TimeZone.dart';

class GeoPositionResponse {
  int version;
  String key;
  String type;
  int rank;
  String localizedName;
  String englishName;
  String primaryPostalCode;
  Region region;
  Country country;
  AdministrativeArea administrativeArea;
  TimeZone timeZone;
  GeoPosition geoPosition;
  bool isAlias;
  List<SupplementalAdminAreas> supplementalAdminAreas;
  List<String> dataSets;

  GeoPositionResponse(
      {this.version,
        this.key,
        this.type,
        this.rank,
        this.localizedName,
        this.englishName,
        this.primaryPostalCode,
        this.region,
        this.country,
        this.administrativeArea,
        this.timeZone,
        this.geoPosition,
        this.isAlias,
        this.supplementalAdminAreas,
        this.dataSets});

  GeoPositionResponse.fromJson(Map<String, dynamic> json) {
    version = json['Version'];
    key = json['Key'];
    type = json['Type'];
    rank = json['Rank'];
    localizedName = json['LocalizedName'];
    englishName = json['EnglishName'];
    primaryPostalCode = json['PrimaryPostalCode'];
    region =
    json['Region'] != null ? new Region.fromJson(json['Region']) : null;
    country =
    json['Country'] != null ? new Country.fromJson(json['Country']) : null;
    administrativeArea = json['AdministrativeArea'] != null
        ? new AdministrativeArea.fromJson(json['AdministrativeArea'])
        : null;
    timeZone = json['TimeZone'] != null
        ? new TimeZone.fromJson(json['TimeZone'])
        : null;
    geoPosition = json['GeoPosition'] != null
        ? new GeoPosition.fromJson(json['GeoPosition'])
        : null;
    isAlias = json['IsAlias'];
    if (json['SupplementalAdminAreas'] != null) {
      supplementalAdminAreas = new List<SupplementalAdminAreas>();
      json['SupplementalAdminAreas'].forEach((v) {
        supplementalAdminAreas.add(new SupplementalAdminAreas.fromJson(v));
      });
    }
    dataSets = json['DataSets'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Version'] = this.version;
    data['Key'] = this.key;
    data['Type'] = this.type;
    data['Rank'] = this.rank;
    data['LocalizedName'] = this.localizedName;
    data['EnglishName'] = this.englishName;
    data['PrimaryPostalCode'] = this.primaryPostalCode;
    if (this.region != null) {
      data['Region'] = this.region.toJson();
    }
    if (this.country != null) {
      data['Country'] = this.country.toJson();
    }
    if (this.administrativeArea != null) {
      data['AdministrativeArea'] = this.administrativeArea.toJson();
    }
    if (this.timeZone != null) {
      data['TimeZone'] = this.timeZone.toJson();
    }
    if (this.geoPosition != null) {
      data['GeoPosition'] = this.geoPosition.toJson();
    }
    data['IsAlias'] = this.isAlias;
    if (this.supplementalAdminAreas != null) {
      data['SupplementalAdminAreas'] =
          this.supplementalAdminAreas.map((v) => v.toJson()).toList();
    }
    data['DataSets'] = this.dataSets;
    return data;
  }
}