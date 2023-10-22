import 'package:dandylight/models/Invoice.dart';

class Income {
  int id;
  int year;
  double totalIncome;
  List<Invoice> invoices;


  Income({
    this.id,
    this.year,
    this.totalIncome,
    this.invoices,
  });

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'year': year,
      'totalIncome' : totalIncome,
      'invoices' : convertInvoicesToMap(invoices),
    };
  }

  static Income fromMap(Map<String, dynamic> map) {
    return Income(
      id: map['id'],
      year: map['year'],
      totalIncome: map['totalIncome']?.toDouble(),
      invoices: convertMapsToInvoices(map['invoices']),
    );
  }

  List<Map<String, dynamic>> convertInvoicesToMap(List<Invoice> invoices){
    List<Map<String, dynamic>> listOfMaps = List();
    for(Invoice invoice in invoices){
      listOfMaps.add(invoice.toMap());
    }
    return listOfMaps;
  }

  static List<Invoice> convertMapsToInvoices(List listOfMaps){
    List<Invoice> invoices = List();
    for(Map map in listOfMaps){
      invoices.add(Invoice.fromMap(map));
    }
    return invoices;
  }
}