class Current {
  final String observation_time; //format = 12:14 PM
  final int temperature;
  final int weather_code;
  final List<dynamic> weather_icons;
  final List<dynamic> weather_descriptions;
  final int wind_speed;
  final int wind_degree; //Format = 2019-09-07 08:14
  final String wind_dir; //format = 1567844040,
  final int pressure;
  final int precip;
  final int humidity;
  final int cloudcover;
  final int feelslike;
  final int uv_index;
  final int visibility;

  const Current({
    this.observation_time,
    this.temperature,
    this.weather_code,
    this.weather_icons,
    this.weather_descriptions,
    this.wind_speed,
    this.wind_degree,
    this.wind_dir,
    this.pressure,
    this.precip,
    this.humidity,
    this.cloudcover,
    this.feelslike,
    this.uv_index,
    this.visibility,
  });

  static Current fromJson(dynamic json) {
    return Current(
      observation_time: json['observation_time'],
      temperature: json['temperature'],
      weather_code: json['weather_code'],
      weather_icons: json['weather_icons'],
      weather_descriptions: json['weather_descriptions'],
      wind_speed: json['wind_speed'],
      wind_degree: json['wind_degree'],
      wind_dir: json['wind_dir'],
      pressure: json['pressure'],
      precip: json['precip'],
      humidity: json['humidity'],
      cloudcover: json['cloudcover'],
      feelslike: json['feelslike'],
      uv_index: json['uv_index'],
      visibility: json['pressure'],
    );
  }
}

