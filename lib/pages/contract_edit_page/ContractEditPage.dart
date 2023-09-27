import 'dart:convert';
import 'dart:ui';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../models/Contract.dart';
import '../../utils/ImageUtil.dart';
import '../../utils/Shadows.dart';
import '../../utils/styles/Styles.dart';
import '../../widgets/TextDandyLight.dart';
import 'ContractEditActions.dart';
import 'ContractEditPageState.dart';

class ContractEditPage extends StatefulWidget {
  final Contract contract;
  final String contractName;
  final bool isNew;

  ContractEditPage({this.contract, this.contractName, this.isNew});

  @override
  State<StatefulWidget> createState() {
    return _ContractEditPageState(contract, contractName, isNew);
  }
}

class _ContractEditPageState extends State<ContractEditPage> with TickerProviderStateMixin {
  quill.QuillController _controller;
  final FocusNode titleFocusNode = FocusNode();
  final FocusNode contractFocusNode = FocusNode();
  final TextEditingController controllerTitle = TextEditingController();
  final Contract contract;
  final String contractName;
  final bool isNew;
  bool hasUnsavedChanges = true;

  _ContractEditPageState(this.contract, this.contractName, this.isNew);


  @override
  void initState() {
    _controller = contract != null ? quill.QuillController(
      document: quill.Document.fromJson(jsonDecode(contract.jsonTerms)),
        selection: TextSelection.collapsed(offset: 0)
    ) : quill.QuillController.basic();
    super.initState();
  }

  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, ContractEditPageState>(
        onInit: (store) {
          store.dispatch(ClearContractEditState(store.state.contractEditPageState));
          if(contract != null) {
            store.dispatch(SetContractAction(store.state.contractEditPageState, contract));
          }
          store.dispatch(SetContractNameAction(store.state.contractEditPageState, contractName));
        },
        converter: (Store<AppState> store) => ContractEditPageState.fromStore(store),
        builder: (BuildContext context, ContractEditPageState pageState) => WillPopScope(
            onWillPop: () async {
              bool willLeave = false;
              if(hasUnsavedChanges) {
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
              };
              return willLeave;
            },
            child: Scaffold(
              backgroundColor: Color(ColorConstants.getPrimaryWhite()),
              body: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Color(ColorConstants.getPrimaryWhite()),
                    ),
                    child: CustomScrollView(
                      slivers: <Widget>[
                        SliverAppBar(
                            iconTheme: IconThemeData(
                              color: Color(ColorConstants.getPrimaryBlack()), //change your color here
                            ),
                            backgroundColor: Color(ColorConstants.getPrimaryWhite()),
                          actions: <Widget>[
                            !isNew ? IconButton(
                              icon: ImageIcon(ImageUtil.getTrashIconWhite(), color: Color(ColorConstants.getPeachDark()),),
                              tooltip: 'Delete Job',
                              onPressed: () {
                                _ackAlert(context, pageState);
                              },
                            ) : SizedBox(),
                          ],
                            pinned: true,
                            centerTitle: true,
                            elevation: 0.0,
                            title: Container(
                              width: 250,
                            child: TextFormField(
                                focusNode: titleFocusNode,
                                initialValue: contract != null ? contract.contractName : contractName,
                                enabled: true,
                                cursorColor: Color(ColorConstants.getPrimaryBlack()),
                                onChanged: (text) {
                                  setState(() {});
                                  pageState.onNameChanged(text);
                                },
                                decoration: InputDecoration(
                                  alignLabelWithHint: true,
                                  labelStyle: TextStyle(
                                      fontSize: TextDandyLight.getFontSize(TextDandyLight.MEDIUM_TEXT),
                                      fontFamily: TextDandyLight.getFontFamily(),
                                      fontWeight: TextDandyLight.getFontWeight(),
                                      color: Color(ColorConstants.getPrimaryBlack())
                                  ),
                                  hintText: 'Contract Name',
                                  fillColor: Colors.white,
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(ColorConstants.getPrimaryBlack()),
                                        width: 4.0,
                                      )),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(ColorConstants.getPrimaryBlack()),
                                      width: 4.0,
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.all(16),
                                  isDense: true,
                                ),
                                keyboardType: TextInputType.name,
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: TextDandyLight.getFontSize(TextDandyLight.MEDIUM_TEXT),
                                    fontFamily: TextDandyLight.getFontFamily(),
                                    fontWeight: TextDandyLight.getFontWeight(),
                                    color: Color(ColorConstants.getPrimaryBlack()))
                            ),
                          ),
                        ),
                        SliverList(
                          delegate: new SliverChildListDelegate(
                            <Widget>[
                              Container(
                                color: Color(ColorConstants.getPrimaryWhite()),
                                margin: EdgeInsets.only(left: 16, right: 16, top: 96),
                                child: getEditor(),
                              ),
                              Container(
                                height: 164,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    alignment: Alignment.bottomCenter,
                    padding: EdgeInsets.only(bottom: 32),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          hasUnsavedChanges = false;
                        });
                        pageState.onContractSaved(_controller.document);
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
                          text: 'Save Contract',
                          textAlign: TextAlign.center,
                          color: Color(ColorConstants.getPrimaryWhite()),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    color: Color(ColorConstants.getPrimaryWhite()),
                    margin: EdgeInsets.only(top: 114),
                    padding: EdgeInsets.only(bottom: 4, top: 18),
                    child: quill.QuillToolbar.basic(
                      controller: _controller,
                      showUndo: false,
                      showRedo: false,
                      showClearFormat: false,
                      showCodeBlock: false,
                      showIndent: false,
                      showDirection: false,
                      showInlineCode: false,
                      showQuote: false,
                      showSmallButton: false,
                      showSubscript: false,
                      showSuperscript: false,
                      showLink: false,
                    ),
                  )
                ],
              ),
            ),
        ),
      );

  Widget getEditor() {
    return quill.QuillEditor(
      controller: _controller,
      scrollable: true,
      scrollController: ScrollController(),
      focusNode: contractFocusNode,
      padding: EdgeInsets.all(0),
      autoFocus: true,
      readOnly: false,
      expands: false,
      placeholder: "Past contract terms here",
    );
  }

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

  Future<void> _ackAlert(BuildContext context, ContractEditPageState pageState) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Device.get().isIos ?
        CupertinoAlertDialog(
          title: new Text('Are you sure?'),
          content: new Text('All data for this job will be permanently deleted!'),
          actions: <Widget>[
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text('No'),
            ),
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () {
                pageState.onDeleteSelected();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: new Text('Yes'),
            ),
          ],
        ) : AlertDialog(
          title: new Text('Are you sure?'),
          content: new Text('All data for this job will be permanently deleted!'),
          actions: <Widget>[
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text('No'),
            ),
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () {
                pageState.onDeleteSelected();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: new Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
