import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';
import 'PaymentRequestInfoPageActions.dart';

class PaymentRequestInfoPageState{
  final bool zelleEnabled;
  final bool venmoEnabled;
  final bool cashAppEnabled;
  final bool applePayEnabled;
  final bool cashEnabled;
  final bool otherEnabled;
  final bool wireEnabled;
  final String zellePhoneEmail;
  final String zelleFullName;
  final String venmoLink;
  final String cashMessage;
  final String cashAppLink;
  final String applePayPhone;
  final String otherMessage;
  final String wireMessage;
  final Function(bool) onOtherSelected;
  final Function(String) onOtherMessageChanged;
  final Function(bool) onWireSelected;
  final Function(String) onWireMessageChanged;
  final Function(bool) onZelleSelected;
  final Function(String) onZelleTextPhoneEmailChanged;
  final Function(String) onZelleTextFullNameChanged;
  final Function(bool) onVenmoSelected;
  final Function(String) onVenmoTextChanged;
  final Function(bool) onCashAppSelected;
  final Function(String) onCashAppTextChanged;
  final Function(bool) onApplePaySelected;
  final Function(String) onApplePayTextChanged;
  final Function(bool) onCashSelected;
  final Function(String) onCashMessageChanged;
  final Function() onZellePhoneEmailInputDone;
  final Function() onZelleFullNameInputDone;
  final Function() onVenmoInputDone;
  final Function() onCashAppInputDone;
  final Function() onApplePayInputDone;
  final Function() onOtherInputDone;
  final Function() onWireInputDone;
  final Function() onCashInputDone;

  PaymentRequestInfoPageState({
    @required this.zelleEnabled,
    @required this.venmoEnabled,
    @required this.cashAppEnabled,
    @required this.applePayEnabled,
    @required this.onZelleSelected,
    @required this.onVenmoSelected,
    @required this.onCashAppSelected,
    @required this.onApplePaySelected,
    @required this.onZelleTextPhoneEmailChanged,
    @required this.onZelleTextFullNameChanged,
    @required this.onVenmoTextChanged,
    @required this.onCashAppTextChanged,
    @required this.onApplePayTextChanged,
    @required this.zellePhoneEmail,
    @required this.zelleFullName,
    @required this.venmoLink,
    @required this.cashAppLink,
    @required this.applePayPhone,
    @required this.onZelleFullNameInputDone,
    @required this.onZellePhoneEmailInputDone,
    @required this.onVenmoInputDone,
    @required this.onCashAppInputDone,
    @required this.onApplePayInputDone,
    @required this.cashEnabled,
    @required this.onCashSelected,
    @required this.otherEnabled,
    @required this.onOtherMessageChanged,
    @required this.onOtherSelected,
    @required this.otherMessage,
    @required this.onOtherInputDone,
    @required this.onWireInputDone,
    @required this.onWireMessageChanged,
    @required this.onWireSelected,
    @required this.wireEnabled,
    @required this.wireMessage,
    @required this.onCashMessageChanged,
    @required this.onCashInputDone,
    @required this.cashMessage,
  });

