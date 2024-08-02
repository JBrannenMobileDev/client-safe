import 'package:redux/redux.dart';
import 'BookingPageActions.dart';
import 'BookingPageState.dart';

final bookingPageReducer = combineReducers<BookingPageState>([
  TypedReducer<BookingPageState, SetBookingLinkAction>(_setBookingLink),
]);

BookingPageState _setBookingLink(BookingPageState previousState, SetBookingLinkAction action) {
  return previousState.copyWith(
      bookingLink: action.bookingLink,
  );
}