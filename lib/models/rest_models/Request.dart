class Request {
  final String type;
  final String query;
  final String language;
  final String unit;

  const Request({this.type, this.query, this.language, this.unit});

  static Request fromJson(dynamic json) {
    return Request(
      type: json['type'],
      query: json['query'],
      language: json['language'],
      unit: json['unit'],
    );
  }
}