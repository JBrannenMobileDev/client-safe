import 'package:client_safe/models/Child.dart';
import 'package:client_safe/models/Job.dart';

class Client{
  static const String GENDER_MALE = "Male";
  static const String GENDER_FEMALE = "Female";

  static const String RELATIONSHIP_MARRIED = "Married";
  static const String RELATIONSHIP_ENGAGED = "Engaged";
  static const String RELATIONSHIP_SINGLE = "Single";

  String clientId;
  String name;
  String firstName;
  String lastName;
  String email;
  String phone;
  String gender;
  String partnerName;
  List<Child> children;
  List<DateTime> importantDates;
  DateTime dateLastContacted;
  String albumLink;
  String instagramProfileUrl;
  String portraitUrl;
  bool isMother;
  bool isFather;
  List<Job> jobs;
  String notes;
  bool hasUnpaidJob;

  Client(this.firstName, this.lastName){
    name = firstName + " " + lastName;
  }
}