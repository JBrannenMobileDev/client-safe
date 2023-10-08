
import 'package:dandylight/pages/client_details_page/ClientDetailsPage.dart';
import 'package:dandylight/pages/common_widgets/ClientSafeButton.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/DandyToastUtil.dart';
import 'package:dandylight/utils/intentLauncher/IntentLauncherUtil.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../../widgets/TextDandyLight.dart';
import '../client_details_page/SelectSavedResponseBottomSheet.dart';
import '../client_details_page/SendMessageOptionsBottomSheet.dart';

class ClientDetailsCard extends StatelessWidget {
  ClientDetailsCard({this.pageState});

  final JobDetailsPageState pageState;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 26.0),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Container(
            height: 224.0,
          ),
          Container(
            height: 240.0,
            width: double.maxFinite,
            margin: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
            decoration: new BoxDecoration(
                color: Color(ColorConstants.getPrimaryWhite()),
                borderRadius: new BorderRadius.all(Radius.circular(24.0))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(26.0, 16.0, 26.0, 16.0),
                  child: TextDandyLight(
                    type: TextDandyLight.LARGE_TEXT,
                    text: pageState.client?.getClientFullName(),
                    textAlign: TextAlign.center,
                    color: Color(ColorConstants.getPrimaryBlack()),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton(
                      style: Styles.getButtonStyle(),
                      onPressed: () {
                        pageState.onClientClicked(pageState.client);
                        Navigator.of(context).push(new MaterialPageRoute(builder: (context) => ClientDetailsPage()));
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 16.0),
                        height: 96.0,
                        width: MediaQuery.of(context).size.width / 3,
                        child: Image.asset('assets/images/icons/profile_icon.png', color: Color(ColorConstants.getPrimaryColor()),),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    GestureDetector(
                        onTap: () {
                          if(pageState.client.phone != null && pageState.client.phone.length > 0){
                            onCallPressed(pageState.client.phone);
                          }else{
                            DandyToastUtil.showErrorToast('No phone number saved yet');
                          }
                        },
                        child: Container(
                          height: 42.0,
                          width: 42.0,
                          child: Image.asset('assets/images/icons/phonecall_icon_peach.png'),
                        ),
                    ),
                    GestureDetector(
                        onTap: () {
                          if(pageState.client.phone != null && pageState.client.phone.length > 0){
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              barrierColor: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
                              builder: (context) {
                                return SendMessageOptionsBottomSheet(SelectSavedResponseBottomSheet.TYPE_SMS, pageState.client.phone);
                              },
                            );
                          }else{
                            DandyToastUtil.showErrorToast('No phone number saved yet');
                          }
                        },
                        child: Container(
                          height: 42.0,
                          width: 42.0,
                          child: Image.asset('assets/images/icons/sms_icon_peach.png'),
                        ),
                    ),
                    GestureDetector(
                        onTap: () {
                          if(pageState.client.email != null && pageState.client.email.length > 0){
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              barrierColor: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
                              builder: (context) {
                                return SendMessageOptionsBottomSheet(SelectSavedResponseBottomSheet.TYPE_EMAIL, pageState.client.email);
                              },
                            );
                          }else{
                            DandyToastUtil.showErrorToast('No email saved yet');
                          }
                        },
                        child: Container(
                          height: 42.0,
                          width: 42.0,
                          child: Image.asset('assets/images/icons/email_icon_peach.png'),
                        ),
                    ),
                    GestureDetector(
                        onTap: () {
                          if(pageState.client.instagramProfileUrl != null && pageState.client.instagramProfileUrl.length > 0){
                            pageState.onInstagramSelected();
                          }else{
                            DandyToastUtil.showErrorToast('No Instagram URL saved yet');
                          }
                        },
                        child: Container(
                          height: 42.0,
                          width: 42.0,
                          child: Image.asset('assets/images/icons/instagram_icon_peach.png'),
                        ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void onCallPressed(String phoneNum){
    if(phoneNum.isNotEmpty) IntentLauncherUtil.makePhoneCall(phoneNum);
  }

  void onEmailPressed(String email){
    if(email.isNotEmpty) IntentLauncherUtil.sendEmail(email, "", "");
  }
}
