import 'package:clickfield/AppState.dart';
import 'package:clickfield/pages/login_page/LoginPageReducer.dart';
import 'package:clickfield/pages/home_page/HomePageReducer.dart';
import 'package:clickfield/pages/account_details_page/AccountDetailsPageReducer.dart';
import 'package:clickfield/pages/chat_page/ChatPageReducer.dart';
import 'package:clickfield/pages/chat_page/group_chat_page/GroupChatPageReducer.dart';
import 'package:clickfield/pages/share_lead_page/ShareLeadPageReducer.dart';

AppState appReducers(AppState state, action) {
  final loginReducer = loginPageReducer(state.loginPageState, action);
  final homeReducer = homePageReducer(state.homePageState, action);
  final accountDetailsReducer = accountDetailsPageReducer(state.accountDetailsState, action);
  final chatReducer = chatPageReducer(state.chatPageState, action);
  final groupChatReducer = groupChatPageReducer(state.groupChatPageState, action);
  final shareLeadReducer = shareLeadPageReducer(state.shareLeadPageState, action);
  return new AppState(loginReducer, homeReducer, accountDetailsReducer, chatReducer, groupChatReducer, shareLeadReducer);
}
