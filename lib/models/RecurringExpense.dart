import 'package:dandylight/models/Charge.dart';
import 'package:dandylight/pages/new_recurring_expense/NewRecurringExpensePageState.dart';

class RecurringExpense {
  int id;
  String documentId;
  String expenseName;
  double cost;
  String billingPeriod;
  bool isAutoPay;
  DateTime initialChargeDate;
  DateTime cancelDate;
  DateTime resumeDate;
  List<Charge> charges;


  RecurringExpense({
    this.id,
    this.documentId,
    this.expenseName,
    this.cost,
    this.billingPeriod,
    this.isAutoPay,
    this.initialChargeDate,
    this.cancelDate,
    this.resumeDate,
    this.charges,
  });

  Map<String, dynamic> toMap() {
    return {
      'documentId' : documentId,
      'expenseName': expenseName,
      'cost' : cost,
      'billingPeriod' : billingPeriod,
      'isAutoPay' : isAutoPay,
      'initialChargeDate' : initialChargeDate?.millisecondsSinceEpoch ?? null,
      'cancelDate' : cancelDate?.millisecondsSinceEpoch ?? null,
      'resumeDate' : resumeDate?.millisecondsSinceEpoch ?? null,
      'charges' : convertChargesToMap(charges),
    };
  }

  static RecurringExpense fromMap(Map<String, dynamic> map) {
    return RecurringExpense(
      documentId: map['documentId'],
      expenseName: map['expenseName'],
      cost: map['cost']?.toDouble(),
      billingPeriod: map['billingPeriod'],
      isAutoPay: map['isAutoPay'],
      initialChargeDate: map['initialChargeDate'] != null? DateTime.fromMillisecondsSinceEpoch(map['initialChargeDate']) : null,
      cancelDate: map['cancelDate'] != null? DateTime.fromMillisecondsSinceEpoch(map['cancelDate']) : null,
      resumeDate: map['resumeDate'] != null? DateTime.fromMillisecondsSinceEpoch(map['resumeDate']) : null,
      charges: convertMapsToCharges(map['charges']),
    );
  }

  List<Map<String, dynamic>> convertChargesToMap(List<Charge> charges){
    List<Map<String, dynamic>> listOfMaps = List();
    for(Charge charge in charges){
      listOfMaps.add(charge.toMap());
    }
    return listOfMaps;
  }

  static List<Charge> convertMapsToCharges(List listOfMaps){
    List<Charge> listOfCharges = List();
    for(Map map in listOfMaps){
      listOfCharges.add(Charge.fromMap(map));
    }
    return listOfCharges;
  }

  void updateChargeList() {
    switch(billingPeriod) {
      case NewRecurringExpensePageState.BILLING_PERIOD_1MONTH:
        _populateMissing1MonthCharges();
        break;
      case NewRecurringExpensePageState.BILLING_PERIOD_3MONTHS:
        _populateMissing3MonthsCharges();
        break;
      case NewRecurringExpensePageState.BILLING_PERIOD_6MONTHS:
        _populateMissing6MonthsCharges();
        break;
      case NewRecurringExpensePageState.BILLING_PERIOD_1YEAR:
        _populateMissing1YearCharges();
        break;
    }
  }

  void _populateMissing1MonthCharges() {
    DateTime dateOfMostRecentCharge;
    if(charges == null) {
      charges = List();
    }
    if(charges.length == 0) {
      dateOfMostRecentCharge = initialChargeDate;
      charges.add(
          Charge(
            chargeAmount: cost,
            chargeDate: dateOfMostRecentCharge,
            isPaid: (isAutoPay ?? true) ? true : false,
          )
      );
    } else {
      dateOfMostRecentCharge = charges.last.chargeDate;
    }
    DateTime now = DateTime.now();
    DateTime dateToIncrement = dateOfMostRecentCharge;

    //only compare months if the years are the same implement a method to do this
    while(isChargeDateBefore(dateToIncrement, now)) {
      charges.add(
          Charge(
            chargeAmount: cost,
            chargeDate: DateTime(dateToIncrement.year, dateToIncrement.month + 1, dateToIncrement.day),
            isPaid: (isAutoPay ?? true) ? true : false,
          )
      );
      dateToIncrement = DateTime(dateToIncrement.year, dateToIncrement.month + 1, dateToIncrement.day);
    }
  }

