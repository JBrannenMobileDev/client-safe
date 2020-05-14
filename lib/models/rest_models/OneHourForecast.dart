class OneHourForecast {
  final String time;
  final int temperature;
  final int weather_code;
  final List<dynamic> weather_descriptions;
  final int cloudcover;
  final int chanceofrain;

  const OneHourForecast({
    this.time,
    this.temperature,
    this.weather_code,
    this.weather_descriptions,
    this.cloudcover,
    this.chanceofrain,
  });

  static OneHourForecast fromMap(dynamic map) {
    return OneHourForecast(
      time: map['time'],
      temperature: map['temperature'],
      weather_code: map['weather_code'],
      weather_descriptions: map['weather_descriptions'],
      cloudcover: map['cloudcover'],
      chanceofrain: map['chanceofrain'],
    );
  }
}