
class Profile{
  int id;
  String uid;
  String referralUid;
  String deviceToken;
  String firstName;
  String lastName;
  String email;
  String phone;
  String businessName;
  double latDefaultHome;
  double lngDefaultHome;
  bool signedIn;
  bool pushNotificationsEnabled;
  bool calendarEnabled;
  DateTime lastSignIn;
  DateTime clientsLastChangeDate;
  DateTime invoicesLastChangeDate;
  DateTime jobsLastChangeDate;
  DateTime locationsLastChangeDate;
  DateTime mileageExpensesLastChangeDate;
  DateTime priceProfilesLastChangeDate;
  DateTime recurringExpensesLastChangeDate;
  DateTime singleExpensesLastChangeDate;
  DateTime nextInvoiceNumberLastChangeDate;
  DateTime profileLastChangeDate;

  Profile({
    this.id,
    this.uid,
    this.referralUid,
    this.deviceToken,
    this.firstName,
    this.lastName,
    this.businessName,
    this.email,
    this.phone,
    this.latDefaultHome,
    this.lngDefaultHome,
    this.signedIn,
    this.pushNotificationsEnabled,
    this.calendarEnabled,
    this.lastSignIn,
    this.clientsLastChangeDate,
    this.invoicesLastChangeDate,
    this.jobsLastChangeDate,
    this.locationsLastChangeDate,
    this.mileageExpensesLastChangeDate,
    this.priceProfilesLastChangeDate,
    this.recurringExpensesLastChangeDate,
    this.singleExpensesLastChangeDate,
    this.nextInvoiceNumberLastChangeDate,
    this.profileLastChangeDate,
  });

  Profile copyWith({
    int id,
    String uid,
    String referralUid,
    String deviceToken,
    String firstName,
    String lastName,
    String businessName,
    String email,
    String phone,
    double latDefaultHome,
    double lngDefaultHome,
    bool signedIn,
    bool pushNotificationsEnabled,
    bool calendarEnabled,
    DateTime lastSignIn,
    DateTime clientsLastChangeDate,
    DateTime invoicesLastChangeDate,
    DateTime jobsLastChangeDate,
    DateTime locationsLastChangeDate,
    DateTime mileageExpensesLastChangeDate,
    DateTime priceProfilesLastChangeDate,
    DateTime recurringExpensesLastChangeDate,
    DateTime singleExpensesLastChangeDate,
    DateTime nextInvoiceNumberLastChangeDate,
    DateTime profileLastChangeDate,
  }){
    return Profile(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      referralUid: referralUid ?? this.referralUid,
      deviceToken: deviceToken ?? this.deviceToken,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      businessName: businessName ?? this.businessName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      latDefaultHome: latDefaultHome ?? this.latDefaultHome,
      lngDefaultHome: lngDefaultHome ?? this.lngDefaultHome,
      signedIn: signedIn ?? this.signedIn,
      pushNotificationsEnabled: pushNotificationsEnabled ?? this.pushNotificationsEnabled,
      calendarEnabled: calendarEnabled ?? this.calendarEnabled,
      lastSignIn: lastSignIn ?? this.lastSignIn,
      clientsLastChangeDate:  clientsLastChangeDate ?? this.clientsLastChangeDate,
      invoicesLastChangeDate: invoicesLastChangeDate ?? this.invoicesLastChangeDate,
      jobsLastChangeDate: jobsLastChangeDate ?? this.jobsLastChangeDate,
      locationsLastChangeDate: locationsLastChangeDate ?? this.locationsLastChangeDate,
      mileageExpensesLastChangeDate: mileageExpensesLastChangeDate ?? this.mileageExpensesLastChangeDate,
      priceProfilesLastChangeDate: priceProfilesLastChangeDate ?? this.priceProfilesLastChangeDate,
      recurringExpensesLastChangeDate: recurringExpensesLastChangeDate ?? this.recurringExpensesLastChangeDate,
      singleExpensesLastChangeDate: singleExpensesLastChangeDate ?? this.singleExpensesLastChangeDate,
      nextInvoiceNumberLastChangeDate: nextInvoiceNumberLastChangeDate ?? this.nextInvoiceNumberLastChangeDate,
      profileLastChangeDate: profileLastChangeDate ?? this.profileLastChangeDate,
    );
  }



