import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/contract_edit_page/InsertJobDetailBottomSheet.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';

import '../../models/Contract.dart';
import '../../models/FontTheme.dart';
import '../../utils/ImageUtil.dart';
import '../../utils/InputDoneView.dart';
import '../../utils/styles/Styles.dart';
import '../../widgets/TextDandyLight.dart';
import 'ContractEditActions.dart';
import 'ContractEditPageState.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class ContractEditPage extends StatefulWidget {
  final Contract? contract;
  final String? contractName;
  final bool? isNew;
  final String? jobDocumentId;
  final Function(BuildContext)? deleteFromJob;

  ContractEditPage({this.contract, this.contractName, this.isNew, this.jobDocumentId, this.deleteFromJob});

  @override
  State<StatefulWidget> createState() {
    return _ContractEditPageState(contract, contractName, isNew, jobDocumentId, deleteFromJob);
  }
}

class _ContractEditPageState extends State<ContractEditPage> with TickerProviderStateMixin {
  TextEditingController _clientSignatureController = TextEditingController(text: "Photographer Name");
  TextEditingController _photogSigController = TextEditingController();
  quill.QuillController? _controller;
  final FocusNode titleFocusNode = FocusNode();
  final FocusNode contractFocusNode = FocusNode();
  final TextEditingController controllerTitle = TextEditingController();
  final Contract? contract;
  final String? contractName;
  final bool? isNew;
  final String? jobDocumentId;
  final Function(BuildContext)? deleteFromJob;
  bool hasUnsavedChanges = true;
  OverlayEntry? overlayEntry;
  bool isKeyboardVisible = false;
  bool isFabExpanded = false;
  late StreamSubscription<bool> keyboardSubscription;

  _ContractEditPageState(this.contract, this.contractName, this.isNew, this.jobDocumentId, this.deleteFromJob);


  @override
  void initState() {
    super.initState();

    _controller = contract != null ? quill.QuillController(
      document: quill.Document.fromJson(jsonDecode(contract!.jsonTerms!)),
        selection: TextSelection.collapsed(offset: 0)
    ) : quill.QuillController.basic();

    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardSubscription = keyboardVisibilityController.onChange.listen((bool visible) {
      setState(() {
        if(visible) {
          showOverlay(context);
          isKeyboardVisible = true;
        } else {
          removeOverlay();
          isKeyboardVisible = false;
        }
      });
    });
  }

  @override
  void dispose() {
    keyboardSubscription.cancel();
    super.dispose();
  }

  getFabIcon() {
    if(isFabExpanded){
      return Icon(Icons.close, color: Color(ColorConstants.getPrimaryWhite()));
    }else{
      return Icon(Icons.add, color: Color(ColorConstants.getPrimaryWhite()));
    }
  }

