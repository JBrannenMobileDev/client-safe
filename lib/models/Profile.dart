
class Profile{
  int id;
  String uid;
  String firstName;
  String lastName;
  String email;
  String phone;
  String businessName;
  double latDefaultHome;
  double lngDefaultHome;
  bool signedIn;
  DateTime lastSignIn;

  Profile({
    this.id,
    this.uid,
    this.firstName,
    this.lastName,
    this.businessName,
    this.email,
    this.phone,
    this.latDefaultHome,
    this.lngDefaultHome,
    this.signedIn,
    this.lastSignIn,
  });

  Profile copyWith({
    int id,
    String uid,
    String firstName,
    String lastName,
    String businessName,
    String email,
    String phone,
    double latDefaultHome,
    double lngDefaultHome,
    bool signedIn,
    DateTime lastSignIn,
  }){
    return Profile(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      businessName: businessName ?? this.businessName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      latDefaultHome: latDefaultHome ?? this.latDefaultHome,
      lngDefaultHome: lngDefaultHome ?? this.lngDefaultHome,
      signedIn: signedIn ?? this.signedIn,
      lastSignIn: lastSignIn ?? this.lastSignIn,
    );
  }



  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'uid' : uid,
      'firstName': firstName,
      'lastName' : lastName,
      'email' : email,
      'phone' : phone,
      'businessName' : businessName,
      'latDefaultHome' : latDefaultHome,
      'lngDefaultHome' : lngDefaultHome,
      'signedIn' : signedIn,
      'lastSignIn' : lastSignIn?.millisecondsSinceEpoch ?? null,
    };
  }

  static Profile fromMap(Map<String, dynamic> map) {
    return Profile(
      id: map['id'],
      uid: map['uid'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      email: map['email'],
      phone: map['phone'],
      businessName: map['businessName'],
      latDefaultHome: map['latDefaultHome'],
      lngDefaultHome: map['lngDefaultHome'],
      signedIn: map['signedIn'],
      lastSignIn: map['lastSignIn'] != null? DateTime.fromMillisecondsSinceEpoch(map['lastSignIn']) : null,
    );
  }

  bool hasDefaultHome() {
    return (latDefaultHome != null && latDefaultHome != 0.0) || (lngDefaultHome != null && lngDefaultHome != 0.0);
  }
}