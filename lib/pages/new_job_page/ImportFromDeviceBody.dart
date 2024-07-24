import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_contact_pages/NewContactDeviceContactListWidget.dart';
import 'package:dandylight/pages/new_job_page/widgets/NewJobTextField.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../../utils/styles/Styles.dart';
import '../../widgets/TextDandyLight.dart';
import 'NewJobPageActions.dart';
import 'NewJobPageState.dart';

class ImportFromDeviceBody extends StatefulWidget {
  @override
  _ImportFromDeviceBodyState createState() {
    return _ImportFromDeviceBodyState();
  }
}

class _ImportFromDeviceBodyState extends State<ImportFromDeviceBody>
    with AutomaticKeepAliveClientMixin {
  final searchTextController = TextEditingController();
  int selectorIndex = 1;
  Map<int, Widget>? genders;
  ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, NewJobPageState>(
      onInit: (store) {
        store.dispatch(GetNewJobDeviceContactsAction(store.state.newJobPageState));
      },
      converter: (store) => NewJobPageState.fromStore(store),
      builder: (BuildContext context, NewJobPageState pageState) =>
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  NewJobTextField(
                    controller: searchTextController,
                    hintText: 'Name',
                    inputType: TextInputType.text,
                    height: 54.0,
                    onTextInputChanged: pageState.onContactSearchTextChanged!,
                    keyboardAction: TextInputAction.search,
                    capitalization: TextCapitalization.words,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height - 179,
                    child: ListView.builder(
                      reverse: false,
                      padding: new EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 64.0),
                      shrinkWrap: true,
                      controller: _controller,
                      physics: const ClampingScrollPhysics(),
                      itemCount: pageState.filteredDeviceContacts!.length,
                      itemBuilder: _buildItem,
                    ),
                  ),
                ],
              ),
            ],
          ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    return StoreConnector<AppState, NewJobPageState>(
      converter: (store) => NewJobPageState.fromStore(store),
      builder: (BuildContext context, NewJobPageState pageState) =>
          TextButton(
            style: Styles.getButtonStyle(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              color: pageState.filteredDeviceContacts!.elementAt(index).identifier == pageState.selectedDeviceContact?.identifier ? Color(ColorConstants.getPrimaryColor()) : Colors.transparent,
            ),
            onPressed: () {
              pageState.onDeviceContactSelected!(pageState.filteredDeviceContacts!.elementAt(index));
              Navigator.of(context).pop();
            },
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Device.get().isIos ? const Icon(CupertinoIcons.profile_circled) : const Icon(Icons.account_circle),
                  tooltip: 'Person',
                  onPressed: null,
                ),
                Expanded(
                  child: Container(
                    height: 64.0,
                    margin: const EdgeInsets.only(right: 32.0),
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextDandyLight(
                            type: TextDandyLight.EXTRA_SMALL_TEXT,
                            text: pageState.filteredDeviceContacts!.elementAt(index).displayName?? 'Name not available',
                            textAlign: TextAlign.start,
                            color: pageState.filteredDeviceContacts!.elementAt(index).identifier == pageState.selectedDeviceContact?.identifier ? Color(ColorConstants.getPrimaryWhite()) : Color(ColorConstants.getPrimaryBlack()),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
