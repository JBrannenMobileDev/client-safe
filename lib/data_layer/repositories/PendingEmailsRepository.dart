import 'package:dandylight/models/PendingEmail.dart';
import '../api_clients/DandylightFunctionsClient.dart';

class PendingEmailsRepository {
  final DandylightFunctionsApi functions;

  PendingEmailsRepository({required this.functions});

  Future sendEmailToUserNow(PendingEmail pendingEmail) async {
    return await functions.sendEmailToUserNow(pendingEmail);
  }

  Future sendEmailToUserScheduled(PendingEmail pendingEmail) async {
    return await functions.sendEmailToUserScheduled(pendingEmail);
  }
}