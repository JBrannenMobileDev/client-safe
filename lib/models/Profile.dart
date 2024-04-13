import 'ColorTheme.dart';
import 'FontTheme.dart';
import 'Questionnaire.dart';

class Profile{
  int? id;
  String? uid;
  String? referralUid;
  List<dynamic>? deviceTokens;
  List<dynamic>? calendarIdsToSync;
  String? firstName;
  String? lastName;
  String? licenseNumber;
  String? email;
  String? phone;
  String? businessName;
  bool? zelleEnabled;
  bool? venmoEnabled;
  bool? cashAppEnabled;
  bool? applePayEnabled;
  bool? cashEnabled;
  bool? otherEnabled;
  bool? wireEnabled;
  bool? hasSetupBrand;
  bool? canShowAppReview; //set to false if user clicks do not show again or if they click the request action
  bool? canShowPMFSurvey; //set to false if user clicks do not show again or if they click the request action
  DateTime? requestReviewDate;
  DateTime? requestPMFSurveyDate;
  DateTime? updateLastSeenDate;
  String? zellePhoneEmail;
  String? zelleFullName;
  String? venmoLink;
  String? cashAppLink;
  String? applePayPhone;
  String? instagramUrl;
  String? instagramName;
  String? otherMessage;
  String? cashMessage;
  String? wireMessage;
  double? latDefaultHome;
  double? lngDefaultHome;
  double? salesTaxRate;
  int? jobsCreatedCount;
  bool? logoSelected;
  bool? bannerImageSelected;
  String? logoUrl;
  String? bannerWebUrl;
  String? bannerMobileUrl;
  String? logoCharacter;
  bool? previewLogoSelected;
  bool? previewBannerImageSelected;
  String? previewLogoUrl;
  String? previewBannerWebUrl;
  String? previewBannerMobileUrl;
  String? previewLogoCharacter;
  String? previewJsonContract;
  ColorTheme? selectedColorTheme;
  FontTheme? selectedFontTheme;
  ColorTheme? previewColorTheme;
  FontTheme? previewFontTheme;
  bool? pushNotificationsEnabled = false;
  bool? calendarEnabled = false;
  bool? showNewMileageExpensePage = false;
  bool? termsOfServiceAndPrivacyPolicyChecked = false;
  bool? showRequestPaymentLinksDialog = true;
  bool? hasSeenShowcase = false;
  bool? hasSeenIncomeInfo = false;
  bool? isBetaTester = false;
  bool? shouldShowRestoreSubscription = false;
  bool? usesSalesTax = false;
  bool? isFreeForLife = false;
  bool? onBoardingComplete = false;
  bool? isSubscribed = false;
  DateTime? accountCreatedDate;
  DateTime? lastSignIn;
  DateTime? clientsLastChangeDate;
  DateTime? invoicesLastChangeDate;
  DateTime? jobsLastChangeDate;
  DateTime? locationsLastChangeDate;
  DateTime? mileageExpensesLastChangeDate;
  DateTime? priceProfilesLastChangeDate;
  DateTime? recurringExpensesLastChangeDate;
  DateTime? singleExpensesLastChangeDate;
  DateTime? nextInvoiceNumberLastChangeDate;
  DateTime? profileLastChangeDate;
  DateTime? remindersLastChangeDate;
  DateTime? jobReminderLastChangeDate;
  DateTime? jobTypesLastChangeDate;
  DateTime? contractsLastChangeDate;
  DateTime? posesLastChangeDate;
  DateTime? poseGroupsLastChangeDate;
  DateTime? poseLibraryGroupLastChangeDate;
  DateTime? responsesLastChangeDate;
  DateTime? discountCodesLastChangedTime;
  DateTime? questionnairesLastChangedTime;
  List<Questionnaire>? directSendQuestionnaires;

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
    this.calendarIdsToSync,
    this.showNewMileageExpensePage,
    this.zelleFullName,
    this.zellePhoneEmail,
    this.venmoLink,
    this.cashAppLink,
    this.applePayPhone,
    this.termsOfServiceAndPrivacyPolicyChecked,
    this.showRequestPaymentLinksDialog,
    this.responsesLastChangeDate,
    this.hasSeenShowcase,
    this.hasSeenIncomeInfo,
    this.isBetaTester,
    this.accountCreatedDate,
    this.shouldShowRestoreSubscription,
    this.usesSalesTax,
    this.poseLibraryGroupLastChangeDate,
    this.discountCodesLastChangedTime,
    this.isFreeForLife,
    this.instagramUrl,
    this.onBoardingComplete,
    this.isSubscribed,
    this.jobsCreatedCount,
    this.instagramName,
    this.logoUrl,
    this.previewLogoUrl,
    this.bannerWebUrl,
    this.previewBannerWebUrl,
    this.previewBannerMobileUrl,
    this.previewBannerImageSelected,
    this.bannerMobileUrl,
    this.licenseNumber,
    this.selectedColorTheme,
    this.selectedFontTheme,
    this.logoSelected,
    this.previewLogoSelected,
    this.previewLogoCharacter,
    this.logoCharacter,
    this.bannerImageSelected,
    this.zelleEnabled,
    this.venmoEnabled,
    this.cashAppEnabled,
    this.applePayEnabled,
    this.cashEnabled,
    this.previewFontTheme,
    this.previewColorTheme,
    this.hasSetupBrand,
    this.previewJsonContract,
    this.otherMessage,
    this.otherEnabled,
    this.wireMessage,
    this.wireEnabled,
    this.cashMessage,
    this.canShowAppReview,
    this.canShowPMFSurvey,
    this.requestPMFSurveyDate,
    this.requestReviewDate,
    this.updateLastSeenDate,
    this.questionnairesLastChangedTime,
    this.directSendQuestionnaires,
  });

  Profile copyWith({
    int? id,
    String? uid,
    String? referralUid,
    List<dynamic>? deviceTokens,
    List<dynamic>? calendarIdsToSync,
    String? firstName,
    String? lastName,
    String? businessName,
    String? email,
    String? phone,
    String? licenseNumber,
    String? zellePhoneEmail,
    String? zelleFullName,
    String? venmoLink,
    String? cashAppLink,
    String? applePayPhone,
    String? instagramUrl,
    String? instagramName,
    String? cashMessage,
    double? latDefaultHome,
    double? lngDefaultHome,
    bool? pushNotificationsEnabled,
    bool? calendarEnabled,
    bool? bannerImageSelected,
    bool? showNewMileageExpensePage,
    bool? termsOfServiceAndPrivacyPolicyChecked,
    bool? showRequestPaymentLinksDialog,
    bool? hasSeenShowcase,
    bool? hasSeenIncomeInfo,
    bool? isBetaTester,
    bool? shouldShowRestoreSubscription,
    bool? usesSalesTax,
    bool? isFreeForLife,
    bool? onBoardingComplete,
    bool? isSubscribed,
    bool? zelleEnabled,
    bool? venmoEnabled,
    bool? cashAppEnabled,
    bool? applePayEnabled,
    bool? cashEnabled,
    bool? hasSetupBrand,
    bool? otherEnabled,
    bool? wireEnabled,
    bool? canShowAppReview,
    bool? canShowPMFSurvey,
    DateTime? requestReviewDate,
    DateTime? requestPMFSurveyDate,
    DateTime? updateLastSeenDate,
    String? wireMessage,
    int? jobsCreatedCount,
    bool? logoSelected,
    String? logoUrl,
    String? bannerWebUrl,
    String? bannerMobileUrl,
    String? logoCharacter,
    String? otherMessage,
    bool? previewLogoSelected,
    String? previewLogoUrl,
    String? previewBannerWebUrl,
    String? previewBannerMobileUrl,
    String? previewJsonContract,
    bool? previewBannerImageSelected,
    String? previewLogoCharacter,
    double? salesTaxRate,
    ColorTheme? selectedColorTheme,
    ColorTheme? previewColorTheme,
    FontTheme? selectedFontTheme,
    FontTheme? previewFontTheme,
    DateTime? lastSignIn,
    DateTime? clientsLastChangeDate,
    DateTime? invoicesLastChangeDate,
    DateTime? jobsLastChangeDate,
    DateTime? locationsLastChangeDate,
    DateTime? mileageExpensesLastChangeDate,
    DateTime? priceProfilesLastChangeDate,
    DateTime? recurringExpensesLastChangeDate,
    DateTime? singleExpensesLastChangeDate,
    DateTime? nextInvoiceNumberLastChangeDate,
    DateTime? profileLastChangeDate,
    DateTime? remindersLastChangeDate,
    DateTime? jobReminderLastChangeDate,
    DateTime? jobTypesLastChangeDate,
    DateTime? contractsLastChangeDate,
    DateTime? posesLastChangeDate,
    DateTime? poseGroupsLastChangeDate,
    DateTime? responsesLastChangeDate,
    DateTime? accountCreatedDate,
    DateTime? poseLibraryGroupLastChangeDate,
    DateTime? discountCodesLastChangedTime,
    DateTime? questionnairesLastChangedTime,
    List<Questionnaire>? directSendQuestionnaires,
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
      instagramUrl: instagramUrl ?? this.instagramUrl,
      latDefaultHome: latDefaultHome ?? this.latDefaultHome,
      lngDefaultHome: lngDefaultHome ?? this.lngDefaultHome,
      pushNotificationsEnabled: pushNotificationsEnabled ?? this.pushNotificationsEnabled,
      calendarEnabled: calendarEnabled ?? this.calendarEnabled,
      lastSignIn: lastSignIn ?? this.lastSignIn,
      instagramName: instagramName ?? this.instagramName,
      jobsCreatedCount: jobsCreatedCount ?? this.jobsCreatedCount,
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
      calendarIdsToSync: calendarIdsToSync ?? this.calendarIdsToSync,
      showNewMileageExpensePage: showNewMileageExpensePage ?? this.showNewMileageExpensePage,
      zelleFullName: zelleFullName ?? this.zelleFullName,
      zellePhoneEmail: zellePhoneEmail ?? this.zellePhoneEmail,
      venmoLink: venmoLink ?? this.venmoLink,
      usesSalesTax: usesSalesTax ?? this.usesSalesTax,
      cashAppLink: cashAppLink ?? this.cashAppLink,
      applePayPhone: applePayPhone ?? this.applePayPhone,
      isBetaTester: isBetaTester ?? this.isBetaTester,
      termsOfServiceAndPrivacyPolicyChecked: termsOfServiceAndPrivacyPolicyChecked ?? this.termsOfServiceAndPrivacyPolicyChecked,
      showRequestPaymentLinksDialog: showRequestPaymentLinksDialog ?? this.showRequestPaymentLinksDialog,
      responsesLastChangeDate: responsesLastChangeDate ?? this.responsesLastChangeDate,
      hasSeenShowcase: hasSeenShowcase ?? this.hasSeenShowcase,
      hasSeenIncomeInfo: hasSeenIncomeInfo ?? this.hasSeenIncomeInfo,
      accountCreatedDate: accountCreatedDate ?? this.accountCreatedDate,
      shouldShowRestoreSubscription: shouldShowRestoreSubscription ?? this.shouldShowRestoreSubscription,
      poseLibraryGroupLastChangeDate: poseLibraryGroupLastChangeDate ?? this.poseLibraryGroupLastChangeDate,
      discountCodesLastChangedTime: discountCodesLastChangedTime ?? this.discountCodesLastChangedTime,
      isFreeForLife: isFreeForLife ?? this.isFreeForLife,
      onBoardingComplete: onBoardingComplete ?? this.onBoardingComplete,
      isSubscribed: isSubscribed ?? this.isSubscribed,
      logoUrl: logoUrl ?? this.logoUrl,
      bannerWebUrl: bannerWebUrl ?? this.bannerWebUrl,
      bannerMobileUrl: bannerMobileUrl ?? this.bannerMobileUrl,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      selectedColorTheme: selectedColorTheme ?? this.selectedColorTheme,
      selectedFontTheme: selectedFontTheme ?? this.selectedFontTheme,
      logoSelected: logoSelected ?? this.logoSelected,
      logoCharacter: logoCharacter ?? this.logoCharacter,
      bannerImageSelected: bannerImageSelected ?? this.bannerImageSelected,
      zelleEnabled: zelleEnabled ?? this.zelleEnabled,
      venmoEnabled: venmoEnabled ?? this.venmoEnabled,
      cashAppEnabled: cashAppEnabled ?? this.cashAppEnabled,
      applePayEnabled: applePayEnabled ?? this.applePayEnabled,
      cashEnabled: cashEnabled ?? this.cashEnabled,
      previewColorTheme: previewColorTheme ?? this.previewColorTheme,
      previewFontTheme: previewFontTheme ?? this.previewFontTheme,
      previewLogoCharacter: previewLogoCharacter ?? this.previewLogoCharacter,
      previewLogoSelected: previewLogoSelected ?? this.previewLogoSelected,
      previewLogoUrl: previewLogoUrl ?? this.previewLogoUrl,
      previewBannerWebUrl: previewBannerWebUrl ?? this.previewBannerWebUrl,
      previewBannerMobileUrl: previewBannerMobileUrl ?? this.previewBannerMobileUrl,
      previewBannerImageSelected: previewBannerImageSelected ?? this.previewBannerImageSelected,
      hasSetupBrand: hasSetupBrand ?? this.hasSetupBrand,
      previewJsonContract: previewJsonContract ?? this.previewJsonContract,
      otherMessage: otherMessage ?? this.otherMessage,
      otherEnabled: otherEnabled ?? this.otherEnabled,
      wireEnabled: wireEnabled ?? this.wireEnabled,
      wireMessage: wireMessage ?? this.wireMessage,
      cashMessage: cashMessage ?? this.cashMessage,
      canShowAppReview: canShowAppReview ?? this.canShowAppReview,
      canShowPMFSurvey: canShowPMFSurvey ?? this.canShowPMFSurvey,
      requestPMFSurveyDate: requestPMFSurveyDate ?? this.requestPMFSurveyDate,
      requestReviewDate: requestReviewDate ?? this.requestReviewDate,
      updateLastSeenDate: updateLastSeenDate ?? this.updateLastSeenDate,
      questionnairesLastChangedTime: questionnairesLastChangedTime ?? this.questionnairesLastChangedTime,
      directSendQuestionnaires: directSendQuestionnaires ?? this.directSendQuestionnaires,
    );
  }



  Map<String, dynamic> toMap() {
    return {
      'uid' : uid,
      'referralUid' : referralUid,
      'deviceTokens' : deviceTokens,
      'calendarIdsToSync' : calendarIdsToSync,
      'firstName': firstName,
      'lastName' : lastName,
      'email' : email,
      'phone' : phone,
      'zelleEnabled' : zelleEnabled ?? false,
      'venmoEnabled' : venmoEnabled ?? false,
      'cashAppEnabled' : cashAppEnabled ?? false,
      'applePayEnabled' : applePayEnabled ?? false,
      'wireEnabled' : wireEnabled ?? false,
      'canShowPMFSurvey' : canShowPMFSurvey ?? true,
      'canShowAppReview' : canShowAppReview ?? true,
      'zelleFullName' : zelleFullName,
      'zellePhoneEmail' : zellePhoneEmail,
      'venmoLink' : venmoLink,
      'cashAppLink' : cashAppLink,
      'applePayPhone' : applePayPhone,
      'businessName' : businessName,
      'instagramUrl' : instagramUrl,
      'latDefaultHome' : latDefaultHome,
      'lngDefaultHome' : lngDefaultHome,
      'showRequestPaymentLinksDialog' : showRequestPaymentLinksDialog,
      'pushNotificationsEnabled' : pushNotificationsEnabled,
      'calendarEnabled' : calendarEnabled,
      'bannerImageSelected' : bannerImageSelected ?? true,
      'previewBannerImageSelected' : previewBannerImageSelected ?? false,
      'instagramName' : instagramName ?? "",
      'shouldShowRestoreSubscription' : shouldShowRestoreSubscription ?? false,
      'showNewMileageExpensePage' : showNewMileageExpensePage ?? true,
      'hasSeenShowcase' : hasSeenShowcase ?? false,
      'isBetaTester' : isBetaTester ?? false,
      'isFreeForLife' : isFreeForLife ?? false,
      'onBoardingComplete' : onBoardingComplete ?? false,
      'usesSalesTax' : usesSalesTax ?? false,
      'isSubscribed' : isSubscribed ?? false,
      'logoSelected' : logoSelected ?? false,
      'hasSetupBrand' : hasSetupBrand ?? false,
      'logoUrl' : logoUrl,
      'bannerWebUrl' : bannerWebUrl,
      'bannerMobileUrl' : bannerMobileUrl,
      'previewLogoSelected' : previewLogoSelected ?? false,
      'previewLogoUrl' : previewLogoUrl,
      'previewBannerWebUrl' : previewBannerWebUrl,
      'previewBannerMobileUrl' : previewBannerMobileUrl,
      'logoCharacter' : logoCharacter,
      'previewLogoCharacter' : previewLogoCharacter,
      'previewJsonContract' : previewJsonContract,
      'jobsCreatedCount' : jobsCreatedCount ?? 0,
      'termsOfServiceAndPrivacyPolicyChecked' : termsOfServiceAndPrivacyPolicyChecked,
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
      'responsesLastChangeDate' : responsesLastChangeDate?.millisecondsSinceEpoch ?? null,
      'poseLibraryGroupLastChangeDate' : poseLibraryGroupLastChangeDate?.millisecondsSinceEpoch ?? null,
      'discountCodesLastChangedTime' : discountCodesLastChangedTime?.millisecondsSinceEpoch ?? null,
      'requestReviewDate' : requestReviewDate?.millisecondsSinceEpoch ?? null,
      'requestPMFSurveyDate' : requestPMFSurveyDate?.millisecondsSinceEpoch ?? null,
      'updateLastSeenDate' : updateLastSeenDate?.millisecondsSinceEpoch ?? null,
      'questionnairesLastChangedTime' : questionnairesLastChangedTime?.millisecondsSinceEpoch ?? null,
      'accountCreatedDate' : accountCreatedDate?.millisecondsSinceEpoch ?? DateTime(2023, 2, 1).millisecondsSinceEpoch,
      'salesTaxRate' : salesTaxRate,
      'hasSeenIncomeInfo' : hasSeenIncomeInfo,
      'selectedFontTheme' : selectedFontTheme?.toMap() ?? null,
      'selectedColorTheme' : selectedColorTheme?.toMap() ?? null,
      'previewFontTheme' : previewFontTheme?.toMap() ?? null,
      'previewColorTheme' : previewColorTheme?.toMap() ?? null,
      'cashEnabled' : cashEnabled ?? false,
      'otherEnabled' : otherEnabled ?? false,
      'otherMessage' : otherMessage,
      'wireMessage' : wireMessage,
      'cashMessage' : cashMessage,
      'directSendQuestionnaires' : convertQuestionnairesToMap(directSendQuestionnaires),
    };
  }

  static Profile fromMap(Map<String, dynamic> map) {
    return Profile(
      otherEnabled: map['otherEnabled'] != null ? map['otherEnabled'] : false,
      wireEnabled: map['wireEnabled'] != null ? map['wireEnabled'] : false,
      uid: map['uid'],
      zelleEnabled: map['zelleEnabled'] != null ? map['zelleEnabled'] : false,
      venmoEnabled: map['venmoEnabled'] != null ? map['venmoEnabled'] : false,
      cashAppEnabled: map['cashAppEnabled'] != null ? map['cashAppEnabled'] : false,
      applePayEnabled: map['applePayEnabled'] != null ? map['applePayEnabled'] : false,
      cashEnabled: map['cashEnabled'] != null ? map['cashEnabled'] : false,
      zelleFullName: map['zelleFullName'],
      zellePhoneEmail: map['zellePhoneEmail'],
      otherMessage: map['otherMessage'],
      wireMessage: map['wireMessage'],
      venmoLink: map['venmoLink'],
      cashAppLink: map['cashAppLink'],
      applePayPhone: map['applePayPhone'],
      referralUid: map['referralUid'],
      deviceTokens: map['deviceTokens'],
      calendarIdsToSync: map['calendarIdsToSync'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      email: map['email'],
      phone: map['phone'],
      previewJsonContract: map['previewJsonContract'],
      businessName: map['businessName'],
      latDefaultHome: map['latDefaultHome']?.toDouble(),
      lngDefaultHome: map['lngDefaultHome']?.toDouble(),
      pushNotificationsEnabled: map['pushNotificationsEnabled'],
      calendarEnabled: map['calendarEnabled'] != null ? map['calendarEnabled'] : false,
      canShowAppReview: map['canShowAppReview'] != null ? map['canShowAppReview'] : true,
      canShowPMFSurvey: map['canShowPMFSurvey'] != null ? map['canShowPMFSurvey'] : true,
      salesTaxRate: map['salesTaxRate']?.toDouble(),
      instagramUrl: map['instagramUrl'],
      bannerImageSelected: map['bannerImageSelected'] != null ? map['bannerImageSelected'] : true,
      logoSelected: map['logoSelected'] != null ? map['logoSelected'] : false,
      hasSetupBrand: map['hasSetupBrand'] != null ? map['hasSetupBrand'] : false,
      logoUrl: map['logoUrl'],
      bannerWebUrl: map['bannerWebUrl'],
      bannerMobileUrl: map['bannerMobileUrl'],
      previewBannerImageSelected: map['previewBannerImageSelected'] != null ? map['previewBannerImageSelected'] : false,
      previewLogoSelected: map['previewLogoSelected'] != null ? map['previewLogoSelected'] : false,
      previewLogoUrl: map['previewLogoUrl'],
      previewBannerWebUrl: map['previewBannerWebUrl'],
      previewBannerMobileUrl: map['previewBannerMobileUrl'],
      logoCharacter: map['logoCharacter'] != null ? map['logoCharacter'] : null,
      previewLogoCharacter: map['previewLogoCharacter'] != null ? map['previewLogoCharacter'] : null,
      instagramName: map['instagramName'] != null ? map['instagramName'] : '',
      jobsCreatedCount: map['jobsCreatedCount'] != null ? map['jobsCreatedCount'] : 0,
      showRequestPaymentLinksDialog: map['showRequestPaymentLinksDialog'] != null ? map['showRequestPaymentLinksDialog'] : true,
      hasSeenShowcase: map['hasSeenShowcase'] != null ? map['hasSeenShowcase'] : false,
      isBetaTester: map['isBetaTester'] != null ? map['isBetaTester'] : false,
      isFreeForLife: map['isFreeForLife'] != null ? map['isFreeForLife'] : false,
      usesSalesTax: map['usesSalesTax'] != null ? map['usesSalesTax'] : false,
      onBoardingComplete: map['onBoardingComplete'] != null ? map['onBoardingComplete'] : false,
      shouldShowRestoreSubscription: map['shouldShowRestoreSubscription'] != null ? map['shouldShowRestoreSubscription'] : false,
      showNewMileageExpensePage: map['showNewMileageExpensePage'],
      isSubscribed: map['isSubscribed'] != null ? map['isSubscribed'] : false,
      termsOfServiceAndPrivacyPolicyChecked: map['termsOfServiceAndPrivacyPolicyChecked'],
      hasSeenIncomeInfo: map['hasSeenIncomeInfo'] != null ? map['hasSeenIncomeInfo'] : false,
      selectedColorTheme: map['selectedColorTheme'] != null ? ColorTheme.fromMap(map['selectedColorTheme']) : null,
      selectedFontTheme: map['selectedFontTheme'] != null ? FontTheme.fromMap(map['selectedFontTheme']) : null,
      previewColorTheme: map['previewColorTheme'] != null ? ColorTheme.fromMap(map['previewColorTheme']) : null,
      previewFontTheme: map['previewFontTheme'] != null ? FontTheme.fromMap(map['previewFontTheme']) : null,
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
      responsesLastChangeDate: map['responsesLastChangeDate'] != null? DateTime.fromMillisecondsSinceEpoch(map['responsesLastChangeDate']) : null,
      discountCodesLastChangedTime: map['discountCodesLastChangedTime'] != null ? DateTime.fromMillisecondsSinceEpoch(map['discountCodesLastChangedTime']) : null,
      accountCreatedDate: map['accountCreatedDate'] != null ? DateTime.fromMillisecondsSinceEpoch(map['accountCreatedDate']) : DateTime(2023, 2, 1),
      poseLibraryGroupLastChangeDate: map['poseLibraryGroupLastChangeDate'] != null? DateTime.fromMillisecondsSinceEpoch(map['poseLibraryGroupLastChangeDate']) : null,
      requestPMFSurveyDate: map['requestPMFSurveyDate'] != null? DateTime.fromMillisecondsSinceEpoch(map['requestPMFSurveyDate']) : null,
      requestReviewDate: map['requestReviewDate'] != null? DateTime.fromMillisecondsSinceEpoch(map['requestReviewDate']) : null,
      updateLastSeenDate: map['updateLastSeenDate'] != null ? DateTime.fromMillisecondsSinceEpoch(map['updateLastSeenDate']) : null,
      questionnairesLastChangedTime: map['questionnairesLastChangedTime'] != null ? DateTime.fromMillisecondsSinceEpoch(map['questionnairesLastChangedTime']) : null,
      directSendQuestionnaires: map['questionnaires'] != null ? convertMapsToQuestionnaires(map['questionnaires']) : [],
    );
  }

  List<Map<String, dynamic>> convertQuestionnairesToMap(List<Questionnaire> questionnaires){
    List<Map<String, dynamic>> listOfMaps = [];
    for(Questionnaire questionnaire in questionnaires){
      listOfMaps.add(questionnaire.toMap());
    }
    return listOfMaps;
  }

  static List<Questionnaire> convertMapsToQuestionnaires(List listOfMaps){
    List<Questionnaire> listOfQuestionnaires = [];
    for(Map map in listOfMaps){
      listOfQuestionnaires.add(Questionnaire.fromMap(map));
    }
    return listOfQuestionnaires;
  }

  bool hasDefaultHome() {
    return (latDefaultHome != null && latDefaultHome != 0.0) || (lngDefaultHome != null && lngDefaultHome != 0.0);
  }

  String getInstagramUrl() {
    return "https://www.instagram.com/$instagramName/";
  }

  bool removeDeviceToken(String deviceToken) {
    deviceTokens = deviceTokens?.toList();
    return deviceTokens!.remove(deviceToken);
  }

  bool addUniqueDeviceToken(String deviceToken) {
    bool alreadyExists = false;
    if(deviceTokens == null) deviceTokens = [];
    deviceTokens = deviceTokens!.toList();
    for(String? listToken in deviceTokens!) {
      if(listToken == deviceToken) alreadyExists = true;
    }
    if(!alreadyExists) deviceTokens!.add(deviceToken);
    return !alreadyExists;
  }

  bool isFirstDevice() {
    if(deviceTokens == null) deviceTokens = [];
    deviceTokens = deviceTokens!.toList();
    return deviceTokens!.length <= 1;
  }

  bool paymentOptionsSelected() {
    return zelleEnabled! || venmoEnabled! || cashAppEnabled! || applePayEnabled! || cashEnabled! || otherEnabled! || wireEnabled!;
  }

  bool isProfileComplete() {
    return businessName!.isNotEmpty && (email!.isNotEmpty || phone!.isNotEmpty) && firstName!.isNotEmpty;
  }
}