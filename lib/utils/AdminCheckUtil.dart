import '../models/Profile.dart';

class AdminCheckUtil {
  static const List<String> ADMIN_EMAILS = ['jbinvestments15@gmail.com', 'shawnabrannen@mailinator.com', 'dandylighttest@mailinator.com', 'plopshot@mailinator.com', 'dandylightprod@mailinator.com', 'dandylightdev@mailinator.com', 'jpshots@mailinator.com'];

  static bool isAdmin(Profile profile) {
    String email = profile.email != null ? profile.email : '';
    return ADMIN_EMAILS.contains(email.toLowerCase());
  }
}