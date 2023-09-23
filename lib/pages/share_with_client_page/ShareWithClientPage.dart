
import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/pages/share_with_client_page/ShareWithClientActions.dart';

import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../models/Job.dart';
import '../../widgets/DandyLightTextField.dart';
import '../../widgets/TextDandyLight.dart';
import 'ShareWithClientPageState.dart';

class ShareWithClientPage extends StatefulWidget {
  final Job job;
  ShareWithClientPage({this.job});

  @override
  State<StatefulWidget> createState() {
    return _ShareWithClientPageState(job);
  }
}

class _ShareWithClientPageState extends State<ShareWithClientPage> with TickerProviderStateMixin {
  final Job job;
  final messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();

  _ShareWithClientPageState(this.job);

  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, ShareWithClientPageState>(
        onInit: (store) async {
          await store.dispatch(FetchProfileAction(store.state.shareWithClientPageState));
          store.dispatch(SetJobShareWithClientAction(store.state.shareWithClientPageState, job));
          messageController.value = messageController.value.copyWith(text:(await ProfileDao.getMatchingProfile(UidUtil().getUid())).clientMessage);
        },
        converter: (Store<AppState> store) => ShareWithClientPageState.fromStore(store),
        builder: (BuildContext context, ShareWithClientPageState pageState) => Scaffold(
          backgroundColor: Color(ColorConstants.getPrimaryWhite()),
          body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                iconTheme: IconThemeData(color: Color(ColorConstants.getPrimaryBlack())),
                brightness: Brightness.light,
                backgroundColor: Color(ColorConstants.getPrimaryWhite()),
                pinned: true,
                centerTitle: true,
                title: TextDandyLight(
                  type: TextDandyLight.LARGE_TEXT,
                  text: "Share With Client",
                  color: Color(ColorConstants.getPrimaryBlack()),
                ),
                actions: <Widget>[
                  GestureDetector(
                    onTap: () {
                      NavigationUtil.onEditBrandingSelected(context);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(right: 18.0, left: 2.0),
                      height: 28.0,
                      width: 28.0,
                      child: Image.asset('assets/images/icons/art.png'),
                    ),
                  ),
                ],
              ),
              SliverList(
                delegate: new SliverChildListDelegate(
                  <Widget>[
                    Container(
                      alignment: Alignment.center,
                      child: GestureDetector(
                          onTap: () {
                            NavigationUtil.onEditBrandingSelected(context);
                          },
                          child: Container(
                            width: 264,
                            height: 54,
                            margin: EdgeInsets.only(top: 16, bottom: 8),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Color(ColorConstants.getPeachDark()),
                              borderRadius: BorderRadius.circular(27),
                            ),
                            child: TextDandyLight(
                              type: TextDandyLight.LARGE_TEXT,
                              text: 'Setup Branding',
                              color: Color(ColorConstants.getPrimaryWhite()),
                            ),
                          ),
                        ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 64, right: 64),
                      child: TextDandyLight(
                        type: TextDandyLight.SMALL_TEXT,
                        textAlign: TextAlign.center,
                        text: 'Branding will be used to customize your client portal.',
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 32, bottom: 4),
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: TextDandyLight(
                        type: TextDandyLight.MEDIUM_TEXT,
                        textAlign: TextAlign.center,
                        text: 'Message to Client',
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                    ),
                    Container(
                      height: 350,
                      margin: EdgeInsets.only(left: 16, right: 16),
                      child: Container(
                        margin: EdgeInsets.only(left: 20.0, right: 20.0),
                        child: DandyLightTextField(
                          messageController,
                          "",
                          TextInputType.text,
                          200.0,
                          pageState.onMessageChanged,
                          'noError',
                          TextInputAction.done,
                          _messageFocusNode,
                          onAction,
                          TextCapitalization.sentences,
                          null,
                          true,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  void onAction(){
    _messageFocusNode.unfocus();
  }
}
