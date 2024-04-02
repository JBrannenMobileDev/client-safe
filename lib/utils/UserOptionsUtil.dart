import 'package:dandylight/models/Invoice.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/MileageExpense.dart';
import 'package:dandylight/models/ReminderDandyLight.dart';
import 'package:dandylight/pages/IncomeAndExpenses/AddTipDialog.dart';
import 'package:dandylight/pages/IncomeAndExpenses/RequestPaymentLinksDialog.dart';
import 'package:dandylight/pages/IncomeAndExpenses/ViewInvoiceDialog.dart';
import 'package:dandylight/pages/job_details_page/DepositChangeDialog.dart';
import 'package:dandylight/pages/job_details_page/JobTypeChangeDialog.dart.dart';
import 'package:dandylight/pages/job_details_page/LocationSelectionDialog.dart';
import 'package:dandylight/pages/job_details_page/NameChangeDialog.dart';
import 'package:dandylight/pages/job_details_page/NewDateSelectionDialog.dart';
import 'package:dandylight/pages/job_details_page/PricePackageChangeDialog.dart.dart';
import 'package:dandylight/pages/job_details_page/ReminderViewDialog.dart';
import 'package:dandylight/pages/job_details_page/TipChangeDialog.dart';
import 'package:dandylight/pages/job_details_page/InvoiceOptionsDialog.dart';
import 'package:dandylight/pages/login_page/ShowAccountCreatedDialog.dart';
import 'package:dandylight/pages/new_contact_pages/DeviceContactsPage.dart';
import 'package:dandylight/pages/new_contact_pages/NewContactPage.dart';
import 'package:dandylight/pages/new_contact_pages/StartJobPromptDialog.dart';
import 'package:dandylight/pages/new_invoice_page/NewDiscountDialog.dart';
import 'package:dandylight/pages/new_invoice_page/NewInvoiceDialog.dart';
import 'package:dandylight/pages/new_invoice_page/NewLineItemDialog.dart';
import 'package:dandylight/pages/new_invoice_page/SelectSalesTaxRateDialog.dart';
import 'package:dandylight/pages/new_invoice_page/SendInvoicePromptDialog.dart';
import 'package:dandylight/pages/new_job_page/NewJobPage.dart';
import 'package:dandylight/pages/new_job_reminder/NewJobReminderPage.dart';
import 'package:dandylight/pages/new_location_page/NewLocationPage.dart';
import 'package:dandylight/pages/new_mileage_expense/ChooseFromMyLocationsMileage.dart';
import 'package:dandylight/pages/new_mileage_expense/LocationOptionsMileageExpenseDialog.dart';
import 'package:dandylight/pages/new_mileage_expense/NewMileageExpensePage.dart';
import 'package:dandylight/pages/new_pose_group_page/NewPoseGroupPage.dart';
import 'package:dandylight/pages/new_pricing_profile_page/NewPricingProfilePage.dart';
import 'package:dandylight/pages/new_recurring_expense/NewRecurringExpensePage.dart';
import 'package:dandylight/pages/new_reminder_page/NewReminderPage.dart';
import 'package:dandylight/pages/new_single_expense_page/NewSingleExpensePage.dart';
import 'package:dandylight/pages/responses_page/widgets/NewResponseCategoryPage.dart';
import 'package:dandylight/pages/sunset_weather_page/ChooseFromMyLocations.dart';
import 'package:dandylight/pages/sunset_weather_page/SelectLocationDialog.dart';
import 'package:dandylight/utils/DandyToastUtil.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:dandylight/utils/analytics/EventNames.dart';
import 'package:dandylight/utils/analytics/EventSender.dart';
import 'package:dandylight/utils/intentLauncher/IntentLauncherUtil.dart';
import 'package:dandylight/widgets/TextDandyLight.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';
import 'package:share_plus/share_plus.dart';