  void _populateMissing3MonthsCharges() {
    DateTime dateOfMostRecentCharge;
    if(charges == null) {
      charges = List();
    }
    if(charges.length == 0) {
      dateOfMostRecentCharge = initialChargeDate;
      charges.add(
          Charge(
            chargeAmount: cost,
            chargeDate: dateOfMostRecentCharge,
            isPaid: (isAutoPay ?? true) ? true : false,
          )
      );
    } else {
      dateOfMostRecentCharge = charges.last.chargeDate;
    }
    DateTime now = DateTime.now();
    DateTime dateToIncrement = dateOfMostRecentCharge;

    //only compare months if the years are the same implement a method to do this
    while(isChargeDateBefore(dateToIncrement, now)) {
      charges.add(
          Charge(
            chargeAmount: cost,
            chargeDate: DateTime(dateToIncrement.year, dateToIncrement.month + 3, dateToIncrement.day),
            isPaid: (isAutoPay ?? true) ? true : false,
          )
      );
      dateToIncrement = DateTime(dateToIncrement.year, dateToIncrement.month + 3, dateToIncrement.day);
    }
  }

  void _populateMissing6MonthsCharges() {
    DateTime dateOfMostRecentCharge;
    if(charges == null) {
      charges = List();
    }
    if(charges.length == 0) {
      dateOfMostRecentCharge = initialChargeDate;
      charges.add(
          Charge(
            chargeAmount: cost,
            chargeDate: dateOfMostRecentCharge,
            isPaid: (isAutoPay ?? true) ? true : false,
          )
      );
    } else {
      dateOfMostRecentCharge = charges.last.chargeDate;
    }
    DateTime now = DateTime.now();

      DateTime dateToIncrement = dateOfMostRecentCharge;
      while(isChargeDateBefore(dateToIncrement, now)) {
        charges.add(
            Charge(
              chargeAmount: cost,
              chargeDate: DateTime(dateToIncrement.year, dateToIncrement.month + 6, dateToIncrement.day),
              isPaid: (isAutoPay ?? true) ? true : false,
            )
        );
        dateToIncrement = DateTime(dateToIncrement.year, dateToIncrement.month + 6, dateToIncrement.day);
      }
  }

  void _populateMissing1YearCharges() {
    DateTime dateOfMostRecentCharge;
    if(charges == null) {
      charges = List();
    }
    if(charges.length == 0) {
      dateOfMostRecentCharge = initialChargeDate;
      charges.add(
          Charge(
            chargeAmount: cost,
            chargeDate: dateOfMostRecentCharge,
            isPaid: (isAutoPay ?? true) ? true : false,
          )
      );
    } else {
      dateOfMostRecentCharge = charges.last.chargeDate;
    }
    DateTime now = DateTime.now();
      DateTime dateToIncrement = dateOfMostRecentCharge;
      while(isChargeDateBefore(dateToIncrement, now)) {
        charges.add(
            Charge(
              chargeAmount: cost,
              chargeDate: DateTime(dateToIncrement.year + 1, dateToIncrement.month, dateToIncrement.day),
              isPaid: (isAutoPay ?? true) ? true : false,
            )
        );
        dateToIncrement = DateTime(dateToIncrement.year + 1, dateToIncrement.month, dateToIncrement.day);
      }
  }

  double getTotalOfChargesForYear(int year) {
    double total= 0.0;
    for(Charge charge in charges) {
      if(charge.chargeDate.year == year && charge.isPaid) {
        total = total + charge.chargeAmount;
      }
    }
    return total;
  }

  int getCountOfChargesForYear(int year) {
    int total = 0;
    for(Charge charge in charges) {
      if(charge.chargeDate.year == year && charge.isPaid) {
        total = total + 1;
      }
    }
    return total;
  }

  bool isChargeDateBefore(DateTime dateToIncrement, DateTime now) {
    switch(billingPeriod) {
      case NewRecurringExpensePageState.BILLING_PERIOD_1MONTH:
        if(dateToIncrement.year == now.year) {
          if(dateToIncrement.month < now.month) {
            return true;
          } else {
            return false;
          }
        } else {
          if(dateToIncrement.year < now.year) {
            return true;
          } else {
            return false;
          }
        }
        break;
      case NewRecurringExpensePageState.BILLING_PERIOD_3MONTHS:
        if(dateToIncrement.year == now.year) {
          if(dateToIncrement.month < now.month - 3) {
            return true;
          } else {
            return false;
          }
        } else {
          if(dateToIncrement.year < now.year) {
            return true;
          } else {
            return false;
          }
        }
        break;
      case NewRecurringExpensePageState.BILLING_PERIOD_6MONTHS:
        if(dateToIncrement.year == now.year) {
          if(dateToIncrement.month < now.month - 6) {
            return true;
          } else {
            return false;
          }
        } else {
          if(dateToIncrement.year < now.year) {
            return true;
          } else {
            return false;
          }
        }
        break;
      case NewRecurringExpensePageState.BILLING_PERIOD_1YEAR:
        return dateToIncrement.year < now.year;
        break;
    }
    return false;
  }
}