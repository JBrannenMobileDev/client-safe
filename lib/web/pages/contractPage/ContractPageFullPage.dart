import 'dart:convert';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/FontTheme.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/DeviceType.dart';
import 'package:dandylight/widgets/TextDandyLight.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../models/Contract.dart';
import '../../../utils/analytics/EventNames.dart';
import '../../../utils/analytics/EventSender.dart';
import '../ClientPortalPageState.dart';
import 'package:redux/redux.dart';

class ContractFullPage extends StatefulWidget {
  final ScrollController? scrollController;
  final Contract contract;

  ContractFullPage({this.scrollController, required this.contract});

  @override
  State<StatefulWidget> createState() {
    return _ContractFullPageState(scrollController!, contract);
  }
}

class _ContractFullPageState extends State<ContractFullPage> {
  TextEditingController? _clientSignatureController = TextEditingController();
  final FocusNode? contractFocusNode = FocusNode();
  QuillController? _controller;
  final ScrollController? scrollController;
  final Contract contract;
  bool isHoveredSubmit = false;
  bool isHoveredDownloadPDF = false;
  bool isHoveredScrollDown = false;

  _ContractFullPageState(this.scrollController, this.contract);

  void _scrollDown() {
    scrollController!.animateTo(
      scrollController!.position.maxScrollExtent,
      duration: Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, ClientPortalPageState>(
        onInit: (current) {
          if(contract.clientSignature != null && contract.clientSignature!.isNotEmpty) {
            _clientSignatureController!.text = contract.clientSignature!;
          }

          _controller = contract.jsonTerms != null ? QuillController(
              document: Document.fromJson(jsonDecode(contract.jsonTerms!)),
              selection: const TextSelection.collapsed(offset: 0)
          ) : QuillController.basic();
        },
        onDidChange: (previous, current) {
          if (previous!.errorMsg!.isEmpty && current.errorMsg!.isNotEmpty) {
            // DandyToastUtil.showErrorToast(current.errorMsg);  dont need to show an error message for now.
            current.resetErrorMsg!();
          }
        },
        converter: (Store<AppState> store) => ClientPortalPageState.fromStore(store),
        builder: (BuildContext context, ClientPortalPageState pageState) => Scaffold(
          appBar: AppBar(
            scrolledUnderElevation: 4,
            iconTheme: IconThemeData(
              color: Color(ColorConstants.getPrimaryBlack()), //change your color here
            ),
            backgroundColor: Color(ColorConstants.getPrimaryWhite()),
            elevation: 0.0,
            title: TextDandyLight(
              type: DeviceType.getDeviceTypeByContext(context) == Type.Website ? TextDandyLight.EXTRA_LARGE_TEXT : TextDandyLight.LARGE_TEXT,
              text: contract.contractName,
              color: Color(ColorConstants.getPrimaryBlack()),
            ),
            leading: IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              icon:const Icon(Icons.close),
              //replace with our own icon data.
            ),
          ),
          backgroundColor: Color(ColorConstants.getPrimaryWhite()),
          body: Container(
            alignment: Alignment.topCenter,
            width: DeviceType.getDeviceTypeByContext(context) == Type.Website ? 1080 : MediaQuery.of(context).size.width,
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
                      width: DeviceType.getDeviceTypeByContext(context) == Type.Website ? 1080 : MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          MouseRegion(
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
                            child: GestureDetector(
                              onTap: () {
                                pageState.onDownloadContractSelected!(contract);
                                EventSender().sendEvent(eventName: EventNames.CLIENT_PORTAL_CONTRACT_PDF_DOWNLOADED);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: DeviceType.getDeviceTypeByContext(
                                    context) == Type.Website ? 116 : 48,
                                height: 48,
                                margin: EdgeInsets.only(bottom: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  color: ColorConstants.hexToColor(pageState.profile!.selectedColorTheme!.buttonColor!),
                                ),
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
                          ),
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            onHover: (event) {
                              setState(() {
                                isHoveredScrollDown = true;
                              });
                            },
                            onExit: (event) {
                              setState(() {
                                isHoveredScrollDown = false;
                              });
                            },
                            child: GestureDetector(
                              onTap: () {
                                _scrollDown();
                                EventSender().sendEvent(eventName: EventNames.CLIENT_PORTAL_CONTRACT_SCROLL_SELECTED);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: DeviceType.getDeviceTypeByContext(
                                    context) == Type.Website ? 116 : 48,
                                height: 48,
                                margin: EdgeInsets.only(bottom: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  color: ColorConstants.hexToColor(pageState.profile!.selectedColorTheme!.buttonColor!),
                                ),
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
                                          "images/scroll_down_white.png",
                                          color: Color(ColorConstants.getPrimaryWhite()
                                          ),
                                        )
                                    ),
                                    DeviceType.getDeviceTypeByContext(context) ==
                                        Type.Website ? TextDandyLight(
                                      type: TextDandyLight.MEDIUM_TEXT,
                                      text: 'Scroll',
                                      color: Color(
                                          ColorConstants.getPrimaryWhite()),
                                      isBold: isHoveredScrollDown,
                                    ) : SizedBox(),
                                  ],
                                ),
                              ),
                            ),
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
                    cursor: contract.signedByClient!
                        ? SystemMouseCursors.basic
                        : SystemMouseCursors.click,
                    onHover: (event) {
                      if (!contract.signedByClient!) {
                        setState(() {
                          isHoveredSubmit = true;
                        });
                      }
                    },
                    onExit: (event) {
                      if (!contract.signedByClient!) {
                        setState(() {
                          isHoveredSubmit = false;
                        });
                      }
                    },
                    child: GestureDetector(
                      onTap: () {
                        if (!contract.signedByClient!) {
                          pageState.onClientSignatureSaved!(_clientSignatureController!.text, contract);
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 200,
                        height: 48,
                        margin: EdgeInsets.only(
                            bottom: 0, top: 32),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: Color(
                                contract.signedByClient!
                                    ? ColorConstants
                                    .getPrimaryBackgroundGrey()
                                    : ColorConstants.getPeachDark())),
                        child: pageState.isLoading! ? LoadingAnimationWidget
                            .fourRotatingDots(
                          color: Color(ColorConstants.getPrimaryWhite()),
                          size: 26,
                        ) : TextDandyLight(
                          type: TextDandyLight.LARGE_TEXT,
                          text: contract.signedByClient!
                              ? 'Signature Saved'
                              : 'Save Signature',
                          color: Color(ColorConstants.getPrimaryWhite()),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 64,
                )
              ],
            ),
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
                        contract.photographerSignedDate != null ? contract.photographerSignedDate! : DateTime.now()),
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
                    text: (pageState.profile!.firstName != null ? pageState.profile!.firstName : "")! + ' ' + (pageState.profile!.lastName != null ? pageState.profile!.lastName! : ''),
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
              initialValue: (pageState.profile!.firstName != null ? pageState.profile!.firstName : "")! + ' ' +
                  (pageState.profile!.lastName != null ? pageState.profile!.lastName! : ''),
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
                        contract.clientSignedDate != null
                            ? contract.clientSignedDate!
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
                    text: pageState.job!.client != null ? pageState.job!.client!.getClientFullName() : 'Client Name',
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
              enabled: !contract.signedByClient!,
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
    return QuillEditor.basic(
      scrollController: ScrollController(),
      focusNode: contractFocusNode,
      configurations: QuillEditorConfigurations(
        controller: _controller!,
        scrollable: true,
        padding: EdgeInsets.all(0),
        showCursor: false,
        autoFocus: true,
        readOnly: true,
        expands: false,
      ),
    );
  }
}
