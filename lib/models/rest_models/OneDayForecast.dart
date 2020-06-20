import 'package:dandylight/models/rest_models/OneHourForecast.dart';

class OneDayForecast {
  final String date;
  final int date_epoch;
  final int mintemp;
  final int maxtemp;
  final int avgtemp;
  final List<OneHourForecast> hourly;

  const OneDayForecast({
    this.date,
    this.date_epoch,
    this.mintemp,
    this.maxtemp,
    this.avgtemp,
    this.hourly,
  });

  static OneDayForecast fromMap(dynamic map) {
    return OneDayForecast(
      date: map['date'],
      date_epoch: map['date_epoch'],
      mintemp: map['mintemp'],
      maxtemp: map['maxtemp'],
      avgtemp: map['avgtemp'],
      hourly: convertMapsToJobStages(map['hourly']),
    );
  }

  static List<OneHourForecast> convertMapsToJobStages(List listOfMaps){
    List<OneHourForecast> listOfHourForecasts = List();
    for(Map map in listOfMaps){
      listOfHourForecasts.add(OneHourForecast.fromMap(map));
    }
    return listOfHourForecasts;
  }
}