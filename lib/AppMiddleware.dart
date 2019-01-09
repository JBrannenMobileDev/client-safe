import 'package:clickfield/pages/account_details_page/AccountDetailsPageActions.dart';
import 'package:clickfield/pages/account_details_page/AccountDetailsPageMiddleware.dart';
import 'package:clickfield/pages/chat_page/ChatPageActions.dart';
import 'package:clickfield/pages/chat_page/ChatPageMiddleware.dart';
import 'package:clickfield/pages/chat_page/group_chat_page/GroupChatPageActions.dart';
import 'package:clickfield/pages/chat_page/group_chat_page/GroupChatPageMiddleware.dart';
import 'package:clickfield/pages/home_page/HomePageActions.dart';
import 'package:clickfield/pages/login_page/LoginPageActions.dart';
import 'package:clickfield/AppState.dart';
import 'package:clickfield/pages/share_lead_page/ShareLeadPageActions.dart';
import 'package:clickfield/pages/share_lead_page/ShareLeadPageMiddleware.dart';
import 'package:redux/redux.dart';
import 'package:clickfield/pages/login_page/LoginPageMiddleware.dart';
import 'package:clickfield/pages/home_page/HomePageMiddleware.dart';

List<Middleware<AppState>> createAppMiddleware() {
  final initialLogIn = createInitLogInMiddleware();
  final logIn = createLogInMiddleware();
  final logOut = createLogOutMiddleware();
  final createNewAccount = createNewAccountMiddleware();
  final subscribeToHomePageCategories = subscribeToHomePageCategoriesMiddleware();
  final disposeDataListeners = disposeDataListenersMiddleware();
  final initAccountInfo = initAccountDetailsData();
  final chatPageData = subscribeToDirectMessagesMiddleware();
  final groupChatPageData = subscribeToGroupChatMessagesMiddleware();
  final shareLeadPageData = initShareLeadData();
  final shareLeadPageAgents = onAccountSelected();

  List<Middleware<AppState>> middlewareList = new List<Middleware<AppState>>();
  middlewareList.add(new TypedMiddleware<AppState, OnLoginClickedAction>(logIn));
  middlewareList.add(new TypedMiddleware<AppState, LogOutAction>(logOut));
  middlewareList.add(new TypedMiddleware<AppState, InitLoginAction>(initialLogIn));
  middlewareList.add(new TypedMiddleware<AppState, CreateNewUserAccountAction>(createNewAccount));
  middlewareList.add(new TypedMiddleware<AppState, InitHomePageAction>(subscribeToHomePageCategories));
  middlewareList.add(new TypedMiddleware<AppState, DisposeDataListenersActions>(disposeDataListeners));
  middlewareList.add(new TypedMiddleware<AppState, InitAccountDetailsPageAction>(initAccountInfo));
  middlewareList.add(new TypedMiddleware<AppState, InitChatPageAction>(chatPageData));
  middlewareList.add(new TypedMiddleware<AppState, InitGroupChatPageAction>(groupChatPageData));
  middlewareList.add(new TypedMiddleware<AppState, InitShareLeadPageAction>(shareLeadPageData));
  middlewareList.add(new TypedMiddleware<AppState, OnAccountSelectedAction>(shareLeadPageAgents));
  return middlewareList;
}


