import 'package:dandylight/data_layer/local_db/daos/PendingEmailsDao.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/models/PendingEmail.dart';
import 'package:dandylight/utils/NotificationHelper.dart';
import 'package:dandylight/utils/UidUtil.dart';
import '../../models/Profile.dart';
import '../../models/Progress.dart';
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
        emailType: PendingEmail.TYPE_TRIAL_LIMIT_REACHED,
        toAddress: sendToEmail,
        uid: uid,
        photographerName: profile?.firstName ?? '',
      );
      _sendEmailToUserNow(pendingEmail);
    }
  }

  void sendVerificationHelpEmail() async {
    String uid = UidUtil().getUid();
    Profile? profile = await ProfileDao.getMatchingProfile(uid);
    String sendToEmail = profile?.email ?? '';

    if(sendToEmail.isNotEmpty) {
      PendingEmail pendingEmail = PendingEmail(
        sendDate: DateTime.now(),
        emailType: PendingEmail.TYPE_EMAIL_VERIFICATION_HELP,
        toAddress: sendToEmail,
        uid: uid,
        photographerName: profile?.firstName ?? '',
      );
      _sendEmailToUserNow(pendingEmail);
    }
  }

  void sendNextStageEmail(Progress progress) async {
    Profile? profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    String? typeToSend = PendingEmail.getNextUncompletedType(progress);

    if(profile != null && profile.progress.canShow == true && (profile.email?.isNotEmpty ?? false)) {
      if (typeToSend != null && (profile.progress.canSend(typeToSend ?? ''))) {
        DateTime sendDate = DateTime.now();
        sendDate = sendDate.add(const Duration(days: 3));
        String uid = UidUtil().getUid();
        PendingEmail pendingEmail = PendingEmail(
          sendDate: sendDate,
          emailType: typeToSend,
          toAddress: profile.email!,
          uid: uid,
          photographerName: profile.firstName ?? '',
        );
        await PendingEmailDao.delete(uid, typeToSend);
        _sendEmailToUserScheduled(pendingEmail);
        NotificationHelper().scheduleNextTaskNotification(typeToSend, sendDate);
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
          emailType: PendingEmail.TYPE_ACCOUNT_CREATED_1,
          toAddress: sendToEmail,
          uid: uid,
          photographerName: profile?.firstName ?? '',
      );
      _sendEmailToUserNow(pendingEmail1);
    }

    if(sendToEmail.isNotEmpty) {
      DateTime sendDate2 = DateTime.now();
      sendDate2 = sendDate2.add(const Duration(days: 2));
      PendingEmail pendingEmail2 = PendingEmail(
          sendDate: sendDate2,
          emailType: PendingEmail.TYPE_ACCOUNT_CREATED_2,
          toAddress: sendToEmail,
          uid: uid,
          photographerName: profile?.firstName ?? '',
      );
      _sendEmailToUserScheduled(pendingEmail2);
    }

    if(sendToEmail.isNotEmpty) {
      DateTime sendDate3 = DateTime.now();
      sendDate3 = sendDate3.add(const Duration(days: 5));
      PendingEmail pendingEmail3 = PendingEmail(
          sendDate: sendDate3,
          emailType: PendingEmail.TYPE_ACCOUNT_CREATED_3,
          toAddress: sendToEmail,
          uid: uid,
          photographerName: profile?.firstName ?? '',
      );
      _sendEmailToUserScheduled(pendingEmail3);
    }

    if(sendToEmail.isNotEmpty) {
      DateTime sendDate4 = DateTime.now();
      sendDate4 = sendDate4.add(const Duration(days: 14));
      PendingEmail pendingEmail3 = PendingEmail(
        sendDate: sendDate4,
        emailType: PendingEmail.TYPE_ACCOUNT_CREATED_4,
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
    return await PendingEmailDao.insertOrUpdate(pendingEmail);
  }
}