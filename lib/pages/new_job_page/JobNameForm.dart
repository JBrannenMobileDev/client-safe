//import 'package:client_safe/AppState.dart';
//import 'package:client_safe/models/Client.dart';
//import 'package:client_safe/pages/new_job_page/NewJobPageState.dart';
//import 'package:client_safe/utils/ColorConstants.dart';
//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter/widgets.dart';
//import 'package:flutter_redux/flutter_redux.dart';
//
//class JobNameForm extends StatefulWidget {
//  @override
//  _JobNameFormState createState() {
//    return _JobNameFormState();
//  }
//}
//
//class _JobNameFormState extends State<JobNameForm>
//    with AutomaticKeepAliveClientMixin {
//  final jobTitleTextController = TextEditingController();
//  final FocusNode _firstNameFocus = FocusNode();
//
//  @override
//  Widget build(BuildContext context) {
//    super.build(context);
//    return StoreConnector<AppState, NewJobPageState>(
//      onInit: (store) {
////        jobTitleTextController.text = store.state.newJobPageState.jobTitle;
//      },
//      converter: (store) => NewJobPageState.fromStore(store),
//      builder: (BuildContext context, NewJobPageState pageState) =>
//          Container(
//        margin: EdgeInsets.only(left: 26.0, right: 26.0),
//        child: Column(
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: <Widget>[
//            Container(
//              margin: EdgeInsets.only(top: 16.0, bottom: 24.0),
//              width: 250.0,
//              child: CupertinoSegmentedControl<int>(
//                borderColor: Color(ColorConstants.primary),
//                selectedColor: Color(ColorConstants.primary),
//                unselectedColor: Colors.white,
//                children: genders,
//                onValueChanged: (int genderIndex) {
//                  pageState.onGenderSelected(genderIndex);
//                },
//                groupValue: pageState.isFemale ? 1 : 0,
//              ),
//            ),
//            NewContactTextField(
//                firstNameTextController,
//                "First Name",
//                TextInputType.text,
//                60.0,
//                pageState.onClientFirstNameChanged,
//                NewJobPageState.ERROR_FIRST_NAME_MISSING,
//                TextInputAction.next,
//                _firstNameFocus,
//                onFirstNameAction,
//                TextCapitalization.words,
//                null),
//            NewContactTextField(
//                lastNameTextController,
//                "Last Name",
//                TextInputType.text,
//                60.0,
//                pageState.onClientLastNameChanged,
//                NewJobPageState.NO_ERROR,
//                TextInputAction.done,
//                _lastNameFocus,
//                onLastNameAction,
//                TextCapitalization.words,
//                null),
//          ],
//        ),
//      ),
//    );
//  }
//
//  void onFirstNameAction(){
//    _firstNameFocus.unfocus();
//    FocusScope.of(context).requestFocus(_lastNameFocus);
//  }
//
//  void onLastNameAction(){
//    _lastNameFocus.unfocus();
//  }
//
//  @override
//  bool get wantKeepAlive => true;
//}
