import 'package:dandylight/models/rest_models/Current.dart';
import 'package:dandylight/models/rest_models/Location.dart';
import 'package:dandylight/models/rest_models/Request.dart';
import 'package:flutter/cupertino.dart';

class Forecast7Days {
  final Request request;
  final Location location;
  final Current current;
  final Map<dynamic, dynamic> forecast;

  const Forecast7Days({this.request, this.location, this.current, this.forecast});

  static Forecast7Days fromJson(dynamic json) {
    return Forecast7Days(
      request: Request.fromJson(json['request']),
      location: Location.fromJson(json['location']),
      current: Current.fromJson(json['current']),
      forecast: json['forecast'],
    );
  }

  AssetImage getCurrentWeatherIcon(DateTime sunsetTime){
    AssetImage icon = AssetImage('assets/images/icons/sunny_icon_gold.png');
    switch(current.weather_code){
      case 113:
        if(location.localtime_epoch > sunsetTime.millisecondsSinceEpoch){
          icon = AssetImage('assets/images/icons/night_icon_gold.png');
        }else{
          icon = AssetImage('assets/images/icons/sunny_icon_gold.png');
        }
        break;
      case 116:
        icon = AssetImage('assets/images/icons/partly_cloudy_icon.png');
        break;
      case 119:
      case 248:
      case 260:
        icon = AssetImage('assets/images/icons/cloudy_icon.png');
        break;
      case 122:
      case 143:
        icon = AssetImage('assets/images/icons/very_cloudy_icon.png');
        break;
      case 176:
      case 263:
      case 266:
      case 293:
      case 296:
        icon = AssetImage('assets/images/icons/sunny_rainy_icon.png');
        break;
      case 179:
      case 185:
      case 227:
      case 230:
        icon = AssetImage('assets/images/icons/snowing_icon.png');
        break;
      case 182:
      case 281:
      case 284:
      case 311:
        icon = AssetImage('assets/images/icons/hail_icon.png');
        break;
      case 200:
        icon = AssetImage('assets/images/icons/lightning_rain_icon.png');
        break;
      case 299:
      case 302:
      case 305:
      case 308:
        icon = AssetImage('assets/images/icons/rainy_icon.png');
        break;
    }
    return icon;
  }
}
