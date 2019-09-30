import 'package:client_safe/models/Child.dart';
import 'package:client_safe/models/Job.dart';

class Client{
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