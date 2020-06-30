class NextInvoiceNumber {
  int id;
  int highestInvoiceNumber;

  NextInvoiceNumber({
    this.id,
    this.highestInvoiceNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'highestInvoiceNumber' : highestInvoiceNumber,
    };
  }

  static NextInvoiceNumber fromMap(Map<String, dynamic> map) {
    return NextInvoiceNumber(
      id: map['id'],
      highestInvoiceNumber: map['highestInvoiceNumber'],
    );
  }
}