  PaymentRequestInfoPageState copyWith({
    bool zelleEnabled,
    bool venmoEnabled,
    bool cashAppEnabled,
    bool applePayEnabled,
    bool cashEnabled,
    bool otherEnabled,
    bool wireEnabled,
    String zellePhoneEmail,
    String zelleFullName,
    String venmoLink,
    String cashAppLink,
    String applePayPhone,
    String otherMessage,
    String wireMessage,
    String cashMessage,
    Function() onSignOutSelected,
    Function(bool) onZelleSelected,
    Function(String) onZelleTextPhoneEmailChanged,
    Function(String) onZelleTextFullNameChanged,
    Function(bool) onVenmoSelected,
    Function(String) onVenmoTextChanged,
    Function(bool) onCashAppSelected,
    Function(String) onCashAppTextChanged,
    Function(bool) onApplePaySelected,
    Function(String) onApplePayTextChanged,
    Function(bool) onCashSelected,
    Function() onZellePhoneEmailInputDone,
    Function() onZelleFullNameInputDone,
    Function() onVenmoInputDone,
    Function() onCashAppInputDone,
    Function() onApplePayInputDone,
    Function(bool) onOtherSelected,
    Function(String) onOtherMessageChanged,
    Function() onOtherInputDone,
    Function(bool) onWireSelected,
    Function(String) onWireMessageChanged,
    Function() onWireInputDone,
    Function(String) onCashMessageChanged,
    Function() onCashInputDone,
  }){
    return PaymentRequestInfoPageState(
      zelleEnabled: zelleEnabled ?? this.zelleEnabled,
      venmoEnabled: venmoEnabled ?? this.venmoEnabled,
      cashAppEnabled: cashAppEnabled ?? this.cashAppEnabled,
      applePayEnabled: applePayEnabled ?? this.applePayEnabled,
      onCashAppSelected: onCashAppSelected ?? this.onCashAppSelected,
      onApplePaySelected: onApplePaySelected ?? this.onApplePaySelected,
      onZelleSelected: onZelleSelected ?? this.onZelleSelected,
      onVenmoSelected: onVenmoSelected ?? this.onVenmoSelected,
      onZelleTextPhoneEmailChanged: onZelleTextPhoneEmailChanged ?? this.onZelleTextPhoneEmailChanged,
      onZelleTextFullNameChanged: onZelleTextFullNameChanged ?? this.onZelleTextFullNameChanged,
      onVenmoTextChanged: onVenmoTextChanged ?? this.onVenmoTextChanged,
      onCashAppTextChanged: onCashAppTextChanged ?? this.onCashAppTextChanged,
      onApplePayTextChanged: onApplePayTextChanged ?? this.onApplePayTextChanged,
      zelleFullName: zelleFullName ?? this.zelleFullName,
      zellePhoneEmail: zellePhoneEmail ?? this.zellePhoneEmail,
      venmoLink: venmoLink ?? this.venmoLink,
      cashAppLink: cashAppLink ?? this.cashAppLink,
      applePayPhone: applePayPhone ?? this.applePayPhone,
      onZelleFullNameInputDone: onZelleFullNameInputDone ?? this.onZelleFullNameInputDone,
      onZellePhoneEmailInputDone: onZellePhoneEmailInputDone ?? this.onZellePhoneEmailInputDone,
      onVenmoInputDone: onVenmoInputDone ?? this.onVenmoInputDone,
      onCashAppInputDone: onCashAppInputDone ?? this.onCashAppInputDone,
      onApplePayInputDone: onApplePayInputDone ?? this.onApplePayInputDone,
      cashEnabled: cashEnabled ?? this.cashEnabled,
      onCashSelected: onCashSelected ?? this.onCashSelected,
      otherEnabled: otherEnabled ?? this.otherEnabled,
      onOtherMessageChanged: onOtherMessageChanged ?? this.onOtherMessageChanged,
      onOtherSelected: onOtherSelected ?? this.onOtherSelected,
      otherMessage: otherMessage ?? this.otherMessage,
      onOtherInputDone: onOtherInputDone ?? this.onOtherInputDone,
      wireEnabled: wireEnabled ?? this.wireEnabled,
      wireMessage: wireMessage ?? this.wireMessage,
      onWireInputDone: onWireInputDone ?? this.onWireInputDone,
      onWireMessageChanged: onWireMessageChanged ?? this.onWireMessageChanged,
      onWireSelected: onWireSelected ?? this.onWireSelected,
      onCashInputDone: onCashInputDone ?? this.onCashInputDone,
      onCashMessageChanged: onCashMessageChanged ?? this.onCashMessageChanged,
      cashMessage: cashMessage ?? this.cashMessage,
    );
  }

  factory PaymentRequestInfoPageState.initial() => PaymentRequestInfoPageState(
    onZelleSelected: null,
    onVenmoSelected: null,
    onCashAppSelected: null,
    onApplePaySelected: null,
    zelleEnabled: false,
    venmoEnabled: false,
    cashAppEnabled: false,
    applePayEnabled: false,
    onZelleTextPhoneEmailChanged: null,
    onZelleTextFullNameChanged: null,
    onVenmoTextChanged: null,
    onCashAppTextChanged: null,
    onApplePayTextChanged: null,
    zellePhoneEmail: '',
    zelleFullName: '',
    venmoLink: '',
    cashAppLink: '',
    applePayPhone: '',
    onZellePhoneEmailInputDone: null,
    onZelleFullNameInputDone: null,
    onVenmoInputDone: null,
    onCashAppInputDone: null,
    onApplePayInputDone: null,
    cashEnabled: false,
    onCashSelected: null,
    onOtherSelected: null,
    onOtherMessageChanged: null,
    otherEnabled: false,
    otherMessage: '',
    onOtherInputDone: null,
    onWireSelected: null,
    onWireMessageChanged: null,
    wireEnabled: false,
    wireMessage: '',
    onWireInputDone: null,
    onCashMessageChanged: null,
    onCashInputDone: null,
    cashMessage: '',
  );

