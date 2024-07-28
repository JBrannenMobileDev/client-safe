import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/Client.dart';
import 'package:dandylight/pages/new_contact_pages/NewContactPageActions.dart';
import 'package:dandylight/pages/new_contact_pages/NewContactPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:dandylight/utils/permissions/UserPermissionsUtil.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../utils/DandyToastUtil.dart';
import '../../utils/Shadows.dart';
import '../../widgets/TextDandyLight.dart';
import '../../widgets/TextFieldSimple.dart';
import 'ImportDeviceContactBottomSheet.dart';
import 'SelectLeadSourceBottomSheet.dart';

class NewContactPage extends StatefulWidget {
  final Client? client;

  NewContactPage({this.client});

  @override
  _NewContactPageState createState() {
    return _NewContactPageState(client);
  }
}

class _NewContactPageState extends State<NewContactPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final instagramUrlController = TextEditingController();
  final firstNameFocusNode = FocusNode();
  final lastNameFocusNode = FocusNode();
  final phoneFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final instagramUrlFocusNode = FocusNode();
  final Client? client;
  bool isEdit = false;
  bool isTyping = false;

  _NewContactPageState(this.client);

  bool clientError = false;
  bool firstNameError = false;
  bool leadSourceError = false;


  @override
  void initState() {
    super.initState();
    firstNameFocusNode.addListener(() {
      setIsTyping(firstNameFocusNode.hasFocus);
    });
    lastNameFocusNode.addListener(() {
      setIsTyping(lastNameFocusNode.hasFocus);
    });
    phoneFocusNode.addListener(() {
      setIsTyping(phoneFocusNode.hasFocus);
    });
    emailFocusNode.addListener(() {
      setIsTyping(emailFocusNode.hasFocus);
    });
    instagramUrlFocusNode.addListener(() {
      setIsTyping(instagramUrlFocusNode.hasFocus);
    });
  }

  void setIsTyping(bool hasFocus) {
    isTyping = hasFocus;
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, NewContactPageState>(
      onInit: (store) async{
        store.dispatch(ClearStateAction(store.state.newContactPageState));
        if(client != null) {
          isEdit = true;
          store.dispatch(LoadExistingClientData(store.state.newContactPageState, client));
          firstNameController.text = client?.firstName ?? 'NA';
          lastNameController.text = client?.lastName ?? 'NA';
          phoneController.text = client?.phone ?? 'NA';
          emailController.text = client?.email ?? 'NA';
          instagramUrlController.text = client?.instagramProfileUrl ?? 'NA';
        }
      },
      onDidChange: (previous, current) {
        if(current.newContactFirstName != firstNameController.text && current.newContactFirstName != (previous?.newContactFirstName ?? '')) firstNameController.text = current.newContactFirstName ?? '';
        if(current.newContactLastName != lastNameController.text && current.newContactLastName != (previous?.newContactLastName ?? '')) lastNameController.text = current.newContactLastName ?? '';
        if(current.newContactPhone != phoneController.text && current.newContactPhone != (previous?.newContactPhone ?? '')) phoneController.text = current.newContactPhone ?? '';
        if(current.newContactEmail != emailController.text && current.newContactEmail != (previous?.newContactEmail ?? '')) emailController.text = current.newContactEmail ?? '';
      },
      converter: (store) => NewContactPageState.fromStore(store),
      builder: (BuildContext context, NewContactPageState pageState) =>
          WillPopScope(
          onWillPop: () async {
            final shouldPop = await showDialog<bool>(
              context: context,
              builder: (context) => new CupertinoAlertDialog(
                title: new Text('Are you sure?'),
                content: new Text('All unsaved information entered will be lost.'),
                actions: <Widget>[
                  TextButton(
                    style: Styles.getButtonStyle(),
                    onPressed: () => Navigator.of(context).pop(false),
                    child: new Text('No'),
                  ),
                  TextButton(
                    style: Styles.getButtonStyle(),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: new Text('Yes'),
                  ),
                ],
              ),
            );
            return shouldPop!;
          },
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: Color(ColorConstants.getPrimaryWhite()),
            body: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
              CustomScrollView(
              slivers: [
              SliverAppBar(
              automaticallyImplyLeading: false,
                backgroundColor: Color(ColorConstants.getPrimaryWhite()),
                pinned: true,
                centerTitle: true,
                surfaceTintColor: Colors.transparent,
                title: TextDandyLight(
                  type: TextDandyLight.LARGE_TEXT,
                  text: client != null ? 'Edit Contact' : 'New Contact',
                  color: Color(ColorConstants.getPrimaryBlack()),
                ),
                systemOverlayStyle: SystemUiOverlayStyle.dark,
                leading: GestureDetector(
                  child: const Icon(Icons.close, color: Colors.black),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  <Widget>[
                    pageState.client == null ? GestureDetector(
                      onTap: () async {
                        bool isGranted = await UserPermissionsUtil.showPermissionRequest(
                          permission: Permission.contacts,
                          context: context,
                          callOnGranted: () {},
                        );
                        if(isGranted) {
                          _showSelectDeviceContactBottomSheet(context);
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 8),
                        alignment: Alignment.center,
                        height: 54,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: clientError ? const Color(ColorConstants.error_red) : Color(ColorConstants.getPrimaryGreyLight()).withOpacity(0.5),
                              width: clientError ? 2 : 0
                          ),
                          color: Color(ColorConstants.getPrimaryGreyDark()),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 16),
                              child: TextDandyLight(
                                type: TextDandyLight.SMALL_TEXT,
                                text: 'Import device contact',
                                color: Color(ColorConstants.getPrimaryWhite()),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 8.0),
                              child: Icon(
                                Icons.chevron_right,
                                color: Color(ColorConstants.getPrimaryWhite()),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ) : const SizedBox(),
                    pageState.client == null ? Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(top: 16),
                      child: TextDandyLight(
                        type: TextDandyLight.SMALL_TEXT,
                        text: 'OR',
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                    ) : const SizedBox(),
                    pageState.client == null || isEdit ? clientInfoItems(pageState) : const SizedBox(),
                  ],
                ),
              ),
              ],
            ),
            !isTyping ? GestureDetector(
                    onTap: () {
                      setState(() {
                        if((pageState.leadSource?.isEmpty ?? true) && pageState.client == null) {
                          leadSourceError = true;
                        } else {
                          leadSourceError = false;
                        }
                        if(pageState.client == null && (pageState.newContactFirstName?.isEmpty ?? true)) {
                          firstNameError = true;
                          clientError = true;
                        } else {
                          firstNameError = false;
                          clientError = false;
                        }
                      });
                      if(!clientError && !firstNameError && !leadSourceError) {
                        pageState.onSavePressed!();
                        showSuccessAnimation();
                      } else {
                        if(clientError) DandyToastUtil.showErrorToast('Missing client info');
                        else if(firstNameError) DandyToastUtil.showErrorToast('Missing client first name');
                        else if(leadSourceError) DandyToastUtil.showErrorToast('Missing client lead source');
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 32),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width/2,
                      height: 54,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(27),
                        color: Color(ColorConstants.getPeachDark()),
                        boxShadow: ElevationToShadow[4],
                      ),
                      child: TextDandyLight(
                        type: TextDandyLight.LARGE_TEXT,
                        text: 'Save',
                        color: Color(ColorConstants.getPrimaryWhite()),
                      ),
                    ),
                  ) : const SizedBox(),
            ],
        ),
      ),
    ),),);
  }

  void _showSelectDeviceContactBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
      builder: (context) {
        return const ImportDeviceContactBottomSheet();
      },
    );
  }

  void _showLeadSelectionBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
      builder: (context) {
        return const SelectLeadSourceBottomSheet();
      },
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

  void onFlareCompleted(String unused) async{
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    UserOptionsUtil.showJobPromptDialog(context);
  }

  Widget clientInfoItems(NewContactPageState pageState) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(top: 24),
        child: TextDandyLight(
          type: TextDandyLight.SMALL_TEXT,
          text: 'Contact Info',
          color: Color(ColorConstants.getPrimaryBlack()),
        ),
      ),
      Container(
        margin: const EdgeInsets.only(left: 8, top: 8),
        child: TextDandyLight(
          type: TextDandyLight.EXTRA_SMALL_TEXT,
          text: 'FIRST NAME*',
          color: Color(ColorConstants.getPrimaryGreyDark()),
        ),
      ),
      TextFieldSimple(
        controller: firstNameController,
        hintText: 'First name',
        inputType: TextInputType.name,
        focusNode: firstNameFocusNode,
        hasError: firstNameError,
        onFocusAction: (){
          FocusScope.of(context).requestFocus(lastNameFocusNode);
        },
        onTextInputChanged: pageState.onClientFirstNameChanged!,
        keyboardAction: TextInputAction.next,
        capitalization: TextCapitalization.words,
      ),
      Container(
        margin: const EdgeInsets.only(left: 8, top: 8),
        child: TextDandyLight(
          type: TextDandyLight.EXTRA_SMALL_TEXT,
          text: 'LAST NAME',
          color: Color(ColorConstants.getPrimaryGreyDark()),
        ),
      ),
      TextFieldSimple(
        controller: lastNameController,
        hintText: 'Last name',
        inputType: TextInputType.name,
        focusNode: lastNameFocusNode,
        hasError: false,
        onFocusAction: (){
          FocusScope.of(context).requestFocus(phoneFocusNode);
        },
        onTextInputChanged: pageState.onClientLastNameChanged!,
        keyboardAction: TextInputAction.next,
        capitalization: TextCapitalization.words,
      ),
      Container(
        margin: const EdgeInsets.only(left: 8, top: 8),
        child: TextDandyLight(
          type: TextDandyLight.EXTRA_SMALL_TEXT,
          text: 'PHONE NUMBER',
          color: Color(ColorConstants.getPrimaryGreyDark()),
        ),
      ),
      TextFieldSimple(
        controller: phoneController,
        hintText: '(888) 888-8888',
        inputType: TextInputType.phone,
        focusNode: phoneFocusNode,
        hasError: false,
        onFocusAction: (){
          FocusScope.of(context).requestFocus(emailFocusNode);
        },
        onTextInputChanged: pageState.onPhoneTextChanged!,
        keyboardAction: TextInputAction.next,
        capitalization: TextCapitalization.none,
      ),
      Container(
        margin: const EdgeInsets.only(left: 8, top: 8),
        child: TextDandyLight(
          type: TextDandyLight.EXTRA_SMALL_TEXT,
          text: 'EMAIL ADDRESS',
          color: Color(ColorConstants.getPrimaryGreyDark()),
        ),
      ),
      TextFieldSimple(
        controller: emailController,
        hintText: 'exampleemail@gmail.com',
        inputType: TextInputType.emailAddress,
        focusNode: emailFocusNode,
        hasError: false,
        onFocusAction: (){
          FocusScope.of(context).requestFocus(instagramUrlFocusNode);
        },
        onTextInputChanged: pageState.onEmailTextChanged!,
        keyboardAction: TextInputAction.next,
        capitalization: TextCapitalization.none,
      ),
      Container(
        margin: const EdgeInsets.only(left: 8, top: 8),
        child: TextDandyLight(
          type: TextDandyLight.EXTRA_SMALL_TEXT,
          text: 'INSTAGRAM PROFILE URL',
          color: Color(ColorConstants.getPrimaryGreyDark()),
        ),
      ),
      TextFieldSimple(
        controller: instagramUrlController,
        hintText: 'https://instagram.com/profileName...',
        inputType: TextInputType.url,
        focusNode: instagramUrlFocusNode,
        hasError: false,
        onFocusAction: (){
          FocusScope.of(context).unfocus();
        },
        onTextInputChanged: pageState.onInstagramUrlChanged!,
        keyboardAction: TextInputAction.done,
        capitalization: TextCapitalization.none,
      ),
      Container(
        margin: const EdgeInsets.only(left: 8, top: 8),
        child: TextDandyLight(
          type: TextDandyLight.EXTRA_SMALL_TEXT,
          text: 'LEAD SOURCE*',
          color: Color(ColorConstants.getPrimaryGreyDark()),
        ),
      ),
      Container(
        margin: const EdgeInsets.only(left: 8, top: 0),
        child: TextDandyLight(
          type: TextDandyLight.SMALL_TEXT,
          text: 'How did ${(pageState.newContactFirstName?.isNotEmpty ?? false) ? pageState.newContactFirstName : 'this client'} hear about your business?',
          color: Color(ColorConstants.getPrimaryBlack()),
        ),
      ),
      GestureDetector(
        onTap: () {
          _showLeadSelectionBottomSheet(context);
        },
        child: Container(
          margin: const EdgeInsets.only(top: 8, bottom: 16),
          alignment: Alignment.center,
          height: 54,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: leadSourceError ? const Color(ColorConstants.error_red) : Color(ColorConstants.getPrimaryGreyDark()),
                width: leadSourceError ? 2 : 0
            ),
            color: Color(ColorConstants.getPrimaryGreyDark()),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 16),
                child: TextDandyLight(
                  type: TextDandyLight.SMALL_TEXT,
                  text: getLeadSourceName(pageState),
                  color: Color(ColorConstants.getPrimaryWhite()),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 8.0),
                child: Icon(
                  Icons.chevron_right,
                  color: Color(ColorConstants.getPrimaryWhite()),
                ),
              ),
            ],
          ),
        ),
      )
    ],
  );

  String getLeadSourceName(NewContactPageState pageState) {
    String result = '';
    if(pageState.leadSource?.isNotEmpty ?? false) {
      if(pageState.leadSource == 'Other') {
        result = pageState.customLeadSourceName ?? '';
      } else {
        result = pageState.leadSource ?? '';
      }
    } else {
      result = 'Select a source';
    }
    return result;
  }
}


