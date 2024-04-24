import '../models/Profile.dart';

class AdminCheckUtil {
  static const List<String> ADMIN_EMAILS = [
    'jbinvestments15@gmail.com',
    'shawnabrannen@mailinator.com',
    'dandylighttest@mailinator.com',
    'plopshot@mailinator.com',
    'dandylightprod@mailinator.com',
    'dandylightdev@mailinator.com',
    'jpshots@mailinator.com',
    'dandylightprod@mailinator.com',
    'dandylightdemo@mailinator.com',
    'dandylightprodtest2@mailinator.com',
    'vintagevibesphotography@gmail.com',
    'dandylightadmin@mailinator.com'
  ];

  static bool isAdmin(Profile? profile) {
    String email = profile!.email != null ? profile.email! : '';
    print(email);
    print(ADMIN_EMAILS.contains(email.toLowerCase()));
    return ADMIN_EMAILS.contains(email.toLowerCase());
  }
}