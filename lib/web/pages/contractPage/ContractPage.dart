import 'dart:convert';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/FontTheme.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/DandyToastUtil.dart';
import 'package:dandylight/utils/DeviceType.dart';
import 'package:dandylight/widgets/TextDandyLight.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;


import '../ClientPortalPageState.dart';
import 'package:redux/redux.dart';

class ContractPage extends StatefulWidget {
  final ScrollController scrollController;

  ContractPage({this.scrollController});

  @override
  State<StatefulWidget> createState() {
    return _ContractPageState(scrollController);
  }
}

class _ContractPageState extends State<ContractPage> {
  TextEditingController _clientSignatureController = TextEditingController();
  final FocusNode contractFocusNode = FocusNode();
  quill.QuillController _controller;
  final ScrollController scrollController;
  bool isHoveredSubmit = false;
  bool isHoveredDownloadPDF = false;

  _ContractPageState(this.scrollController);

  void _scrollDown() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, ClientPortalPageState>(
        onInit: (current) {
          if(current.state.clientPortalPageState.proposal.contract.clientSignature != null && current.state.clientPortalPageState.proposal.contract.clientSignature.length > 0) {
            _clientSignatureController.text = current.state.clientPortalPageState.proposal.contract.clientSignature;
          }

          _controller = quill.QuillController(
              document: quill.Document.fromJson(jsonDecode(current.state.clientPortalPageState.proposal.contract.jsonTerms)),
              selection: TextSelection.collapsed(offset: 0)
          );
        },
        onDidChange: (previous, current) {
          if (previous.errorMsg.isEmpty && current.errorMsg.isNotEmpty) {
            DandyToastUtil.showErrorToast(current.errorMsg);
            current.resetErrorMsg();
          }
        },
        converter: (Store<AppState> store) => ClientPortalPageState.fromStore(store),
        builder: (BuildContext context, ClientPortalPageState pageState) =>
            Container(
              alignment: Alignment.topCenter,
              width: 1080,
              color: Color(ColorConstants.getPrimaryWhite()),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Container(
                        alignment: Alignment.topCenter,
                        margin: EdgeInsets.only(top: 32, bottom: 48),
                        child: TextDandyLight(
                          type: TextDandyLight.LARGE_TEXT,
                          text: 'Client Service Agreement',
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 24, right: 16),
                        alignment: Alignment.centerRight,
                        width: 1080,
                        child: Column(
                          children: [
                            MouseRegion(
                              child: GestureDetector(
                                onTap: () {
                                  pageState.onDownloadContractSelected();
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: DeviceType.getDeviceTypeByContext(
                                      context) == Type.Website ? 116 : 48,
                                  height: 48,
                                  margin: EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(24),
                                      color: Color(ColorConstants.getPeachDark())),
                                  child: Row(
                                    mainAxisAlignment: DeviceType
                                        .getDeviceTypeByContext(context) ==
                                        Type.Website
                                        ? MainAxisAlignment.spaceEvenly
                                        : MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 24,
                                        width: 24,
                                        child: Image.asset(
                                          "images/download_white.png",
                                        ),
                                      ),
                                      DeviceType.getDeviceTypeByContext(context) ==
                                          Type.Website ? TextDandyLight(
                                        type: TextDandyLight.MEDIUM_TEXT,
                                        text: 'PDF',
                                        color: Color(
                                            ColorConstants.getPrimaryWhite()),
                                        isBold: isHoveredDownloadPDF,
                                      ) : SizedBox(),
                                    ],
                                  ),
                                ),
                              ),
                              cursor: SystemMouseCursors.click,
                              onHover: (event) {
                                setState(() {
                                  isHoveredDownloadPDF = true;
                                });
                              },
                              onExit: (event) {
                                setState(() {
                                  isHoveredDownloadPDF = false;
                                });
                              },
                            ),
                            MouseRegion(
                              child: GestureDetector(
                                onTap: () {
                                  _scrollDown();
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: DeviceType.getDeviceTypeByContext(
                                      context) == Type.Website ? 116 : 48,
                                  height: 48,
                                  margin: EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(24),
                                      color: Color(ColorConstants.getPeachDark())),
                                  child: Row(
                                    mainAxisAlignment: DeviceType
                                        .getDeviceTypeByContext(context) ==
                                        Type.Website
                                        ? MainAxisAlignment.spaceEvenly
                                        : MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 24,
                                        width: 24,
                                        child: ImageIcon(
                                          AssetImage("images/scroll_down_white.png"),
                                          color: Color(ColorConstants.getPrimaryWhite()),
                                        )
                                      ),
                                      DeviceType.getDeviceTypeByContext(context) ==
                                          Type.Website ? TextDandyLight(
                                        type: TextDandyLight.MEDIUM_TEXT,
                                        text: 'Scroll',
                                        color: Color(
                                            ColorConstants.getPrimaryWhite()),
                                        isBold: isHoveredDownloadPDF,
                                      ) : SizedBox(),
                                    ],
                                  ),
                                ),
                              ),
                              cursor: SystemMouseCursors.click,
                              onHover: (event) {
                                setState(() {
                                  isHoveredDownloadPDF = true;
                                });
                              },
                              onExit: (event) {
                                setState(() {
                                  isHoveredDownloadPDF = false;
                                });
                              },
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 64, left: 32, right: 32),
                    child: getEditor(),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 32, left: 32, right: 32),
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: 'I acknowledge that I have read and understood the contents of this agreement, and I hereby agree to all the terms and conditions outlined within it by signing this document.',
                      isBold: true,
                    ),
                  ),
                  DeviceType.getDeviceTypeByContext(context) == Type.Website
                      ? Row(
                    children: signatures(pageState),
                  )
                      : Column(
                    children: signatures(pageState),
                  ),
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: MouseRegion(
                      child: GestureDetector(
                        onTap: () {
                          if (!pageState.proposal.contract.signedByClient) {
                            pageState.onClientSignatureSaved(_clientSignatureController.text);
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 200,
                          height: 48,
                          margin: EdgeInsets.only(
                              bottom: 0, top: 32, right: 32),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              color: Color(
                                  pageState.proposal.contract.signedByClient
                                      ? ColorConstants
                                      .getPrimaryBackgroundGrey()
                                      : ColorConstants.getPeachDark())),
                          child: pageState.isLoading ? LoadingAnimationWidget
                              .fourRotatingDots(
                            color: Color(ColorConstants.getPrimaryWhite()),
                            size: 26,
                          ) : TextDandyLight(
                            type: TextDandyLight.LARGE_TEXT,
                            text: pageState.proposal.contract.signedByClient
                                ? 'Signature Saved'
                                : 'Save Signature',
                            color: Color(ColorConstants.getPrimaryWhite()),
                          ),
                        ),
                      ),
                      cursor: pageState.proposal.contract.signedByClient
                          ? SystemMouseCursors.basic
                          : SystemMouseCursors.click,
                      onHover: (event) {
                        if (!pageState.proposal.contract.signedByClient) {
                          setState(() {
                            isHoveredSubmit = true;
                          });
                        }
                      },
                      onExit: (event) {
                        if (!pageState.proposal.contract.signedByClient) {
                          setState(() {
                            isHoveredSubmit = false;
                          });
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 64,
                  )
                ],
              ),
            ),
      );

  List<Widget> signatures(ClientPortalPageState pageState) {
    return [
      Container(
        width: 410,
        margin: EdgeInsets.only(bottom: 64, left: 32, right: 32),
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
                    DateFormat('EEE, MMMM dd, yyyy').format(
                        pageState.proposal.contract.photographerSignedDate != null ? pageState.proposal.contract.photographerSignedDate : DateTime.now()),
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
                    text: pageState.profile.firstName + ' ' +
                        pageState.profile.lastName,
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
                DeviceType.getDeviceTypeByContext(context) == Type.Website
                    ? TextAlign.start
                    : TextAlign.center,
                isBold: true,
              ),
            ),
            TextFormField(
              initialValue: pageState.profile.firstName + ' ' +
                  pageState.profile.lastName,
              enabled: false,
              cursorColor: Color(ColorConstants.getPrimaryBlack()),
              textCapitalization: TextCapitalization.words,
              style: TextStyle(
                  fontFamily: FontTheme.SIGNATURE2,
                  fontSize: DeviceType.getDeviceTypeByContext(context) == Type.Website ? 48 : 26,
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
        margin: EdgeInsets.only(bottom: 64, left: 32, right: 32),
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
                        pageState.proposal.contract.clientSignedDate != null
                            ? pageState.proposal.contract.clientSignedDate
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
                    text: pageState.job.client?.getClientFullName(),
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
                DeviceType.getDeviceTypeByContext(context) == Type.Website
                    ? TextAlign.start
                    : TextAlign.center,
                isBold: true,
              ),
            ),
            TextField(
              enabled: !pageState.proposal.contract.signedByClient,
              controller: _clientSignatureController,
              cursorColor: Color(ColorConstants.getPrimaryBlack()),
              textCapitalization: TextCapitalization.words,
              style: TextStyle(
                  fontFamily: FontTheme.SIGNATURE2,
                  fontSize: DeviceType.getDeviceTypeByContext(context) == Type.Website ? 48 : 26,
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

  Widget getEditor() {
    return quill.QuillEditor(
      controller: _controller,
      scrollable: true,
      scrollController: ScrollController(),
      focusNode: contractFocusNode,
      padding: EdgeInsets.all(0),
      autoFocus: true,
      readOnly: true,
      expands: false,
    );
  }
}
