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


