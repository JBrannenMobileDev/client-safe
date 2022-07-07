import 'package:dandylight/models/rest_models/Current.dart';
import 'package:dandylight/models/rest_models/Location.dart';
import 'package:dandylight/models/rest_models/Request.dart';
import 'package:flutter/cupertino.dart';

import 'Forecast.dart';

class Forecast7Days {
  Location location;
  Current current;
  Forecast forecast;

  Forecast7Days({this.location, this.current, this.forecast});

  Forecast7Days.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    current =
    json['current'] != null ? new Current.fromJson(json['current']) : null;
    forecast = json['forecast'] != null
        ? new Forecast.fromJson(json['forecast'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.location != null) {
      data['location'] = this.location.toJson();
    }
    if (this.current != null) {
      data['current'] = this.current.toJson();
    }
    if (this.forecast != null) {
      data['forecast'] = this.forecast.toJson();
    }
    return data;
  }

  AssetImage getCurrentWeatherIcon(DateTime sunsetTime){
    AssetImage icon = AssetImage('assets/images/icons/sunny_icon_gold.png');
    switch(current.condition.code){
      case 1000:
        if(location.localtimeEpoch > sunsetTime.millisecondsSinceEpoch){
          icon = AssetImage('assets/images/icons/night_icon_gold.png');
        }else{
          icon = AssetImage('assets/images/icons/sunny_icon_gold.png');
        }
        break;
      case 1003:
        icon = AssetImage('assets/images/icons/partly_cloudy_icon.png');
        break;
      case 1006:
      case 1135:
      case 1147:
        icon = AssetImage('assets/images/icons/cloudy_icon.png');
        break;
      case 1009:
      case 1030:
        icon = AssetImage('assets/images/icons/very_cloudy_icon.png');
        break;
      case 1063:
      case 1150:
      case 1153:
      case 1180:
      case 1183:
        icon = AssetImage('assets/images/icons/sunny_rainy_icon.png');
        break;
      case 1066:
      case 1072:
      case 1114:
      case 1117:
      case 1210:
      case 1213:
      case 1216:
      case 1219:
      case 1222:
      case 1225:
      case 1255:
      case 1258:
        icon = AssetImage('assets/images/icons/snowing_icon.png');
        break;
      case 1069:
      case 1168:
      case 1171:
      case 1198:
      case 1204:
      case 1207:
      case 1237:
      case 1249:
      case 1252:
      case 1261:
      case 1264:
        icon = AssetImage('assets/images/icons/hail_icon.png');
        break;
      case 1087:
      case 1273:
      case 1276:
      case 1279:
      case 1282:
        icon = AssetImage('assets/images/icons/lightning_rain_icon.png');
        break;
      case 1186:
      case 1189:
      case 1192:
      case 1195:
      case 1201:
      case 1240:
      case 1243:
      case 1246:
        icon = AssetImage('assets/images/icons/rainy_icon.png');
        break;
    }
    return icon;
  }
}
