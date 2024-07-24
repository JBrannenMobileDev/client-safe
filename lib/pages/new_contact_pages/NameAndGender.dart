import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_contact_pages/NewContactDeviceContactListWidget.dart';
import 'package:dandylight/pages/new_contact_pages/NewContactPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import '../../utils/permissions/UserPermissionsUtil.dart';
import '../../widgets/TextDandyLight.dart';
import 'NewContactTextField.dart';

class NameAndGender extends StatefulWidget {
  @override
  _NameAndGenderState createState() {
    return _NameAndGenderState();
  }
}

class _NameAndGenderState extends State<NameAndGender>
    with AutomaticKeepAliveClientMixin {
  final firstNameTextController = TextEditingController();
  final lastNameTextController = TextEditingController();
  final searchTextController = TextEditingController();
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  int selectorIndex = 1;
  Map<int, Widget>? genders;
  ScrollController _controller = ScrollController();
  Function? onImportContactsLocal;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, NewContactPageState>(
      onInit: (store) {
        firstNameTextController.value = firstNameTextController.value.copyWith(text:store.state.newContactPageState!.newContactFirstName!);
        lastNameTextController.value = lastNameTextController.value.copyWith(text:store.state.newContactPageState!.newContactLastName!);
      },
      onInitialBuild: (current) {
        onImportContactsLocal = current.onGetDeviceContactsSelected;
      },
      onWillChange: (statePrevious, stateNew) {
        firstNameTextController.value = firstNameTextController.value.copyWith(text:stateNew.newContactFirstName);
        lastNameTextController.value = lastNameTextController.value.copyWith(text:stateNew.newContactLastName,);
        searchTextController.value = searchTextController.value.copyWith(text:stateNew.searchText,);
      },
      converter: (store) => NewContactPageState.fromStore(store),
      builder: (BuildContext context, NewContactPageState pageState) =>
          Container(
        margin: EdgeInsets.only(left: 26.0, right: 26.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            3 > 9 ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(

                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Color(ColorConstants.getPeachDark()),
                      ),
                      tooltip: 'Cancel',
                      onPressed: () => {
                        if(searchTextController.text.length > 0){
                          pageState.onContactSearchTextChanged!('')
                        }else{
                          pageState.onCloseSelected!()
                        }
                      },
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 8.0),
                        alignment: Alignment.center,
                        width: 259.0,
                        height: 45.0,
                        child: TextField(
                          style: TextStyle(
                              fontSize: TextDandyLight.getFontSize(TextDandyLight.MEDIUM_TEXT),
                              fontFamily: TextDandyLight.getFontFamily(),
                              fontWeight: TextDandyLight.getFontWeight(),
                              color: Color(ColorConstants.getPrimaryBlack())),
                          textInputAction: TextInputAction.go,
                          maxLines: 1,
                          autofocus: true,
                          cursorColor: Color(ColorConstants.getBlueDark()),
                          controller: searchTextController,
                          onChanged: (text) {
                            pageState.onContactSearchTextChanged!(text);
                          },
                          decoration: InputDecoration(
                            alignLabelWithHint: true,
                            hintText: "Name",
                            labelStyle: TextStyle(
                                fontSize: TextDandyLight.getFontSize(TextDandyLight.MEDIUM_TEXT),
                                fontFamily: TextDandyLight.getFontFamily(),
                                fontWeight: TextDandyLight.getFontWeight(),
                                color: Color(ColorConstants.getPrimaryBlack())),
                            fillColor: Color(ColorConstants.getPrimaryWhite()),
                            contentPadding: EdgeInsets.all(10.0),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                color: Color(ColorConstants.getBlueDark()),
                                width: 1.0,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                color: Color(ColorConstants.getBlueLight()),
                                width: 1.0,
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                        )),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 0.0),
                  height: 295.0,
                  child: ListView.builder(
                    reverse: false,
                    padding: new EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 64.0),
                    shrinkWrap: true,
                    controller: _controller,
                    physics: ClampingScrollPhysics(),
                    itemCount: pageState.filteredDeviceContacts!.length,
                    itemBuilder: _buildItem,
                  ),
                ),
              ],
            ) : Column(
              children: <Widget>[
                InkWell(
                  onTap: () => {
                    UserPermissionsUtil.showPermissionRequest(
                      permission: Permission.contacts,
                      context: context,
                      callOnGranted: callOnGranted,
                    ),
                    EventSender().sendEvent(eventName: EventNames.BT_IMPORT_DEVICE_CONTACT),
                  },
                  child: Container(
                    height: 54,
                    margin: EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(27),
                      color: Color(ColorConstants.getPeachDark())
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          onPressed: () {

                          },
                          color: Color(ColorConstants.getPeachDark()),
                          icon: Device.get().isIos ? Icon(CupertinoIcons.group_solid, color: Color(ColorConstants.getPrimaryWhite()),) : Icon(Icons.people, color: Color(ColorConstants.getPrimaryWhite())),
                          tooltip: 'Search',
                        ),
                        TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          text: "Import Device Contact",
                          textAlign: TextAlign.start,
                          color: Color(ColorConstants.getPrimaryWhite()),
                        ),
                      ],
                    ),
                  ),
                ),
                NewContactTextField(
                    firstNameTextController,
                    "First Name",
                    TextInputType.text,
                    66.0,
                    pageState.onClientFirstNameChanged!,
                    NewContactPageState.ERROR_FIRST_NAME_MISSING,
                    TextInputAction.next,
                    _firstNameFocus,
                    onFirstNameAction,
                    TextCapitalization.words,
                    null,
                    true,
                    ColorConstants.getBlueLight(),
                ),
                NewContactTextField(
                    lastNameTextController,
                    "Last Name",
                    TextInputType.text,
                    66.0,
                    pageState.onClientLastNameChanged!,
                    NewContactPageState.NO_ERROR,
                    TextInputAction.done,
                    _lastNameFocus,
                    onLastNameAction,
                    TextCapitalization.words,
                    null,
                    true,
                  ColorConstants.getBlueLight(),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void callOnGranted() {
    onImportContactsLocal!();
  }

  Widget _buildItem(BuildContext context, int index) {
    return StoreConnector<AppState, NewContactPageState>(
      converter: (store) => NewContactPageState.fromStore(store),
      builder: (BuildContext context, NewContactPageState pageState) =>
          NewContactDeviceContactListWidget(index),
    );
  }

  void onFirstNameAction(){
    _firstNameFocus.unfocus();
    FocusScope.of(context).requestFocus(_lastNameFocus);
  }

  void onLastNameAction(){
    _lastNameFocus.unfocus();
  }

  @override
  bool get wantKeepAlive => true;
}
