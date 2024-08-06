
import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/data_layer/local_db/daos/SessionTypeDao.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:redux/redux.dart';
import '../../models/SessionType.dart';
import 'BookingPageActions.dart';

class BookingPageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is InitializeStateAction) {
      initializeState(store, next, action);
    }
  }

  void initializeState(Store<AppState> store, NextDispatcher next, InitializeStateAction action) async{
    Profile? profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    if(profile != null) {
      store.dispatch(SetBookingLinkAction(store.state.bookingPageState, profile.getBookingLink()));
    }

    List<SessionType>? allSessionTypes = await SessionTypeDao.getAll();
    if(allSessionTypes != null) {
      store.dispatch(SetAllBookingSessionTypesAction(store.state.bookingPageState, allSessionTypes));
    }

    // List<Booking> bookings = await BookingsDao().getAll();
  }
}