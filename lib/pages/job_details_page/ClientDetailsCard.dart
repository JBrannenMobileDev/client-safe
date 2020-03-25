
import 'package:client_safe/pages/client_details_page/ClientDetailsPage.dart';
import 'package:client_safe/pages/common_widgets/ClientSafeButton.dart';
import 'package:client_safe/pages/job_details_page/JobDetailsPageState.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/IntentLauncherUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class ClientDetailsCard extends StatelessWidget {
  ClientDetailsCard({this.pageState});

  final JobDetailsPageState pageState;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(ColorConstants.getPrimaryBackgroundGrey()),
      padding: EdgeInsets.only(top: 26.0),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Container(
            height: 236.0,
          ),
          Container(
            height: 236.0,
            width: double.maxFinite,
            margin: EdgeInsets.fromLTRB(26.0, 0.0, 26.0, 0.0),
            decoration: new BoxDecoration(
                color: Color(ColorConstants.getPrimaryWhite()),
                borderRadius: new BorderRadius.all(Radius.circular(8.0))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(26.0, 16.0, 26.0, 0.0),
                  child: Text(
                    pageState.client?.getClientFullName(),
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 24.0,
                      fontFamily: 'Blackjack',
                      fontWeight: FontWeight.w800,
                      color: Color(ColorConstants.primary_black),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        pageState.onClientClicked(pageState.client);
                        Navigator.of(context).push(new MaterialPageRoute(builder: (context) => ClientDetailsPage()));
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 16.0),
                        height: 96.0,
                        width: MediaQuery.of(context).size.width / 3,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                pageState.client?.iconUrl ?? ""),
                            fit: BoxFit.contain,
                          ),
                          borderRadius:
                          BorderRadius.all(Radius.circular(8.0)),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ClientSafeButton(
                      height: 48.0,
                      width: 65.0,
                      text: "",
                      marginLeft: 16.0,
                      marginTop: 0.0,
                      marginRight: 4.0,
                      marginBottom: 0.0,
                      onPressed: onCallPressed,
                      icon: Icon(Icons.phone, color: Colors.white),
                      urlText: pageState.client?.phone,
                    ),
                    ClientSafeButton(
                      height: 48.0,
                      width: 65.0,
                      text: "",
                      marginLeft: 4.0,
                      marginTop: 0.0,
                      marginRight: 4.0,
                      marginBottom: 0.0,
                      onPressed: onSMSPressed,
                      icon: Icon(Icons.message, color: Colors.white),
                      urlText: pageState.client?.phone,
                    ),
                    ClientSafeButton(
                      height: 48.0,
                      width: 65.0,
                      text: "",
                      marginLeft: 4.0,
                      marginTop: 0.0,
                      marginRight: 4.0,
                      marginBottom: 0.0,
                      onPressed: onEmailPressed,
                      icon: Icon(Icons.email, color: Colors.white),
                      urlText: pageState.client?.email,
                    ),
                    Container(
                      alignment: Alignment.bottomCenter,
                      margin: EdgeInsets.only(left: 4.0, right: 16.0),
                      child: SizedBox(
                        width: 65.0,
                        height: 48.0,
                        child: FlatButton(
                          padding: EdgeInsets.all(0.0),
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(8.0),
                              side: BorderSide(color: Color(ColorConstants.getPrimaryColor()))),
                          onPressed: () {
                            pageState.onInstagramSelected();
                          },
                          color: Color(ColorConstants.getPrimaryColor()),
                          child: Container(
                            height: 32.0,
                            width: 65.0,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/images/instagram_logo_icon.png"),
                                fit: BoxFit.contain,
                              ),
                              borderRadius:
                              BorderRadius.all(Radius.circular(8.0)),
                            ),
                          ),
                        ),
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

  void onSMSPressed(String sms){
    if(sms.isNotEmpty) IntentLauncherUtil.sendSMS(sms);
  }
}
