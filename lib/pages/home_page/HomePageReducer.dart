import 'package:client_safe/pages/home_page/HomePageActions.dart';
import 'package:client_safe/pages/home_page/HomePageState.dart';
import 'package:redux/redux.dart';

final homePageReducer = combineReducers<HomePageState>([
  new TypedReducer<HomePageState, InitHomePageAction>(_setupDataListeners),
  new TypedReducer<HomePageState, DisposeDataListenersActions>(_disposeDataListeners),
  new TypedReducer<HomePageState, UpdateCurrentUserInfo>(_updateCurrentUserInfo),
]);

HomePageState _setupDataListeners(HomePageState previousState,
    InitHomePageAction action) {
  int newCount = 0;
  previousState.recentItems.forEach((recentItem){
    if(recentItem.isNewMessage)newCount++;
  });
  return HomePageState(
    previousState.recentActivityExpandable,
    previousState.accountsExpandable,
    previousState.directMessagesExpandable,
    previousState.sharedLeadsExpandable,
    previousState.recentItems,
    previousState.accountItems,
    previousState.directItems,
    previousState.sharedLeadItems,
    previousState.onViewAllRecentsClicked,
    newCount,
    previousState.showAllRecentItems,
    previousState.flexibleSpaceHeight,
    previousState.showAllAccountItems,
    previousState.showAllDirectItems,
    previousState.showAllSharedLeadItems,
    previousState.onViewAllAccountsClicked,
    previousState.onViewAllDirectMessagesClicked,
    previousState.onViewAllSharedLeadsClicked,
    previousState.onViewRecentItemClicked,
    previousState.onViewAccountItemClicked,
    previousState.onViewDirectChatClicked,
    previousState.onViewSharedLeadChatClicked,
    previousState.userName,
    previousState.userEmail,
    previousState.userColorId,
  );
}

HomePageState _updateCurrentUserInfo(HomePageState previousState,
    UpdateCurrentUserInfo action) {
  return HomePageState(
    previousState.recentActivityExpandable,
    previousState.accountsExpandable,
    previousState.directMessagesExpandable,
    previousState.sharedLeadsExpandable,
    previousState.recentItems,
    previousState.accountItems,
    previousState.directItems,
    previousState.sharedLeadItems,
    previousState.onViewAllRecentsClicked,
    previousState.newRecentItemsCount,
    previousState.showAllRecentItems,
    previousState.flexibleSpaceHeight,
    previousState.showAllAccountItems,
    previousState.showAllDirectItems,
    previousState.showAllSharedLeadItems,
    previousState.onViewAllAccountsClicked,
    previousState.onViewAllDirectMessagesClicked,
    previousState.onViewAllSharedLeadsClicked,
    previousState.onViewRecentItemClicked,
    previousState.onViewAccountItemClicked,
    previousState.onViewDirectChatClicked,
    previousState.onViewSharedLeadChatClicked,
    action.name,
    action.email,
    action.userColorId,
  );
}

HomePageState _disposeDataListeners(HomePageState previousState, DisposeDataListenersActions action) {
  return HomePageState(
    previousState.recentActivityExpandable,
    previousState.accountsExpandable,
    previousState.directMessagesExpandable,
    previousState.sharedLeadsExpandable,
    previousState.recentItems,
    previousState.accountItems,
    previousState.directItems,
    previousState.sharedLeadItems,
    previousState.onViewAllRecentsClicked,
    previousState.newRecentItemsCount,
    previousState.showAllRecentItems,
    previousState.flexibleSpaceHeight,
    previousState.showAllAccountItems,
    previousState.showAllDirectItems,
    previousState.showAllSharedLeadItems,
    previousState.onViewAllAccountsClicked,
    previousState.onViewAllDirectMessagesClicked,
    previousState.onViewAllSharedLeadsClicked,
    previousState.onViewRecentItemClicked,
    previousState.onViewAccountItemClicked,
    previousState.onViewDirectChatClicked,
    previousState.onViewSharedLeadChatClicked,
    previousState.userName,
    previousState.userEmail,
    previousState.userColorId,
  );
}
