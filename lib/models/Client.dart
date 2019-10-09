import 'package:client_safe/models/ImportantDate.dart';
import 'package:client_safe/models/Job.dart';
import 'package:flutter/widgets.dart';

class Client{
  static const String GENDER_MALE = "Male";
  static const String GENDER_FEMALE = "Female";

  static const String RELATIONSHIP_MARRIED = "Married";
  static const String RELATIONSHIP_ENGAGED = "Engaged";
  static const String RELATIONSHIP_SINGLE = "Single";

  int id;
  String firstName;
  String lastName;
  String email;
  String phone;
  String gender;
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
      'spouseFirstName': spouseFirstName,
      'spouseLastName' : spouseLastName,
      'numOfChildren' : numOfChildren,
      'importantDates' : importantDates,
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
      spouseFirstName: map['spouseFirstName'],
      spouseLastName: map['spouseLastName'],
      numOfChildren: map['numOfChildren'],
      importantDates: map['importanDates'],
      dateLastContacted: map['dateLastContacted'],
      albumLinks: map['albumLinks'],
      instagramProfileUrl: map['instagramProfileUrl'],
      iconUrl: map['iconUrl'],
      jobs: map['jobs'],
      notes: map['notes'],
    );
  }
}