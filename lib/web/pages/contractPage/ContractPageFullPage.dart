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

import 'ContractPage.dart';

class ContractFullPage extends StatefulWidget {
  final Contract contract;

  ContractFullPage({required this.contract});

  @override
  State<StatefulWidget> createState() {
    return _ContractFullPageState(contract);
  }
}

class _ContractFullPageState extends State<ContractFullPage> {
  final Contract contract;
  final ScrollController? scrollController = ScrollController();

  _ContractFullPageState(this.contract);

  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, ClientPortalPageState>(
        converter: (Store<AppState> store) => ClientPortalPageState.fromStore(store),
        builder: (BuildContext context, ClientPortalPageState pageState) => Scaffold(
          appBar: AppBar(
            surfaceTintColor: Color(ColorConstants.getPrimaryWhite()),
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
          body: SingleChildScrollView(
            controller: scrollController,
            child: ContractPage(scrollController: scrollController, contract: contract),
          )
        ),
      );
}
