import 'package:client_safe/models/Child.dart';
import 'package:client_safe/models/Interest.dart';
import 'package:client_safe/models/Job.dart';

class Client{
  String clientId;
  String name;
  String firstName;
  String lastName;
  String email;
  String phone;
  String partnerName;
  List<Child> children;
  List<DateTime> importantDates;
  DateTime dateLastContacted;
  String albumLink;
  String portraitUrl;
  bool isMother;
  bool isFather;
  List<Job> jobs;
  String notes;
  String address;
  List<Interest> interests;
  bool hasUnpaidJob;

  Client(this.firstName, this.lastName){
    name = firstName + " " + lastName;
  }
}