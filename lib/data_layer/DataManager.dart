import 'package:client_safe/data_layer/sms/SmsManager.dart';

class DataManager{
  static final DataManager _instance = DataManager._internal();
  factory DataManager() => _instance;
  final SmsManager smsManager = SmsManager();

  DataManager._internal();

  void syncSmsWithDevice(){
//    smsManager.
  }
}