
class Profile{
  String uid;
  String firstName;
  String lastName;
  String email;
  String phone;
  String businessName;
  double latDefaultHome;
  double lngDefaultHome;
  bool signedIn;

  Profile({
    this.uid,
    this.firstName,
    this.lastName,
    this.businessName,
    this.email,
    this.phone,
    this.latDefaultHome,
    this.lngDefaultHome,
    this.signedIn,
  });

  Profile copyWith({
    String uid,
    String firstName,
    String lastName,
    String businessName,
    String email,
    String phone,
    double latDefaultHome,
    double lngDefaultHome,
    bool signedIn,
  }){
    return Profile(
      uid: uid ?? this.uid,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      businessName: businessName ?? this.businessName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      latDefaultHome: latDefaultHome ?? this.latDefaultHome,
      lngDefaultHome: lngDefaultHome ?? this.lngDefaultHome,
      signedIn: signedIn ?? this.signedIn,
    );
  }



  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName' : lastName,
      'email' : email,
      'phone' : phone,
      'businessName' : businessName,
      'latDefaultHome' : latDefaultHome,
      'lngDefaultHome' : lngDefaultHome,
      'signedIn' : signedIn,
    };
  }

  static Profile fromMap(Map<String, dynamic> map, String documentId) {
    return Profile(
      uid: documentId,
      firstName: map['firstName'],
      lastName: map['lastName'],
      email: map['email'],
      phone: map['phone'],
      businessName: map['businessName'],
      latDefaultHome: map['latDefaultHome'],
      lngDefaultHome: map['lngDefaultHome'],
      signedIn: map['signedIn'],
    );
  }

  bool hasDefaultHome() {
    return latDefaultHome != 0.0 || lngDefaultHome != 0.0;
  }
}