import 'package:dandylight/models/Charge.dart';

class MileageExpense {
  int id;
  String documentId;
  double totalMiles;
  bool isRoundTrip;
  double startLat;
  double startLng;
  double deductionRate;
  double endLat;
  double endLng;
  Charge charge;


  MileageExpense({
    this.id,
    this.documentId,
    this.totalMiles,
    this.isRoundTrip,
    this.startLat,
    this.startLng,
    this.deductionRate,
    this.endLat,
    this.endLng,
    this.charge
  });

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'documentId' : documentId,
      'totalMiles': totalMiles,
      'isRoundTrip' : isRoundTrip,
      'startLat' : startLat,
      'startLng' : startLng,
      'deductionRate' : deductionRate,
      'endLat' : endLat,
      'endLng' : endLng,
      'charge' : charge.toMap(),
    };
  }

  static MileageExpense fromMap(Map<String, dynamic> map) {
    return MileageExpense(
      id: map['id'],
      documentId: map['documentId'],
      totalMiles: map['totalMiles'],
      isRoundTrip: map['isRoundTrip'],
      startLat: map['startLat'],
      startLng: map['startLng'],
      deductionRate: map['deductionRate'],
      endLat: map['endLat'],
      endLng: map['endLng'],
      charge: Charge.fromMap(map['charge']),
    );
  }
}