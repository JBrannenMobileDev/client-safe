import 'package:client_safe/models/ImportantDate.dart';
import 'package:client_safe/models/Job.dart';
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
  static const String LEAD_SOURCE_BLOG = "Blog";
  static const String LEAD_SOURCE_SOCIAL_MEDIA_INFLUENCER = "Social Media Influencer";
  static const String LEAD_SOURCE_GIVEAWAY = "Free Giveaway";

  int id;
  String firstName;
  String lastName;
  String email;
  String phone;
  String gender;
  String leadSource;
  String spouseFirstName;
  String spouseLastName;
  int numOfChildren;
  List<ImportantDate> importantDates;
  DateTime dateLastContacted;
  List<String> albumLinks;
  String instagramProfileUrl;
  String iconUrl;
  List<Job> jobs;
  String notes;

  Client({
    @required this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.gender,
    this.leadSource,
    this.spouseFirstName,
    this.spouseLastName,
    this.numOfChildren,
    this.importantDates,
    this.dateLastContacted,
    this.albumLinks,
    this.instagramProfileUrl,
    this.iconUrl,
    this.jobs,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName' : lastName,
      'email' : email,
      'phone' : phone,
      'gender' : gender,
      'leadSource' : leadSource,
      'spouseFirstName': spouseFirstName,
      'spouseLastName' : spouseLastName,
      'numOfChildren' : numOfChildren,
      'importantDates' : convertImportantDatesToMaps(importantDates),
      'dateLastContacted' : dateLastContacted,
      'albumLinks' : albumLinks,
      'instagramProfileUrl' : instagramProfileUrl,
      'iconUrl' : iconUrl,
      'jobs' : jobs,
      'notes': notes,
    };
  }

  static Client fromMap(Map<String, dynamic> map) {
    return Client(
      firstName: map['firstName'],
      lastName: map['lastName'],
      email: map['email'],
      phone: map['phone'],
      gender: map['gender'],
      leadSource: map['leadSource'],
      spouseFirstName: map['spouseFirstName'],
      spouseLastName: map['spouseLastName'],
      numOfChildren: map['numOfChildren'],
      importantDates: convertMapsToImportantDates(map['importantDates']),
      dateLastContacted: map['dateLastContacted'],
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
}