  Future<void> _ackSaveChangesAlert(BuildContext context, ContractEditPageState pageState) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Device.get().isIos ?
        CupertinoAlertDialog(
          title: new Text('Are you sure?'),
          content: new Text('This contract is already signed by your client. Changing this contract will remove the client signature and you will have to request the client to sign this contract again.'),
          actions: <Widget>[
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text('No'),
            ),
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () {
                pageState.onContractSaved!(_controller!.document, jobDocumentId!);
                Navigator.of(context).pop(true);
                showSuccessAnimation();
              },
              child: new Text('Yes'),
            ),
          ],
        ) : AlertDialog(
          title: new Text('Are you sure?'),
          content: new Text('This contract is already signed by your client. Changing this contract will remove the client signature and you will have to request the client to sign this contract again.'),
          actions: <Widget>[
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text('No'),
            ),
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () {
                pageState.onContractSaved!(_controller!.document, jobDocumentId!);
                Navigator.of(context).pop(true);
                showSuccessAnimation();
              },
              child: new Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _showInsertSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
      builder: (context) {
        return InsertJobDetailBottomSheet(_controller!);
      },
    );
  }

  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, ContractEditPageState>(
        onInit: (store) {
          store.dispatch(ClearContractEditState(store.state.contractEditPageState, isNew, contractName));
          if(contract != null) {
            store.dispatch(SetContractAction(store.state.contractEditPageState, contract));
          }
          store.dispatch(SetContractNameAction(store.state.contractEditPageState, contractName));
          store.dispatch(FetchProfileForContractEditAction(store.state.contractEditPageState));
        },
        onDidChange: (prev, current) {
          _photogSigController.text = current.profile != null ? (current.profile!.firstName! + ' ' +
              current.profile!.lastName!) : 'Photographer Name';
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
              appBar: AppBar(
                surfaceTintColor: Colors.transparent,
                iconTheme: IconThemeData(
                  color: Color(ColorConstants.getPrimaryBlack()), //change your color here
                ),
                backgroundColor: Color(ColorConstants.getPrimaryWhite()),
                actions: <Widget>[
                  !isNew! ? IconButton(
                    icon: ImageIcon(ImageUtil.getTrashIconWhite(), color: Color(ColorConstants.getPeachDark()),),
                    tooltip: 'Delete Job',
                    onPressed: () {
                      if(jobDocumentId != null && jobDocumentId!.isNotEmpty) {
                        deleteFromJob!(context);
                      }else {
                        _ackDeleteAlert(context, pageState);
                      }
                    },
                  ) : SizedBox(),
                ],
                centerTitle: true,
                elevation: 0.0,
                title: Container(
                  width: 250,
                  child: TextFormField(
                      focusNode: titleFocusNode,
                      initialValue: !isNew! ? contract!.contractName : contractName,
                      enabled: true,
                      cursorColor: Color(ColorConstants.getPrimaryBlack()),
                      onChanged: (text) {
                        setState(() {});
                        pageState.onNameChanged!(text);
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
                        fillColor: Color(ColorConstants.getPrimaryWhite()),
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
                      keyboardType: TextInputType.text,
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: TextDandyLight.getFontSize(TextDandyLight.MEDIUM_TEXT),
                          fontFamily: TextDandyLight.getFontFamily(),
                          fontWeight: TextDandyLight.getFontWeight(),
                          color: Color(ColorConstants.getPrimaryBlack()))
                  ),
                ),
              ),
              backgroundColor: Color(ColorConstants.getPrimaryWhite()),
              body: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Color(ColorConstants.getPrimaryWhite()),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Container(
                            color: Color(ColorConstants.getPrimaryWhite()),
                            margin: EdgeInsets.only(left: 16, right: 16, top: 124, bottom: 48),
                            child: getEditor(),
                          ),
                          Container(
                            margin: EdgeInsets.only(left:16, top: 8, bottom: 8),
                            child: TextDandyLight(
                              type: TextDandyLight.LARGE_TEXT,
                              text: 'Signatures',
                              isBold: true,
                            ),
                          ),
                          Column(
                            children: signatures(pageState),
                          ),
                          Container(
                            height: 164,
                          )
                      ],
                      ),
                    ),
                  ),
                  !isKeyboardVisible ? Container(
                    height: MediaQuery.of(context).size.height,
                    alignment: Alignment.bottomRight,
                    padding: EdgeInsets.only(bottom: 32),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          hasUnsavedChanges = false;
                        });
                        if(jobDocumentId != null && jobDocumentId!.isNotEmpty && contract!.signedByClient!) {
                          _ackSaveChangesAlert(context, pageState);
                        } else {
                          pageState.onContractSaved!(_controller!.document, jobDocumentId);
                          showSuccessAnimation();
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 54,
                        margin: EdgeInsets.only(left: 16, right: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          color: Color(ColorConstants.getPeachDark()),
                          // boxShadow: ElevationToShadow[4],
                        ),
                        child: TextDandyLight(
                          type: TextDandyLight.LARGE_TEXT,
                          text: jobDocumentId != null ? 'Save Changes' : 'Save Contract',
                          textAlign: TextAlign.center,
                          color: Color(ColorConstants.getPrimaryWhite()),
                        ),
                      ),
                    ),
                  ) : SizedBox(),
                  isKeyboardVisible ? Container(
                    height: MediaQuery.of(context).size.height,
                    alignment: Alignment.bottomLeft,
                    margin: EdgeInsets.only(bottom: !isKeyboardVisible ? 96 : 0),
                    child: GestureDetector(
                      onTap: () {
                       _showInsertSheet();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: !isKeyboardVisible ? 54 : 43,
                        width: !isKeyboardVisible ? MediaQuery.of(context).size.width : 200,
                        margin: EdgeInsets.only(left: !isKeyboardVisible ? 16 : 8, right: 16),
                        decoration: BoxDecoration(
                          borderRadius: !isKeyboardVisible ? BorderRadius.circular(28) : BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                          color: Color(ColorConstants.getBlueDark()),
                          // boxShadow: ElevationToShadow[4],
                        ),
                        child: TextDandyLight(
                          type: TextDandyLight.LARGE_TEXT,
                          text: 'Insert Job Data',
                          textAlign: TextAlign.center,
                          color: Color(ColorConstants.getPrimaryWhite()),
                        ),
                      ),
                    ),
                  ) : SizedBox(),
                  Container(
                    color: Color(ColorConstants.getPrimaryWhite()),
                    padding: const EdgeInsets.only(bottom: 4, top: 18),
                    child: quill.QuillToolbar.simple(
                      configurations: quill.QuillSimpleToolbarConfigurations(
                        controller: _controller!,
                        toolbarSize: 38,
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
                        showSearchButton: false,
                        showLink: false,
                        showAlignmentButtons: true,
                        multiRowsDisplay: false,
                        color: Color(ColorConstants.getPrimaryWhite()),
                      )
                    ),
                  )
                ],
              ),
            ),
        ),
      );

  Widget getEditor() {
    return quill.QuillEditor.basic(
      scrollController: ScrollController(),
      focusNode: contractFocusNode,
      configurations: QuillEditorConfigurations(
        controller: _controller!,
        scrollable: true,
        autoFocus: true,
        readOnly: false,
        expands: false,
        placeholder: "Paste contract terms here",
      )
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

  Future<void> _ackDeleteAlert(BuildContext context, ContractEditPageState pageState) {
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
                if(jobDocumentId != null) {
                  pageState.deleteFromJob!();
                } else {
                  pageState.onDeleteSelected!();
                }
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
                if(jobDocumentId != null) {
                  pageState.deleteFromJob!();
                } else {
                  pageState.onDeleteSelected!();
                }
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

  showOverlay(BuildContext context) {
    if (overlayEntry != null) return;
    OverlayState overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(builder: (context) {
      return Positioned(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          right: 0.0,
          left: 0.0,
          child: InputDoneView());
    });

    overlayState.insert(overlayEntry!);
  }

  removeOverlay() {
    if (overlayEntry != null) {
      overlayEntry!.remove();
      overlayEntry = null;
    }
  }

  List<Widget> signatures(ContractEditPageState pageState) {
    return [
      Container(
        width: 410,
        margin: EdgeInsets.only(bottom: 64, left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 0, bottom: 8),
                  child: TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    text: 'Date: ',
                    isBold: true,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 0, bottom: 8),
                  child: TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    text:
                    DateFormat('EEE, MMMM dd, yyyy').format(DateTime.now()),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 0, bottom: 8),
                  child: TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    text: 'Photographer Name: ',
                    isBold: true,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 0, bottom: 8),
                  child: TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    text: pageState.profile != null ? (pageState.profile!.firstName! + ' ' +
                        pageState.profile!.lastName!) : '',
                  ),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(bottom: 8),
              child: TextDandyLight(
                type: TextDandyLight.MEDIUM_TEXT,
                text: 'Photographer Signature:',
                textAlign:
                TextAlign.center,
                isBold: true,
              ),
            ),
            TextField(
              controller: _photogSigController,
              enabled: false,
              cursorColor: Color(ColorConstants.getPrimaryBlack()),
              textCapitalization: TextCapitalization.words,
              style: TextStyle(
                  fontFamily: FontTheme.SIGNATURE2,
                  fontSize: 48,
                  fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Color(ColorConstants.getPrimaryBlack())),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Color(ColorConstants.getPrimaryBlack())),
                ),
              ),
            )
          ],
        ),
      ),
      Container(
        width: 410,
        margin: EdgeInsets.only(bottom: 64, left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 0, bottom: 8),
                  child: TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    text: 'Date: ',
                    isBold: true,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 0, bottom: 8),
                  child: TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    text: DateFormat('EEE, MMMM dd, yyyy').format(
                        pageState.contract != null && pageState.contract!.clientSignedDate != null
                            ? pageState.contract!.clientSignedDate!
                            : DateTime.now()),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 0, bottom: 8),
                  child: TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    text: 'Client Name: ',
                    isBold: true,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 0, bottom: 8),
                  child: TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    text: 'Client Name',
                  ),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(bottom: 8),
              child: TextDandyLight(
                type: TextDandyLight.MEDIUM_TEXT,
                text: 'Client Signature:',
                textAlign:
                TextAlign.center,
                isBold: true,
              ),
            ),
            TextField(
              enabled: false,
              controller: _clientSignatureController,
              cursorColor: Color(ColorConstants.getPrimaryBlack()),
              textCapitalization: TextCapitalization.words,
              style: TextStyle(
                  fontFamily: FontTheme.SIGNATURE2,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Color(ColorConstants.getPrimaryBlack())),
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Color(ColorConstants.getPrimaryBlack())),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Color(ColorConstants.getPrimaryBlack())),
                ),
              ),
            )
          ],
        ),
      )
    ];
  }
}