import '../data_layer/local_db/daos/ProfileDao.dart';
import '../models/Client.dart';
import '../models/JobReminder.dart';
import '../models/JobType.dart';
import '../models/LocationDandy.dart';
import '../models/Profile.dart';
import '../pages/calendar_selection_page/CalendarSelectionPage.dart';
import '../pages/job_details_page/ContractOptionsDialog.dart';
import '../pages/login_page/ShowResetPasswordSentDialog.dart';
import '../pages/map_location_selection_widget/MapLocationSelectionWidget.dart';
import '../pages/new_job_page/widgets/SelectNewJobLocationDialog.dart';
import '../pages/new_job_page/widgets/SelectNewJobLocationOptionsDialog.dart';
import '../pages/new_job_types_page/NewJobTypePage.dart';
import 'AdminCheckUtil.dart';
import 'ColorConstants.dart';
import 'ContractOptionsBottomSheet.dart';
import 'ContractUtils.dart';
import 'ShareClientPortalOptionsBottomSheet.dart';
import 'ShareOptionsBottomSheet.dart';

class UserOptionsUtil {
  static void showNewContactDialog(BuildContext context, bool comingFromNewJob){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NewContactPage(comingFromNewJob: comingFromNewJob);
      },
    );
  }

  static void showReminderViewDialog(BuildContext context, JobReminder jobReminder){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ReminderViewDialog(jobReminder: jobReminder);
      },
    );
  }

  static void showCalendarSelectionDialog(BuildContext context, Function(bool)? onCalendarChanged){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CalendarSelectionPage(onCalendarChanged);
      },
    );
  }

  static void showSelectSalesTaxRateDialog(BuildContext context){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SelectSalesTaxRateDialog();
      },
    );
  }

  static void showMileageLocationSelectionDialog(BuildContext context, Function(LatLng) onLocationSaved, double? lat, double? lng) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return LocationOptionsMileageExpenseDialog(onLocationSaved, lat!, lng!);
      },
    );
  }

  static void showNewPriceProfileDialog(BuildContext context){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NewPricingProfilePage();
      },
    );
  }

  static void showNewReminderDialog(BuildContext context, ReminderDandyLight? reminder){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NewReminderPage(reminder);
      },
    );
  }

  static void showNewJobTypePage(BuildContext context, JobType? jobType){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NewJobTypePage(jobType);
      },
    );
  }

  static void showNewJobReminderDialog(BuildContext context, Job job){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NewJobReminderPage(job);
      },
    );
  }

  static void showNewMileageExpenseSelected(BuildContext context, MileageExpense? trip){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NewMileageExpensePage(trip);
      },
    );
  }

  static void showNewJobDialog(BuildContext context, bool comingFromOnBoarding) async {
    Profile? profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    if(profile!.isSubscribed! || profile.jobsCreatedCount! < 5 || profile.isFreeForLife! || AdminCheckUtil.isAdmin(profile)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return NewJobPage(comingFromOnBoarding);
        },
      );
    } else {
      EventSender().sendEvent(eventName: EventNames.JOB_LIMIT_REACHED);
      NavigationUtil.onShowSubscribeNowPage(context);
    }
  }

  static void showSelectLocationDialog(BuildContext context){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SelectLocationDialog();
      },
    );
  }

  static void showChooseFromMyLocationsDialog(BuildContext context){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ChooseFromMyLocations();
      },
    );
  }

  static void showChooseFromMyLocationsMileageDialog(BuildContext context, Function(LatLng) onLocationSaved){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ChooseFromMyLocationsMileage(onLocationSaved);
      },
    );
  }

  static void showNewLocationDialog(BuildContext context){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NewLocationPage();
      },
    );
  }

  static void showNewJobSelectLocationOptionsDialog(BuildContext context){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SelectNewJobLocationDialog();
      },
    );
  }

  static void showNewJobSelectFromMapDialog(BuildContext context, Function(LatLng) onLocationSaved, double lat, double lng, Function(LocationDandy) saveSelectedLocation){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MapLocationSelectionWidget(onLocationSaved, lat, lng, saveSelectedLocation);
      },
    );
  }

  static void showDeviceContactsDialog(BuildContext context){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeviceContactsPage();
      },
    );
  }

  static void showDateSelectionCalendarDialog(BuildContext context){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NewDateSelectionDialog();
      },
    );
  }

  static void showLocationSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return LocationSelectionDialog();
      },
    );
  }

  static void showNameChangeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NameChangeDialog();
      },
    );
  }

  static void showJobPromptDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StartJobPromptDialog();
      },
    );
  }

  static void showSendInvoicePromptDialog(BuildContext context, int invoiceId, Function onSendInvoiceSelected, Job job) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SendInvoicePromptDialog(invoiceId, onSendInvoiceSelected, job);
      },
    );
  }

  static void showAccountCreatedDialog(BuildContext context, User user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ShowAccountCreatedDialog(user);
      },
    );
  }

  static void showResetPasswordEmailSentDialog(BuildContext context, User user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ShowResetPasswordSentDialog(user);
      },
    );
  }

  static void showAddOnCostSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddOnCostChangeDialog();
      },
    );
  }

  static void showTipChangeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return TipChangeDialog();
      },
    );
  }

  static void showJobTypeChangeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return JobTypeChangeDialog();
      },
    );
  }

  static void showPricePackageChangeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PricePackageChangeDialog();
      },
    );
  }

  static void showNewSingleExpenseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NewSingleExpensePage();
      },
    );
  }

  static void showNewRecurringExpenseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NewRecurringExpensePage();
      },
    );
  }

  static void showNewInvoiceDialog(BuildContext context, Function? onSendInvoiceSelected, {Job? job}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NewInvoiceDialog(onSendInvoiceSelected: onSendInvoiceSelected, job: job);
      },
    );
  }

  static void showPaymentLinksRequestDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return RequestPaymentLinksDialog();
      },
    );
  }

  static void showAddTipDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddTipDialog();
      },
    );
  }

  static void showViewInvoiceDialog(BuildContext context, Invoice? invoice, Job? job, Function? onSendInvoiceSelected) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ViewInvoiceDialog(invoice!, job!, onSendInvoiceSelected);
      },
    );
  }

  static void showInvoiceOptionsDialog(BuildContext context, Function onSendInvoiceSelected) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return InvoiceOptionsDialog(onSendInvoiceSelected);
      },
    );
  }

  static void showContractOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ContractOptionsDialog();
      },
    );
  }

  static void showNewLineItemDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NewLineItemDialog();
      },
    );
  }

  static void showNewDiscountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NewDiscountDialog();
      },
    );
  }

  static void showNewPoseGroupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NewPoseGroupPage();
      },
    );
  }

  static void showNewResponseGroupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NewResponseCategoryPage();
      },
    );
  }

  static void showDashboardOptionsSheet(BuildContext context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 154.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ListTile(
                  leading: Icon(
                      Icons.person,
                      color: Color(ColorConstants.getPrimaryBlack())
                  ),
                  title: Text(
                      "Add New Contact",
                      style: TextStyle(
                        fontSize: 22.0,
                        fontFamily: 'simple',
                        fontWeight: FontWeight.w600,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return NewContactPage();
                      },
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.business_center,
                    color: Color(ColorConstants.getPrimaryBlack()),
                  ),
                  title: Text(
                      "Start New Job",
                      style: TextStyle(
                        fontSize: 22.0,
                        fontFamily: 'simple',
                        fontWeight: FontWeight.w600,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return NewJobPage(false);
                      },
                    );
                  },
                ),
              ],
            ),
          );
        });
  }

  static void showShareOptionsSheet(BuildContext context, Client client, String message, String emailTitle) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: true,
        backgroundColor: Colors.transparent,
        barrierColor: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
        builder: (context) {
          return ShareOptionsBottomSheet(client, message, emailTitle);
        });
  }

  static void showShareClientPortalOptionsSheet(BuildContext context, Client client, String emailTitle, Profile profile, Job job) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: true,
        backgroundColor: Colors.transparent,
        barrierColor: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
        builder: (context) {
          return ShareClientPortalOptionsBottomSheet(client, emailTitle, profile, job);
        });
  }

  static void showContractOptionsSheet(BuildContext context, Job job, Profile profile, Function openContractEditPage) {
    String populatedJsonTerms = ContractUtils.populate(job, profile);
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: true,
        backgroundColor: Colors.transparent,
        barrierColor: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
        builder: (context) {
          return ContractOptionsBottomSheet(populatedJsonTerms, openContractEditPage);
        });
  }
}
