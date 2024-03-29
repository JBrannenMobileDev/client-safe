
class Charge{
  DateTime? chargeDate;
  double? chargeAmount;
  bool? isPaid;

  Charge({
    this.chargeDate,
    this.chargeAmount,
    this.isPaid,
  });

  Map<String, dynamic> toMap() {
    return {
      'chargeDate' : chargeDate?.millisecondsSinceEpoch ?? null,
      'chargeAmount' : chargeAmount,
      'isPaid' : isPaid,
    };
  }

  static Charge fromMap(Map<String, dynamic> map) {
    return Charge(
      chargeDate: map['chargeDate'] != null? DateTime.fromMillisecondsSinceEpoch(map['chargeDate']) : null,
      chargeAmount: map['chargeAmount']?.toDouble(),
      isPaid: map['isPaid'],
    );
  }
}