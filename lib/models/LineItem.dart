
class LineItem {

  int id;
  String itemName;
  double itemPrice;
  int itemQuantity;

  LineItem({
    this.id,
    this.itemName,
    this.itemPrice,
    this.itemQuantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'itemName' : itemName,
      'itemPrice' : itemPrice,
      'itemQuantity' : itemQuantity,
    };
  }

  static LineItem fromMap(Map<String, dynamic> map) {
    return LineItem(
      id: map['id'],
      itemName: map['itemName'],
      itemPrice: map['itemPrice']?.toDouble(),
      itemQuantity: map['itemQuantity'],
    );
  }

  double getTotal() {
    return itemPrice * itemQuantity;
  }
}