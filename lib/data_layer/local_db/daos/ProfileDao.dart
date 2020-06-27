import 'dart:async';

import 'package:dandylight/data_layer/firebase/collections/UserCollection.dart';
import 'package:dandylight/models/Profile.dart';

class ProfileDao{
  static Future create(Profile profile) async {
    await UserCollection().createUser(profile);
  }

  static void  update(Profile profile) {
    UserCollection().updateUser(profile);
  }

  static Future delete(Profile profile) async {
    UserCollection().deleteUser(profile.uid);
  }

  static Future<Profile> getByUid(String documentId) async{
    return await UserCollection().getUser(documentId);
  }
}