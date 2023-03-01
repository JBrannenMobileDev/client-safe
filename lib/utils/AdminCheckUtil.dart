import '../models/Profile.dart';

class AdminCheckUtil {
  static const List<String> ADMIN_EMAILS = ['jbinvestments15@gmail.com', 'Shawnabrannen@mailinator.com', 'dandylighttest@mailinator.com', 'plopshot@mailinator.com', 'dandylightprod@mailinator.com'];

  static bool isAdmin(Profile profile) {
    return ADMIN_EMAILS.contains(profile.email);
  }
}