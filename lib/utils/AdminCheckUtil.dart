import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';

import '../models/Profile.dart';

class AdminCheckUtil {
  static const List<String> ADMIN_EMAILS = ['jbinvestments15@gmail.com', 'shawnabrannen@mailinator.com', 'dandylighttest@mailinator.com'];

  static bool isAdmin(Profile profile) {
    return ADMIN_EMAILS.contains(profile.email);
  }
}