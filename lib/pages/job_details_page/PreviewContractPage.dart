import 'dart:convert';
import 'dart:ui';

import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:intl/intl.dart';
import '../../models/Contract.dart';
import '../../models/FontTheme.dart';
import '../../widgets/TextDandyLight.dart';

class PreviewContractPage extends StatefulWidget {
  final Contract contract;
  final String photographerName;
  PreviewContractPage({required this.contract, required this.photographerName});

  @override
  State<StatefulWidget> createState() {
    return _PreviewContractPageState(contract, photographerName);
  }
}

class _PreviewContractPageState extends State<PreviewContractPage> with TickerProviderStateMixin {
  QuillController? _controller;
  TextEditingController _clientSignatureController = TextEditingController(text: "Client Name");
  TextEditingController _photogSigController = TextEditingController(text: 'Photographer Name');
  final FocusNode titleFocusNode = FocusNode();
  final FocusNode contractFocusNode = FocusNode();
  final TextEditingController controllerTitle = TextEditingController();
  OverlayEntry? overlayEntry;
  final Contract contract;
  final String photographerName;

  _PreviewContractPageState(this.contract, this.photographerName);


  @override
  void initState() {
    _controller = contract.jsonTerms != null ? QuillController(
        document: Document.fromJson(jsonDecode(contract.jsonTerms!)),
        selection: const TextSelection.collapsed(offset: 0),
        readOnly: true
    ) : QuillController.basic();
    if(contract.signedByClient ?? false) {
      _clientSignatureController.text = contract.clientSignature ?? '';
      _photogSigController.text = contract.photographerSignature ?? '';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
              appBar: AppBar(
                iconTheme: IconThemeData(
                  color: Color(ColorConstants.getPrimaryBlack()), //change your color here
                ),
                backgroundColor: Color(ColorConstants.getPrimaryWhite()),
                centerTitle: true,
                elevation: 0.0,
                surfaceTintColor: Colors.transparent,
                title: Container(
                  alignment: Alignment.center,
                  width: 250,
                  child: TextDandyLight(
                    type: TextDandyLight.LARGE_TEXT,
                    text: 'Preview',
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
                            margin: EdgeInsets.only(left: 16, right: 16, top: 32, bottom: 48),
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
                            children: signatures(),
                          ),
                          Container(
                            height: 164,
                          )
                      ],
                      ),
                    ),
                  ),
                ],
              ),
      );

  Widget getEditor() {
    return QuillEditor.basic(
      scrollController: ScrollController(),
      focusNode: contractFocusNode,
      configurations: QuillEditorConfigurations(
        controller: _controller!,
        scrollable: true,
        padding: const EdgeInsets.all(0),
        autoFocus: false,
        expands: false,
        showCursor: false,
        placeholder: "Past contract terms here",
      ),
    );
  }

  List<Widget> signatures() {
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
                    text: (contract.signedByClient ?? false) ? photographerName : 'Firstname Lastname',
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
                    text: DateFormat('EEE, MMMM dd, yyyy').format(DateTime.now()),
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
                    text: (contract.signedByClient ?? false) ? contract.clientName : 'Client Name',
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
