class TimeZone {
  String code;
  String name;
  double gmtOffset;
  bool isDaylightSaving;
  String nextOffsetChange;

  TimeZone(
      {this.code,
        this.name,
        this.gmtOffset,
        this.isDaylightSaving,
        this.nextOffsetChange});

  TimeZone.fromJson(Map<String, dynamic> json) {
    code = json['Code'];
    name = json['Name'];
    gmtOffset = json['GmtOffset'];
    isDaylightSaving = json['IsDaylightSaving'];
    nextOffsetChange = json['NextOffsetChange'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Code'] = this.code;
    data['Name'] = this.name;
    data['GmtOffset'] = this.gmtOffset;
    data['IsDaylightSaving'] = this.isDaylightSaving;
    data['NextOffsetChange'] = this.nextOffsetChange;
    return data;
  }
}