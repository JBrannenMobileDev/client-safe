import 'package:dandylight/pages/contract_edit_page/ContractEditPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;


import '../../../AppState.dart';
import '../../../widgets/TextDandyLight.dart';
import '../../models/Job.dart';

class InsertJobDetailBottomSheet extends StatefulWidget {
  final quill.QuillController _controller;

  InsertJobDetailBottomSheet(this._controller);

  @override
  State<StatefulWidget> createState() {
    return _InsertJobDetailBottomSheetState(_controller);
  }
}

class _InsertJobDetailBottomSheetState extends State<InsertJobDetailBottomSheet> with TickerProviderStateMixin {
  final quill.QuillController _controller;

  _InsertJobDetailBottomSheetState(this._controller);

  List<String> _chipLabels = [
    Job.DETAIL_CLIENT_NAME,
    Job.DETAIL_CLIENT_PHONE,
    Job.DETAIL_CLIENT_EMAIL,
    Job.DETAIL_PHOTOGRAPHER_NAME,
    Job.DETAIL_BUSINESS_NAME,
    Job.DETAIL_LOCATION_ADDRESS,
    Job.DETAIL_SESSION_DATE,
    Job.DETAIL_RETAINER_PRICE,
    Job.DETAIL_RETAINER_DUE_DATE,
    Job.DETAIL_TOTAL,
    Job.DETAIL_TOTAL_DUE_DATE
  ];

  void _insertAndFormat(String name) {
    _controller.replaceText(_controller.selection.baseOffset, 0, name, null);
    _controller.formatText(_controller.selection.baseOffset, name.length, quill.Attribute.fromKeyValue('bold', true));
    _controller.formatText(_controller.selection.baseOffset, name.length, quill.Attribute.fromKeyValue('color', "#d49a89"));
  }

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, ContractEditPageState>(
    converter: (Store<AppState> store) => ContractEditPageState.fromStore(store),
    builder: (BuildContext context, ContractEditPageState pageState) =>
         Container(
           height: 532,
           width: MediaQuery.of(context).size.width,
           decoration: BoxDecoration(
               borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
               color: Color(ColorConstants.getPrimaryWhite())),
           padding: EdgeInsets.only(left: 16.0, right: 16.0),
             child: Column(
                   mainAxisAlignment: MainAxisAlignment.start,
                   children: <Widget>[
                     Container(
                       margin: EdgeInsets.only(top: 24, bottom: 0),
                       child: TextDandyLight(
                         type: TextDandyLight.LARGE_TEXT,
                         text: 'Insert Job Detail',
                         textAlign: TextAlign.center,
                         color: Color(ColorConstants.primary_black),
                       ),
                     ),
                     Container(
                       margin: EdgeInsets.only(top: 8, bottom: 16, left: 16, right: 16),
                       child: TextDandyLight(
                         type: TextDandyLight.SMALL_TEXT,
                         text: 'When a job detail is inserted into this contract template, you will see a placeholder for the detail that will later be populated automatically from whichever job this contract is added to.',
                         textAlign: TextAlign.center,
                         color: Color(ColorConstants.primary_black),
                       ),
                     ),
                     Container(
                       margin: EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 0),
                       child: Wrap(
                         alignment: WrapAlignment.center,
                         spacing: 8.0,
                         children: List<Widget>.generate(
                           _chipLabels.length,
                               (int index) {
                             return Stack(
                               alignment: Alignment.center,
                               children: <Widget>[
                                 Container(
                                   child: ChoiceChip(
                                     label: TextDandyLight(
                                       type: TextDandyLight.SMALL_TEXT,
                                       text: Job.getDetailDisplayName(_chipLabels.elementAt(index)),
                                       textAlign: TextAlign.start,
                                       color: Color(ColorConstants.getPrimaryBlack()),
                                     ),
                                     backgroundColor: Color(ColorConstants.getPrimaryBackgroundGrey()),
                                     selectedColor: Color(ColorConstants.getPeachDark()),
                                     selected: false,
                                     onSelected: (bool selected) {
                                       _insertAndFormat(_chipLabels.elementAt(index));
                                       Navigator.of(context).pop();
                                     },
                                   ),
                                 ),
                               ],
                             );
                           },
                         ).toList(),
                       ),
                     ),
                   ],
           ),
         ),
    );
}