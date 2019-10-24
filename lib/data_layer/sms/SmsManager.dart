import 'package:sms/sms.dart';

class SmsManager {
  void startListeningForSms(){
    SmsReceiver smsReceiver = SmsReceiver();
    smsReceiver.onSmsReceived;
  }

  void fetchAllSMSForPhoneNumber(String phoneNum){
    SmsQuery query = new SmsQuery();
  }
}