  Map<String, dynamic> toMap() {
    return {
      'uid' : uid,
      'referralUid' : referralUid,
      'deviceToken' : deviceToken,
      'firstName': firstName,
      'lastName' : lastName,
      'email' : email,
      'phone' : phone,
      'businessName' : businessName,
      'latDefaultHome' : latDefaultHome,
      'lngDefaultHome' : lngDefaultHome,
      'signedIn' : signedIn,
      'pushNotificationsEnabled' : pushNotificationsEnabled,
      'calendarEnabled' : calendarEnabled,
      'lastSignIn' : lastSignIn?.millisecondsSinceEpoch ?? null,
      'clientsLastChangeDate' : clientsLastChangeDate?.millisecondsSinceEpoch ?? null,
      'invoicesLastChangeDate' : invoicesLastChangeDate?.millisecondsSinceEpoch ?? null,
      'jobsLastChangeDate' : jobsLastChangeDate?.millisecondsSinceEpoch ?? null,
      'locationsLastChangeDate' : locationsLastChangeDate?.millisecondsSinceEpoch ?? null,
      'mileageExpensesLastChangeDate' : mileageExpensesLastChangeDate?.millisecondsSinceEpoch ?? null,
      'priceProfilesLastChangeDate' : priceProfilesLastChangeDate?.millisecondsSinceEpoch ?? null,
      'recurringExpensesLastChangeDate' : recurringExpensesLastChangeDate?.millisecondsSinceEpoch ?? null,
      'singleExpensesLastChangeDate' : singleExpensesLastChangeDate?.millisecondsSinceEpoch ?? null,
      'nextInvoiceNumberLastChangeDate' : nextInvoiceNumberLastChangeDate?.millisecondsSinceEpoch ?? null,
      'profileLastChangeDate' : profileLastChangeDate?.millisecondsSinceEpoch ?? null,
    };
  }

  static Profile fromMap(Map<String, dynamic> map) {
    return Profile(
      uid: map['uid'],
      referralUid: map['referralUid'],
      deviceToken: map['deviceToken'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      email: map['email'],
      phone: map['phone'],
      businessName: map['businessName'],
      latDefaultHome: map['latDefaultHome'],
      lngDefaultHome: map['lngDefaultHome'],
      signedIn: map['signedIn'],
      pushNotificationsEnabled: map['pushNotificationsEnabled'],
      calendarEnabled: map['calendarEnabled'],
      lastSignIn: map['lastSignIn'] != null? DateTime.fromMillisecondsSinceEpoch(map['lastSignIn']) : null,
      clientsLastChangeDate: map['clientsLastChangeDate'] != null? DateTime.fromMillisecondsSinceEpoch(map['clientsLastChangeDate']) : null,
      invoicesLastChangeDate: map['invoicesLastChangeDate'] != null? DateTime.fromMillisecondsSinceEpoch(map['invoicesLastChangeDate']) : null,
      jobsLastChangeDate: map['jobsLastChangeDate'] != null? DateTime.fromMillisecondsSinceEpoch(map['jobsLastChangeDate']) : null,
      locationsLastChangeDate: map['locationsLastChangeDate'] != null? DateTime.fromMillisecondsSinceEpoch(map['locationsLastChangeDate']) : null,
      mileageExpensesLastChangeDate: map['mileageExpensesLastChangeDate'] != null? DateTime.fromMillisecondsSinceEpoch(map['mileageExpensesLastChangeDate']) : null,
      priceProfilesLastChangeDate: map['priceProfilesLastChangeDate'] != null? DateTime.fromMillisecondsSinceEpoch(map['priceProfilesLastChangeDate']) : null,
      recurringExpensesLastChangeDate: map['recurringExpensesLastChangeDate'] != null? DateTime.fromMillisecondsSinceEpoch(map['recurringExpensesLastChangeDate']) : null,
      singleExpensesLastChangeDate: map['singleExpensesLastChangeDate'] != null? DateTime.fromMillisecondsSinceEpoch(map['singleExpensesLastChangeDate']) : null,
      nextInvoiceNumberLastChangeDate: map['nextInvoiceNumberLastChangeDate'] != null? DateTime.fromMillisecondsSinceEpoch(map['nextInvoiceNumberLastChangeDate']) : null,
      profileLastChangeDate: map['profileLastChangeDate'] != null? DateTime.fromMillisecondsSinceEpoch(map['profileLastChangeDate']) : null,
    );
  }

  bool hasDefaultHome() {
    return (latDefaultHome != null && latDefaultHome != 0.0) || (lngDefaultHome != null && lngDefaultHome != 0.0);
  }
}