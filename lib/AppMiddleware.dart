
import 'package:client_safe/AppState.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createAppMiddleware() {
//  final initialLogIn = createInitLogInMiddleware();
//  final logIn = createLogInMiddleware();
//  final logOut = createLogOutMiddleware();
//  final createNewAccount = createNewAccountMiddleware();
//  final subscribeToHomePageCategories = subscribeToHomePageCategoriesMiddleware();
//  final disposeDataListeners = disposeDataListenersMiddleware();
//  final initAccountInfo = initAccountDetailsData();
//  final chatPageData = subscribeToDirectMessagesMiddleware();
//  final groupChatPageData = subscribeToGroupChatMessagesMiddleware();
//  final shareLeadPageData = initShareLeadData();
//  final shareLeadPageAgents = onAccountSelected();
//
  List<Middleware<AppState>> middlewareList = new List<Middleware<AppState>>();
//  middlewareList.add(new TypedMiddleware<AppState, OnLoginClickedAction>(logIn));
//  middlewareList.add(new TypedMiddleware<AppState, LogOutAction>(logOut));
//  middlewareList.add(new TypedMiddleware<AppState, InitLoginAction>(initialLogIn));
//  middlewareList.add(new TypedMiddleware<AppState, CreateNewUserAccountAction>(createNewAccount));
//  middlewareList.add(new TypedMiddleware<AppState, InitHomePageAction>(subscribeToHomePageCategories));
//  middlewareList.add(new TypedMiddleware<AppState, DisposeDataListenersActions>(disposeDataListeners));
//  middlewareList.add(new TypedMiddleware<AppState, InitAccountDetailsPageAction>(initAccountInfo));
//  middlewareList.add(new TypedMiddleware<AppState, InitChatPageAction>(chatPageData));
//  middlewareList.add(new TypedMiddleware<AppState, InitGroupChatPageAction>(groupChatPageData));
//  middlewareList.add(new TypedMiddleware<AppState, InitShareLeadPageAction>(shareLeadPageData));
//  middlewareList.add(new TypedMiddleware<AppState, OnAccountSelectedAction>(shareLeadPageAgents));
  return middlewareList;
}


