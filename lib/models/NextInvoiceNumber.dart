class NextInvoiceNumber {
  int? id;
  int? highestInvoiceNumber;

  NextInvoiceNumber({
    this.id,
    this.highestInvoiceNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'highestInvoiceNumber' : highestInvoiceNumber,
    };
  }

  static NextInvoiceNumber fromMap(Map<String, dynamic> map) {
    return NextInvoiceNumber(
      highestInvoiceNumber: map['highestInvoiceNumber'],
    );
  }
}