  factory PaymentRequestInfoPageState.fromStore(Store<AppState> store) {
    return PaymentRequestInfoPageState(
      zelleEnabled: store.state.paymentRequestInfoPageState.zelleEnabled,
      venmoEnabled: store.state.paymentRequestInfoPageState.venmoEnabled,
      cashAppEnabled: store.state.paymentRequestInfoPageState.cashAppEnabled,
      applePayEnabled: store.state.paymentRequestInfoPageState.applePayEnabled,
      zelleFullName: store.state.paymentRequestInfoPageState.zelleFullName,
      zellePhoneEmail: store.state.paymentRequestInfoPageState.zellePhoneEmail,
      venmoLink: store.state.paymentRequestInfoPageState.venmoLink,
      cashAppLink: store.state.paymentRequestInfoPageState.cashAppLink,
      applePayPhone: store.state.paymentRequestInfoPageState.applePayPhone,
      cashEnabled: store.state.paymentRequestInfoPageState.cashEnabled,
      otherEnabled: store.state.paymentRequestInfoPageState.otherEnabled,
      otherMessage: store.state.paymentRequestInfoPageState.otherMessage,
      wireEnabled: store.state.paymentRequestInfoPageState.wireEnabled,
      wireMessage: store.state.paymentRequestInfoPageState.wireMessage,
      cashMessage: store.state.paymentRequestInfoPageState.cashMessage,
      onZelleSelected: (enabled) {
        store.dispatch(UpdateProfileWithZelleStateAction(store.state.paymentRequestInfoPageState, enabled));
        store.dispatch(SaveZelleStateAction(store.state.paymentRequestInfoPageState, enabled));
      },
      onVenmoSelected: (enabled) {
        store.dispatch(UpdateProfileWithVenmoStateAction(store.state.paymentRequestInfoPageState, enabled));
        store.dispatch(SaveVenmoStateAction(store.state.paymentRequestInfoPageState, enabled));
      },
      onCashAppSelected: (enabled) {
        store.dispatch(UpdateProfileWithCashAppStateAction(store.state.paymentRequestInfoPageState, enabled));
        store.dispatch(SaveCashAppStateAction(store.state.paymentRequestInfoPageState, enabled));
      },
      onApplePaySelected: (enabled) {
        store.dispatch(UpdateProfileWithApplePayStateAction(store.state.paymentRequestInfoPageState, enabled));
        store.dispatch(SaveApplePayStateAction(store.state.paymentRequestInfoPageState, enabled));
      },
      onCashSelected: (enabled) {
        store.dispatch(UpdateProfileWithCashStateAction(store.state.paymentRequestInfoPageState, enabled));
        store.dispatch(SaveCashStateAction(store.state.paymentRequestInfoPageState, enabled));
      },
      onOtherSelected: (enabled) {
        store.dispatch(UpdateProfileWithOtherStateAction(store.state.paymentRequestInfoPageState, enabled));
        store.dispatch(SaveOtherStateAction(store.state.paymentRequestInfoPageState, enabled));
      },
      onWireSelected: (enabled) {
        store.dispatch(UpdateProfileWithWireStateAction(store.state.paymentRequestInfoPageState, enabled));
        store.dispatch(SaveWireStateAction(store.state.paymentRequestInfoPageState, enabled));
      },
      onZelleTextPhoneEmailChanged: (input) => store.dispatch(SetZellePhoneEmailTextAction(store.state.paymentRequestInfoPageState, input)),
      onZelleTextFullNameChanged: (input) => store.dispatch(SetZelleFullNameTextAction(store.state.paymentRequestInfoPageState, input)),
      onVenmoTextChanged: (input) => store.dispatch(SetVenmoLinkTextAction(store.state.paymentRequestInfoPageState, input)),
      onCashAppTextChanged: (input) => store.dispatch(SetCashAppLinkTextAction(store.state.paymentRequestInfoPageState, input)),
      onApplePayTextChanged: (input) => store.dispatch(SetApplePayPhoneTextAction(store.state.paymentRequestInfoPageState, input)),
      onZellePhoneEmailInputDone: () => store.dispatch(SaveZellePhoneEmailInput(store.state.paymentRequestInfoPageState)),
      onZelleFullNameInputDone: () => store.dispatch(SaveZelleFullNameInput(store.state.paymentRequestInfoPageState)),
      onVenmoInputDone: () => store.dispatch(SaveVenmoInput(store.state.paymentRequestInfoPageState)),
      onCashAppInputDone: () => store.dispatch(SaveCashAppInput(store.state.paymentRequestInfoPageState)),
      onApplePayInputDone: () => store.dispatch(SaveApplePayInput(store.state.paymentRequestInfoPageState)),
      onOtherMessageChanged: (input) => store.dispatch(SetOtherTextAction(store.state.paymentRequestInfoPageState, input)),
      onOtherInputDone: () => store.dispatch(SaveOtherInput(store.state.paymentRequestInfoPageState)),
      onWireMessageChanged: (input) => store.dispatch(SetWireTextAction(store.state.paymentRequestInfoPageState, input)),
      onWireInputDone: () => store.dispatch(SaveWireInput(store.state.paymentRequestInfoPageState)),
      onCashMessageChanged: (input) => store.dispatch(SetCashTextAction(store.state.paymentRequestInfoPageState, input)),
      onCashInputDone: () => store.dispatch(SaveCashInput(store.state.paymentRequestInfoPageState)),
    );
  }

