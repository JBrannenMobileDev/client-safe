class Headline {
  String? effectiveDate;
  int? effectiveEpochDate;
  int? severity;
  String? text;
  String? category;
  String? endDate;
  int? endEpochDate;
  String? mobileLink;
  String? link;

  Headline(
      {this.effectiveDate,
        this.effectiveEpochDate,
        this.severity,
        this.text,
        this.category,
        this.endDate,
        this.endEpochDate,
        this.mobileLink,
        this.link});

  Headline.fromJson(Map<String, dynamic> json) {
    effectiveDate = json['EffectiveDate'];
    effectiveEpochDate = json['EffectiveEpochDate'];
    severity = json['Severity'];
    text = json['Text'];
    category = json['Category'];
    endDate = json['EndDate'];
    endEpochDate = json['EndEpochDate'];
    mobileLink = json['MobileLink'];
    link = json['Link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EffectiveDate'] = this.effectiveDate;
    data['EffectiveEpochDate'] = this.effectiveEpochDate;
    data['Severity'] = this.severity;
    data['Text'] = this.text;
    data['Category'] = this.category;
    data['EndDate'] = this.endDate;
    data['EndEpochDate'] = this.endEpochDate;
    data['MobileLink'] = this.mobileLink;
    data['Link'] = this.link;
    return data;
  }
}