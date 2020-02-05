import 'package:client_safe/AppState.dart';
import 'package:client_safe/models/Client.dart';
import 'package:client_safe/pages/new_contact_pages/NewContactDeviceContactListWidget.dart';
import 'package:client_safe/pages/new_contact_pages/NewContactPageState.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_redux/flutter_redux.dart';

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
  final Map<int, Widget> genders = const <int, Widget>{
    0: Text(Client.GENDER_MALE),
    1: Text(Client.GENDER_FEMALE),
  };
  ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, NewContactPageState>(
      onInit: (store) {
        firstNameTextController.value = firstNameTextController.value.copyWith(text:store.state.newContactPageState.newContactFirstName);
        lastNameTextController.value = lastNameTextController.value.copyWith(text:store.state.newContactPageState.newContactLastName,);
      },
      onWillChange: (state) {
        firstNameTextController.value = firstNameTextController.value.copyWith(text:state.newContactFirstName);
        lastNameTextController.value = lastNameTextController.value.copyWith(text:state.newContactLastName,);
        searchTextController.value = searchTextController.value.copyWith(text:state.searchText,);
      },
      converter: (store) => NewContactPageState.fromStore(store),
      builder: (BuildContext context, NewContactPageState pageState) =>
          Container(
        margin: EdgeInsets.only(left: 26.0, right: 26.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            pageState.deviceContacts.length > 0 ?
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(

                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Color(ColorConstants.getPrimaryColor()),
                      ),
                      tooltip: 'Cancel',
                      onPressed: () => {
                        if(searchTextController.text.length > 0){
                          pageState.onContactSearchTextChanged('')
                        }else{
                          pageState.onCloseSelected()
                        }
                      },
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 8.0),
                        alignment: Alignment.center,
                        width: 259.0,
                        height: 45.0,
                        child: TextField(
                          textInputAction: TextInputAction.go,
                          maxLines: 1,
                          autofocus: true,
                          controller: searchTextController,
                          onChanged: (text) {
                            pageState.onContactSearchTextChanged(text);
                          },
                          decoration: InputDecoration(
                            alignLabelWithHint: true,
                            hintText: "Name",
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.all(10.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                color: Color(ColorConstants.getPrimaryColor()),
                                width: 1.0,
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          style: new TextStyle(
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.w600,
                              color: Color(ColorConstants.primary_black)),
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
                    itemCount: pageState.filteredDeviceContacts.length,
                    itemBuilder: _buildItem,
                  ),
                ),
              ],
            ) : Column(
              children: <Widget>[
                Container(
                  width: 250.0,
                  child: CupertinoSegmentedControl<int>(
                    borderColor: Color(ColorConstants.getPrimaryColor()),
                    selectedColor: Color(ColorConstants.getPrimaryColor()),
                    unselectedColor: Colors.white,
                    children: genders,
                    onValueChanged: (int genderIndex) {
                      pageState.onGenderSelected(genderIndex);
                    },
                    groupValue: pageState.isFemale ? 1 : 0,
                  ),
                ),
                InkWell(
                  onTap: () => {
                    pageState.onGetDeviceContactsSelected()
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        color: Color(ColorConstants.getPrimaryColor()),
                        icon: Device.get().isIos ? Icon(CupertinoIcons.group_solid, color: Color(ColorConstants.getPrimaryColor()),) : Icon(Icons.people, color: Color(ColorConstants.getPrimaryColor())),
                        tooltip: 'Search',
                      ),
                      Text(
                        "Device Contacts",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w800,
                          color: Color(ColorConstants.getPrimaryColor()),
                        ),
                      ),
                    ],
                  ),
                ),
                NewContactTextField(
                    firstNameTextController,
                    "First Name",
                    TextInputType.text,
                    60.0,
                    pageState.onClientFirstNameChanged,
                    NewContactPageState.ERROR_FIRST_NAME_MISSING,
                    TextInputAction.next,
                    _firstNameFocus,
                    onFirstNameAction,
                    TextCapitalization.words,
                    null),
                NewContactTextField(
                    lastNameTextController,
                    "Last Name",
                    TextInputType.text,
                    60.0,
                    pageState.onClientLastNameChanged,
                    NewContactPageState.NO_ERROR,
                    TextInputAction.done,
                    _lastNameFocus,
                    onLastNameAction,
                    TextCapitalization.words,
                    null)
              ],
            ),
          ],
        ),
      ),
    );
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
