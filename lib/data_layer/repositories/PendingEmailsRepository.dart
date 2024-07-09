import 'package:dandylight/data_layer/local_db/daos/PendingEmailsDao.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/models/PendingEmail.dart';
import 'package:dandylight/utils/UidUtil.dart';
import '../../models/Profile.dart';
import '../api_clients/DandylightFunctionsClient.dart';

class PendingEmailsRepository {
  final DandylightFunctionsApi functions;

  PendingEmailsRepository({required this.functions});

  void sendTrialLimitReachedEmail() async {
    String uid = UidUtil().getUid();
    Profile? profile = await ProfileDao.getMatchingProfile(uid);
    String sendToEmail = profile?.email ?? '';

    if(sendToEmail.isNotEmpty) {
      PendingEmail pendingEmail = PendingEmail(
        sendDate: DateTime.now(),
        type: PendingEmail.TYPE_TRIAL_LIMIT_REACHED,
        toAddress: sendToEmail,
        uid: uid,
        photographerName: profile?.firstName ?? '',
      );
      _sendEmailToUserNow(pendingEmail);
    }
  }

  void sendNextStageEmail() async {
    String uid = UidUtil().getUid();
    Profile? profile = await ProfileDao.getMatchingProfile(uid);
    PendingEmail? previousEmail = await PendingEmailDao.getPreviousStageEmailByUid(uid);

    if(previousEmail != null && profile != null) {
      String? nextType = PendingEmail.getNextUncompletedType(profile.progress);
      if(nextType != null) {
        DateTime newSendDate = DateTime.now();
        newSendDate.add(const Duration(days: 3));
        previousEmail.sendDate = newSendDate;
        previousEmail.type = nextType;
        PendingEmailDao.update(previousEmail);
      }
    } else if(previousEmail == null && profile != null && profile.email != null) {
      String? nextType = PendingEmail.getNextUncompletedType(profile.progress);
      if(nextType != null) {
        DateTime sendDate = DateTime.now();
        sendDate.add(const Duration(days: 3));
        PendingEmail pendingEmail = PendingEmail(
          sendDate: sendDate,
          type: nextType,
          toAddress: profile.email!,
          uid: uid,
          photographerName: profile.firstName ?? '',
        );
        _sendEmailToUserScheduled(pendingEmail);
      }
    }
  }

  void sendAccountCreatedEmails() async {
    String uid = UidUtil().getUid();
    Profile? profile = await ProfileDao.getMatchingProfile(uid);
    String sendToEmail = profile?.email ?? '';

    if(sendToEmail.isNotEmpty) {
      PendingEmail pendingEmail1 = PendingEmail(
          sendDate: DateTime.now(),
          type: PendingEmail.TYPE_ACCOUNT_CREATED_1,
          toAddress: sendToEmail,
          uid: uid,
          photographerName: profile?.firstName ?? '',
      );
      _sendEmailToUserNow(pendingEmail1);
    }

    if(sendToEmail.isNotEmpty) {
      DateTime sendDate2 = DateTime.now();
      sendDate2.add(const Duration(days: 2));
      PendingEmail pendingEmail2 = PendingEmail(
          sendDate: sendDate2,
          type: PendingEmail.TYPE_ACCOUNT_CREATED_2,
          toAddress: sendToEmail,
          uid: uid,
          photographerName: profile?.firstName ?? '',
      );
      _sendEmailToUserScheduled(pendingEmail2);
    }

    if(sendToEmail.isNotEmpty) {
      DateTime sendDate3 = DateTime.now();
      sendDate3.add(const Duration(days: 5));
      PendingEmail pendingEmail3 = PendingEmail(
          sendDate: sendDate3,
          type: PendingEmail.TYPE_ACCOUNT_CREATED_3,
          toAddress: sendToEmail,
          uid: uid,
          photographerName: profile?.firstName ?? '',
      );
      _sendEmailToUserScheduled(pendingEmail3);
    }
  }

  Future _sendEmailToUserNow(PendingEmail pendingEmail) async {
    return await functions.sendEmailToUserNow(pendingEmail);
  }

  Future _sendEmailToUserScheduled(PendingEmail pendingEmail) async {
    return await PendingEmailDao.insert(pendingEmail);
  }
}