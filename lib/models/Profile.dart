
class Profile{
  int id;
  String uid;
  String referralUid;
  List<dynamic> deviceTokens;
  String firstName;
  String lastName;
  String email;
  String phone;
  String businessName;
  double latDefaultHome;
  double lngDefaultHome;
  double salesTaxRate;
  bool pushNotificationsEnabled = false;
  bool calendarEnabled = false;
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
  DateTime remindersLastChangeDate;
  DateTime jobReminderLastChangeDate;
  DateTime jobTypesLastChangeDate;
  DateTime contractsLastChangeDate;
  DateTime posesLastChangeDate;
  DateTime poseGroupsLastChangeDate;

  Profile({
    this.id,
    this.uid,
    this.referralUid,
    this.deviceTokens,
    this.firstName,
    this.lastName,
    this.businessName,
    this.email,
    this.phone,
    this.latDefaultHome,
    this.lngDefaultHome,
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
    this.remindersLastChangeDate,
    this.jobReminderLastChangeDate,
    this.jobTypesLastChangeDate,
    this.contractsLastChangeDate,
    this.posesLastChangeDate,
    this.poseGroupsLastChangeDate,
    this.salesTaxRate,
  });

  Profile copyWith({
    int id,
    String uid,
    String referralUid,
    List<dynamic> deviceTokens,
    String firstName,
    String lastName,
    String businessName,
    String email,
    String phone,
    double latDefaultHome,
    double lngDefaultHome,
    bool pushNotificationsEnabled,
    bool calendarEnabled,
    double salesTaxRate,
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
    DateTime remindersLastChangeDate,
    DateTime jobReminderLastChangeDate,
    DateTime jobTypesLastChangeDate,
    DateTime contractsLastChangeDate,
    DateTime posesLastChangeDate,
    DateTime poseGroupsLastChangeDate,
  }){
    return Profile(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      referralUid: referralUid ?? this.referralUid,
      deviceTokens: deviceTokens ?? this.deviceTokens,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      businessName: businessName ?? this.businessName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      latDefaultHome: latDefaultHome ?? this.latDefaultHome,
      lngDefaultHome: lngDefaultHome ?? this.lngDefaultHome,
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
      remindersLastChangeDate: remindersLastChangeDate ?? this.remindersLastChangeDate,
      jobReminderLastChangeDate: jobReminderLastChangeDate ?? this.jobReminderLastChangeDate,
      jobTypesLastChangeDate: jobTypesLastChangeDate ?? this.jobTypesLastChangeDate,
      contractsLastChangeDate: contractsLastChangeDate ?? this.contractsLastChangeDate,
      posesLastChangeDate: posesLastChangeDate ?? this.posesLastChangeDate,
      poseGroupsLastChangeDate: poseGroupsLastChangeDate ?? this.poseGroupsLastChangeDate,
      salesTaxRate: salesTaxRate ?? this.salesTaxRate,
    );
  }



  Map<String, dynamic> toMap() {
    return {
      'uid' : uid,
      'referralUid' : referralUid,
      'deviceTokens' : deviceTokens,
      'firstName': firstName,
      'lastName' : lastName,
      'email' : email,
      'phone' : phone,
      'businessName' : businessName,
      'latDefaultHome' : latDefaultHome,
      'lngDefaultHome' : lngDefaultHome,
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
      'remindersLastChangeDate' : remindersLastChangeDate?.millisecondsSinceEpoch ?? null,
      'jobReminderLastChangeDate' : jobReminderLastChangeDate?.millisecondsSinceEpoch ?? null,
      'jobTypesLastChangeDate' : jobTypesLastChangeDate?.millisecondsSinceEpoch ?? null,
      'contractsLastChangeDate' : contractsLastChangeDate?.millisecondsSinceEpoch ?? null,
      'posesLastChangeDate' : posesLastChangeDate?.millisecondsSinceEpoch ?? null,
      'poseGroupsLastChangeDate' : poseGroupsLastChangeDate?.millisecondsSinceEpoch ?? null,
      'salesTaxRate' : salesTaxRate,
    };
  }

  static Profile fromMap(Map<String, dynamic> map) {
    return Profile(
      uid: map['uid'],
      referralUid: map['referralUid'],
      deviceTokens: map['deviceTokens'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      email: map['email'],
      phone: map['phone'],
      businessName: map['businessName'],
      latDefaultHome: map['latDefaultHome'],
      lngDefaultHome: map['lngDefaultHome'],
      pushNotificationsEnabled: map['pushNotificationsEnabled'],
      calendarEnabled: map['calendarEnabled'],
      salesTaxRate: map['salesTaxRate'],
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
      remindersLastChangeDate: map['remindersLastChangeDate'] != null? DateTime.fromMillisecondsSinceEpoch(map['remindersLastChangeDate']) : null,
      jobReminderLastChangeDate: map['jobReminderLastChangeDate'] != null? DateTime.fromMillisecondsSinceEpoch(map['jobReminderLastChangeDate']) : null,
      jobTypesLastChangeDate: map['jobTypesLastChangeDate'] != null? DateTime.fromMillisecondsSinceEpoch(map['jobTypesLastChangeDate']) : null,
      contractsLastChangeDate: map['contractsLastChangeDate'] != null? DateTime.fromMillisecondsSinceEpoch(map['contractsLastChangeDate']) : null,
      posesLastChangeDate: map['posesLastChangeDate'] != null? DateTime.fromMillisecondsSinceEpoch(map['posesLastChangeDate']) : null,
      poseGroupsLastChangeDate: map['poseGroupsLastChangeDate'] != null? DateTime.fromMillisecondsSinceEpoch(map['poseGroupsLastChangeDate']) : null,
    );
  }

  bool hasDefaultHome() {
    return (latDefaultHome != null && latDefaultHome != 0.0) || (lngDefaultHome != null && lngDefaultHome != 0.0);
  }

  bool removeDeviceToken(String deviceToken) {
    deviceTokens = deviceTokens?.toList();
    return deviceTokens?.remove(deviceToken);
  }

  bool addUniqueDeviceToken(String deviceToken) {
    bool alreadyExists = false;
    if(deviceTokens == null) deviceTokens = [];
    deviceTokens = deviceTokens.toList();
    for(String listToken in deviceTokens) {
      if(listToken == deviceToken) alreadyExists = true;
    }
    if(!alreadyExists) deviceTokens.add(deviceToken);
    return !alreadyExists;
  }
}