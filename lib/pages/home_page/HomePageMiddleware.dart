import 'dart:async';
import 'package:redux/redux.dart';

//  sharedItems.forEach((sharedItem){
//List<StreamSubscription<Event>> subscriptions;
//
//Middleware<AppState> subscribeToHomePageCategoriesMiddleware() {
//  return (Store<AppState> store, action, NextDispatcher next) async {
//    if (action is InitHomePageAction) {
//      DatabaseManager dbManager = new DatabaseManager();
//      if (subscriptions == null) subscriptions = new List();
//      StreamSubscription<Event> tempSubscription = dbManager
//          .getCurrentUserSubscription();
//      subscriptions.add(tempSubscription);
//      tempSubscription.onData((Event event) async {
//        if (event.snapshot.value != null) {
//          List<Future<dynamic>> futures = [];
//          _fetchAccounts(event.snapshot.value[StringConstants.user_key_account_ids], dbManager, store);
//          futures.add(_fetchDirectChats(event.snapshot.value[StringConstants.user_key_direct_chats], dbManager, store));
//          futures.add(_fetchSharedLeads(event.snapshot.value[StringConstants.user_key_shared_leads], dbManager, store));
//          await Future.wait(futures).then((listOfListsToFilter)async {
//            List<DirectItem> directItems = new List();
//            List<SharedLeadItem> sharedItems = new List();
//            listOfListsToFilter.forEach((listToFilter){
//              if(listToFilter is List<dynamic>) {
//                listToFilter.forEach((filterItem){
//                  if (filterItem is DirectItem) directItems.add(filterItem);
//                  if (filterItem is SharedLeadItem) sharedItems.add(filterItem);
//                });
//              }
//            });
//            await _createRecentItems(directItems, sharedItems, dbManager, store);
//          });
//        }
//        store.dispatch(new UpdateCurrentUserInfo(
//            event.snapshot.value[StringConstants.user_key_first_name].toString() + event.snapshot.value[StringConstants.user_key_last_name].toString(),
//            event.snapshot.value[StringConstants.user_key_email],
//            event.snapshot.value[StringConstants.user_key_user_color],
//            store.state.homePageState));
//      });
//    }
//    next(action);
//  };
//}
//
//    recentItems.add(new RecentItem.fromSharedLeadItem(sharedItem));
//  });
//
//  _filterMostRecentItems(recentItems, dbManager, store);
//}
//}
