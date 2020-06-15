import 'package:client_safe/models/ImportantDate.dart';
import 'package:client_safe/models/Job.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Profile{
  int id;
  String firstName;
  String lastName;
  String email;
  String phone;
  String gender;
  double latDefaultHome;
  double lngDefaultHome;

  Profile({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.gender,
    this.latDefaultHome,
    this.lngDefaultHome,
  });

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'firstName': firstName,
      'lastName' : lastName,
      'email' : email,
      'phone' : phone,
      'gender' : gender,
      'latDefaultHome' : latDefaultHome,
      'lngDefaultHome' : lngDefaultHome,
    };
  }

  static Profile fromMap(Map<String, dynamic> map) {
    return Profile(
      id: map['id'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      email: map['email'],
      phone: map['phone'],
      gender: map['gender'],
      latDefaultHome: map['latDefaultHome'],
      lngDefaultHome: map['lngDefaultHome']
    );
  }
}