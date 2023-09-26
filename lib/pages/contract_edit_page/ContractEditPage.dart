import 'dart:ui';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/main_settings_page/MainSettingsPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/Contract.dart';
import '../../navigation/routes/RouteNames.dart';
import '../../utils/Shadows.dart';
import '../../utils/styles/Styles.dart';
import '../../widgets/TextDandyLight.dart';
import 'ContractEditPageState.dart';

class ContractEditPage extends StatefulWidget {
  final Contract contract;

  ContractEditPage({this.contract});

  @override
  State<StatefulWidget> createState() {
    return _ContractEditPageState(contract);
  }
}

class _ContractEditPageState extends State<ContractEditPage> with TickerProviderStateMixin {
  final Contract contract;

  _ContractEditPageState(this.contract);

  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, ContractEditPageState>(
        onInit: (store) {
          // if(contract != null) store.dispatch(SetContractAction(store.state.contractEditPageState, contract));
        },
        converter: (Store<AppState> store) => ContractEditPageState.fromStore(store),
        builder: (BuildContext context, ContractEditPageState pageState) => WillPopScope(
            onWillPop: () async {
              bool willLeave = false;
              if(pageState.hasUnsavedChanges) {
                await showDialog(
                    context: context,
                    builder: (_) => Device.get().isIos ?
                    CupertinoAlertDialog(
                      title: new Text('Exit without saving changes?'),
                      content: new Text('If you continue any changes made will not be saved.'),
                      actions: <Widget>[
                        TextButton(
                          style: Styles.getButtonStyle(),
                          onPressed: () {
                            willLeave = true;
                            Navigator.of(context).pop();
                          },
                          child: new Text('Yes'),
                        ),
                        TextButton(
                          style: Styles.getButtonStyle(),
                          onPressed: () => Navigator.of(context).pop(false),
                          child: new Text('No'),
                        ),
                      ],
                    ) : AlertDialog(
                      title: new Text('Exit without saving changes?'),
                      content: new Text('If you continue any changes made will not be saved.'),
                      actions: <Widget>[
                        TextButton(
                          style: Styles.getButtonStyle(),
                          onPressed: () {
                            willLeave = true;
                            Navigator.of(context).pop();
                          },
                          child: new Text('Yes'),
                        ),
                        TextButton(
                          style: Styles.getButtonStyle(),
                          onPressed: () => Navigator.of(context).pop(false),
                          child: new Text('No'),
                        ),
                      ],
                    ));
              } else {
                willLeave = true;
              }
              return willLeave;
            },
            child: Scaffold(
              backgroundColor: Color(ColorConstants.getPrimaryBackgroundGrey()),
              body: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Color(ColorConstants.getPrimaryBackgroundGrey()),
                    ),
                    child: CustomScrollView(
                      slivers: <Widget>[
                        SliverAppBar(
                            iconTheme: IconThemeData(
                              color: Color(ColorConstants.getPrimaryBlack()), //change your color here
                            ),
                            backgroundColor: Color(ColorConstants.getPrimaryBackgroundGrey()),
                            pinned: true,
                            centerTitle: true,
                            elevation: 2.0,
                            title: TextDandyLight(
                              type: TextDandyLight.LARGE_TEXT,
                              text: contract != null ? "Edit Contract" : "New Contract",
                              color: Color(ColorConstants.getPrimaryBlack()),
                            ),
                        ),
                        SliverList(
                          delegate: new SliverChildListDelegate(
                            <Widget>[
                              Container(
                                margin: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16)
                                ),
                                child: SizedBox(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  pageState.hasUnsavedChanges ? Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    alignment: Alignment.bottomCenter,
                    padding: EdgeInsets.only(bottom: 96),
                    child: GestureDetector(
                      onTap: () {
                        showSuccessAnimation();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 54,
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(left: 32, right: 32),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          color: Color(ColorConstants.getPeachDark()),
                          boxShadow: ElevationToShadow[4],
                        ),
                        child: TextDandyLight(
                          type: TextDandyLight.LARGE_TEXT,
                          text: 'Save Changes',
                          textAlign: TextAlign.center,
                          color: Color(ColorConstants.getPrimaryWhite()),
                        ),
                      ),
                    ),
                  ) : SizedBox(),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    alignment: Alignment.bottomCenter,
                    padding: EdgeInsets.only(bottom: 32),
                    child: GestureDetector(
                      onTap: () {
                        _launchContractPreviewURL(UidUtil().getUid());
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 54,
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(left: 32, right: 32),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          color: Color(ColorConstants.getPeachDark()),
                          boxShadow: ElevationToShadow[4],
                        ),
                        child: TextDandyLight(
                          type: TextDandyLight.LARGE_TEXT,
                          text: 'Preview',
                          textAlign: TextAlign.center,
                          color: Color(ColorConstants.getPrimaryWhite()),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ),
      );

  void showSuccessAnimation(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.all(96.0),
          child: FlareActor(
            "assets/animations/success_check.flr",
            alignment: Alignment.center,
            fit: BoxFit.contain,
            animation: "show_check",
            callback: onFlareCompleted,
          ),
        );
      },
    );
  }

  void onFlareCompleted(String unused) {
    Navigator.of(context).pop(true);
    Navigator.of(context).pop(true);
  }

  void _launchContractPreviewURL(String uid) async => await canLaunchUrl(Uri.parse('https://dandylight.com/' + RouteNames.BRANDING_PREVIEW + '/' + uid)) ? await launchUrl(Uri.parse('https://dandylight.com/' + RouteNames.BRANDING_PREVIEW + '/' + uid), mode: LaunchMode.platformDefault) : throw 'Could not launch';
}
