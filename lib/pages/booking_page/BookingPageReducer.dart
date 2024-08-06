import 'package:redux/redux.dart';
import 'BookingPageActions.dart';
import 'BookingPageState.dart';

final bookingPageReducer = combineReducers<BookingPageState>([
  TypedReducer<BookingPageState, SetBookingLinkAction>(_setBookingLink),
  TypedReducer<BookingPageState, SetOfferingDescriptionAction>(_setDescription),
  TypedReducer<BookingPageState, SetSelectedSessionTypeAction>(_setSelectedSession),
  TypedReducer<BookingPageState, UpdateBookingPageWithNewSessionTypeAction>(_setUpdatedWithSelectedSession),
  TypedReducer<BookingPageState, SetAllBookingSessionTypesAction>(_setSessionTypes),
  TypedReducer<BookingPageState, SetBookByInquirySelectionAction>(_setInquirySelection),
  TypedReducer<BookingPageState, SetInstantBookingSelectionAction>(_setInstantBookingSelection),
  TypedReducer<BookingPageState, SetRequireDepositSelectionAction>(_setRequiredSelection),
]);

BookingPageState _setRequiredSelection(BookingPageState previousState, SetRequireDepositSelectionAction action) {
  return previousState.copyWith(
    requireDeposit: (previousState.instantBooking ?? false) ? action.selected : false,
  );
}

BookingPageState _setInstantBookingSelection(BookingPageState previousState, SetInstantBookingSelectionAction action) {
  return previousState.copyWith(
    instantBooking: action.selected,
    requireDeposit: !(action.selected ?? false) ? false : previousState.requireDeposit,
  );
}

BookingPageState _setInquirySelection(BookingPageState previousState, SetBookByInquirySelectionAction action) {
  return previousState.copyWith(
    bookByInquiry: action.selected,
  );
}

BookingPageState _setSessionTypes(BookingPageState previousState, SetAllBookingSessionTypesAction action) {
  return previousState.copyWith(
    sessionTypes: action.sessionTypes,
  );
}

BookingPageState _setUpdatedWithSelectedSession(BookingPageState previousState, UpdateBookingPageWithNewSessionTypeAction action) {
  return previousState.copyWith(
    selectedSessionType: action.sessionType,
  );
}

BookingPageState _setSelectedSession(BookingPageState previousState, SetSelectedSessionTypeAction action) {
  return previousState.copyWith(
    selectedSessionType: action.sessionType,
  );
}

BookingPageState _setDescription(BookingPageState previousState, SetOfferingDescriptionAction action) {
  return previousState.copyWith(
    newOfferingDescription: action.description,
  );
}

BookingPageState _setBookingLink(BookingPageState previousState, SetBookingLinkAction action) {
  return previousState.copyWith(
      bookingLink: action.bookingLink,
  );
}