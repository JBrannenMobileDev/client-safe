
import 'Maximum.dart';
import 'Minimum.dart';

class Temperature {
  Minimum? minimum;
  Maximum? maximum;

  Temperature({this.minimum, this.maximum});

  Temperature.fromJson(Map<String, dynamic> json) {
    minimum =
    json['Minimum'] != null ? new Minimum.fromJson(json['Minimum']) : null;
    maximum =
    json['Maximum'] != null ? new Maximum.fromJson(json['Maximum']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.minimum != null) {
      data['Minimum'] = this.minimum!.toJson();
    }
    if (this.maximum != null) {
      data['Maximum'] = this.maximum!.toJson();
    }
    return data;
  }
}