  @override
  int get hashCode =>
      zelleEnabled.hashCode ^
      venmoEnabled.hashCode ^
      cashAppEnabled.hashCode ^
      applePayEnabled.hashCode ^
      onZelleSelected.hashCode ^
      onVenmoSelected.hashCode ^
      onCashAppSelected.hashCode ^
      onApplePaySelected.hashCode ^
      onZelleTextFullNameChanged.hashCode ^
      onZelleTextPhoneEmailChanged.hashCode ^
      onVenmoTextChanged.hashCode ^
      onCashAppTextChanged.hashCode ^
      onApplePayTextChanged.hashCode ^
      zellePhoneEmail.hashCode ^
      onOtherInputDone.hashCode ^
      onWireInputDone.hashCode ^
      zelleFullName.hashCode ^
      venmoLink.hashCode ^
      cashAppLink.hashCode ^
      onZellePhoneEmailInputDone.hashCode ^
      onZelleFullNameInputDone.hashCode ^
      onVenmoInputDone.hashCode ^
      onCashAppInputDone.hashCode ^
      onApplePayInputDone.hashCode ^
      onOtherSelected.hashCode ^
      onOtherMessageChanged.hashCode ^
      otherMessage.hashCode ^
      otherEnabled.hashCode ^
      onWireSelected.hashCode ^
      onWireMessageChanged.hashCode ^
      wireMessage.hashCode ^
      wireEnabled.hashCode ^
      onCashMessageChanged.hashCode ^
      onCashInputDone.hashCode ^
      cashMessage.hashCode ^
      applePayPhone.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is PaymentRequestInfoPageState &&
              zelleEnabled == other.zelleEnabled &&
              venmoEnabled == other.venmoEnabled &&
              cashAppEnabled == other.cashAppEnabled &&
              applePayEnabled == other.applePayEnabled &&
              onZelleSelected == other.onZelleSelected &&
              onVenmoSelected == other.onVenmoSelected &&
              onCashAppSelected == other.onCashAppSelected &&
              onApplePaySelected == other.onApplePaySelected &&
              onZelleTextPhoneEmailChanged == other.onZelleTextPhoneEmailChanged &&
              onZelleTextFullNameChanged == other.onZelleTextFullNameChanged &&
              onVenmoTextChanged == other.onVenmoTextChanged &&
              onOtherInputDone == other.onOtherInputDone &&
              onWireInputDone == other.onWireInputDone &&
              onCashAppTextChanged == other.onCashAppTextChanged &&
              onApplePayTextChanged == other.onApplePayTextChanged &&
              zelleFullName == other.zelleFullName &&
              zellePhoneEmail == other.zellePhoneEmail &&
              venmoLink == other.venmoLink &&
              cashAppLink == other.cashAppLink &&
              onZelleFullNameInputDone == other.onZelleFullNameInputDone &&
              onZellePhoneEmailInputDone == other.onZellePhoneEmailInputDone &&
              onVenmoInputDone == other.onVenmoInputDone &&
              onCashAppInputDone == other.onCashAppInputDone &&
              onApplePayInputDone == other.onApplePayInputDone &&
              otherEnabled == other.otherEnabled &&
              onOtherMessageChanged == other.onOtherMessageChanged &&
              onOtherSelected == other.onOtherSelected &&
              otherMessage == other.otherMessage &&
              wireEnabled == other.wireEnabled &&
              onWireMessageChanged == other.onWireMessageChanged &&
              onWireSelected == other.onWireSelected &&
              wireMessage == other.wireMessage &&
              onCashMessageChanged == other.onCashMessageChanged &&
              onCashInputDone == other.onCashInputDone &&
              cashMessage == other.cashMessage &&
              applePayPhone == other.applePayPhone;
}