import 'package:dandylight/models/ImportantDate.dart';
import 'package:dandylight/models/Job.dart';
import 'package:flutter/widgets.dart';

class Client{
  static const String GENDER_MALE = "Male";
  static const String GENDER_FEMALE = "Female";

  static const String RELATIONSHIP_MARRIED = "Married";
  static const String RELATIONSHIP_ENGAGED = "Engaged";
  static const String RELATIONSHIP_SINGLE = "Single";

  static const String LEAD_SOURCE_WORD_OF_MOUTH = "Word of Mouth";
  static const String LEAD_SOURCE_INSTAGRAM = "Instagram";
  static const String LEAD_SOURCE_FACEBOOK = "Facebook";
  static const String LEAD_SOURCE_BUSINESS_CARD = "Business Card";
  static const String LEAD_SOURCE_WEBSITE = "Website";
  static const String LEAD_SOURCE_SOURCE_WORDPRESS = "Wordpress";
  static const String LEAD_SOURCE_GIVEAWAY = "Free Giveaway";
  static const String LEAD_SOURCE_OTHER = "Other";

  int id;
  String documentId;
  String firstName;
  String lastName;
  String email;
  String phone;
  String gender;
  String leadSource;
  String relationshipStatus;
  String spouseFirstName;
  String spouseLastName;
  int numOfChildren;
  List<ImportantDate> importantDates;
  List<String> albumLinks;
  String instagramProfileUrl;
  String iconUrl;
  List<Job> jobs;
  String notes;

  Client({
    this.id,
    this.documentId,
    @required this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.gender,
    this.leadSource,
    this.relationshipStatus,
    this.spouseFirstName,
    this.spouseLastName,
    this.numOfChildren,
    this.importantDates,
    this.albumLinks,
    this.instagramProfileUrl,
    this.iconUrl,
    this.jobs,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'documentId' : documentId,
      'firstName': firstName,
      'lastName' : lastName,
      'email' : email,
      'phone' : phone,
      'gender' : gender,
      'leadSource' : leadSource,
      'relationshipStatus' : relationshipStatus,
      'spouseFirstName': spouseFirstName,
      'spouseLastName' : spouseLastName,
      'numOfChildren' : numOfChildren,
      'importantDates' : convertImportantDatesToMaps(importantDates),
      'albumLinks' : albumLinks,
      'instagramProfileUrl' : instagramProfileUrl,
      'iconUrl' : iconUrl,
      'jobs' : jobs,
      'notes': notes,
    };
  }

  static Client fromMap(Map<String, dynamic> map) {
    return Client(
      documentId: map['documentId'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      email: map['email'],
      phone: map['phone'],
      gender: map['gender'],
      leadSource: map['leadSource'],
      relationshipStatus: map['relationshipStatus'],
      spouseFirstName: map['spouseFirstName'],
      spouseLastName: map['spouseLastName'],
      numOfChildren: map['numOfChildren'],
      importantDates: convertMapsToImportantDates(map['importantDates']),
      albumLinks: map['albumLinks'],
      instagramProfileUrl: map['instagramProfileUrl'],
      iconUrl: map['iconUrl'],
      jobs: map['jobs'],
      notes: map['notes'],
    );
  }

  List<Map<String, dynamic>> convertImportantDatesToMaps(List<ImportantDate> importantDates){
    List<Map<String, dynamic>> listOfMaps = List();
    for(ImportantDate importantDate in importantDates){
      listOfMaps.add(importantDate.toMap());
    }
    return listOfMaps;
  }

  static List<ImportantDate> convertMapsToImportantDates(List listOfMaps){
    List<ImportantDate> listOfImportantDates = List();
    for(Map map in listOfMaps){
      listOfImportantDates.add(ImportantDate.fromMap(map));
    }
    return listOfImportantDates;
  }

  String getClientFullName(){

    return firstName + " " + lastName;
  }

  String getClientSpouseFullName(){
    return spouseFirstName + " " + spouseLastName;
  }

  String getLeadSourceName() {
    switch(leadSource){
      case 'assets/images/icons/word_of_mouth_icon_white.png':
      case 'assets/images/icons/word_of_mouth_icon_peach.png':
        return 'Word of mouth';
        break;
      case 'assets/images/icons/instagram_icon_white.png':
      case 'assets/images/icons/instagram_icon_peach_light.png':
        return 'Instagram';
        break;
      case 'assets/images/icons/free_giveaway_icon_white.png':
      case 'assets/images/icons/free_giveaway_icon_peach.png':
        return 'Giveaway';
        break;
      case 'assets/images/icons/website_icon_white.png':
      case 'assets/images/icons/website_icon_peach.png':
        return 'Website';
        break;
      case 'assets/images/icons/business_card_icon_white.png':
      case 'assets/images/icons/business_card_icon_peach.png':
        return 'Business card';
        break;
      case 'assets/images/icons/facebook_icon_white.png':
      case 'assets/images/icons/facebook_icon_peach.png':
        return 'Facebook';
        break;
      case 'assets/images/icons/wordpress_icon_white.png':
      case 'assets/images/icons/wordpress_icon_peach.png':
        return 'Wordpress';
        break;
      case 'assets/images/icons/email_icon_white.png':
      case 'assets/images/icons/email_icon_peach_light.png':
        return 'Email';
        break;
    }
    return '';
  }
}