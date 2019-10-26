class PriceProfile{
  int id;
  String profileName;
  int price;
  int timeInMin;
  int numOfEdits;
  String icon;

  PriceProfile({
    this.id,
    this.profileName,
    this.price,
    this.timeInMin,
    this.numOfEdits,
    this.icon,
  });

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'profileName': profileName,
      'price' : price,
      'timeInMinutes' : timeInMin,
      'numOfEdits' : numOfEdits,
      'icon' : icon,
    };
  }

  static PriceProfile fromMap(Map<String, dynamic> map) {
    return PriceProfile(
      id: map['id'],
      profileName: map['profileName'],
      price: map['price'],
      timeInMin: map['timeInMin'],
      numOfEdits: map['numOfEdits'],
      icon: map['icon'],
    );
  }
}