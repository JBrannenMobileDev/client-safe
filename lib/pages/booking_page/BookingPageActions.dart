import '../../models/SessionType.dart';
import 'BookingPageState.dart';

class InitializeStateAction{
  final BookingPageState? pageState;
  InitializeStateAction(this.pageState);
}

class SetBookingLinkAction {
  final BookingPageState? pageState;
  final String bookingLink;
  SetBookingLinkAction(this.pageState, this.bookingLink);
}

class SetOfferingDescriptionAction {
  final BookingPageState? pageState;
  final String? description;
  SetOfferingDescriptionAction(this.pageState, this.description);
}

class SetSelectedSessionTypeAction {
  final BookingPageState? pageState;
  final SessionType? sessionType;
  SetSelectedSessionTypeAction(this.pageState, this.sessionType);
}

class UpdateBookingPageWithNewSessionTypeAction {
  final BookingPageState? pageState;
  final SessionType? sessionType;
  UpdateBookingPageWithNewSessionTypeAction(this.pageState, this.sessionType);
}

class SetAllBookingSessionTypesAction {
  final BookingPageState? pageState;
  final List<SessionType>? sessionTypes;
  SetAllBookingSessionTypesAction(this.pageState, this.sessionTypes);
}

class SetBookByInquirySelectionAction {
  final BookingPageState? pageState;
  final bool? selected;
  SetBookByInquirySelectionAction(this.pageState, this.selected);
}

class SetInstantBookingSelectionAction {
  final BookingPageState? pageState;
  final bool? selected;
  SetInstantBookingSelectionAction(this.pageState, this.selected);
}

class SetRequireDepositSelectionAction {
  final BookingPageState? pageState;
  final bool? selected;
  SetRequireDepositSelectionAction(this.pageState, this.selected);
}


