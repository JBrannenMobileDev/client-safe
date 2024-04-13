import 'package:dandylight/models/Charge.dart';

class MileageExpense {
  int? id;
  String? documentId;
  String? jobDocumentId;
  double? totalMiles;
  bool? isRoundTrip;
  double? startLat;
  double? startLng;
  double? deductionRate;
  double? endLat;
  double? endLng;
  Charge? charge;


  MileageExpense({
    this.id,
    this.documentId,
    this.jobDocumentId,
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
      'documentId' : documentId,
      'jobDocumentId' : jobDocumentId,
      'totalMiles': totalMiles,
      'isRoundTrip' : isRoundTrip,
      'startLat' : startLat,
      'startLng' : startLng,
      'deductionRate' : deductionRate,
      'endLat' : endLat,
      'endLng' : endLng,
      'charge' : charge!.toMap(),
    };
  }

  static MileageExpense fromMap(Map<String, dynamic> map) {
    return MileageExpense(
      documentId: map['documentId'],
      jobDocumentId: map['jobDocumentId'] ?? '',
      totalMiles: map['totalMiles'],
      isRoundTrip: map['isRoundTrip'],
      startLat: map['startLat']?.toDouble(),
      startLng: map['startLng']?.toDouble(),
      deductionRate: map['deductionRate']?.toDouble(),
      endLat: map['endLat']?.toDouble(),
      endLng: map['endLng']?.toDouble(),
      charge: Charge.fromMap(map['charge']),
    );
  }
}