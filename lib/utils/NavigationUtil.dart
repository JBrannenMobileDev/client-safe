import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/models/Contract.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/models/Questionnaire.dart';
import 'package:dandylight/models/RecurringExpense.dart';
import 'package:dandylight/pages/IncomeAndExpenses/IncomeAndExpensesPage.dart';
import 'package:dandylight/pages/IncomeAndExpenses/RecurringExpenseDetails.dart';
import 'package:dandylight/pages/answer_questionnaire_page/AnswerQuestionnairePage.dart';
import 'package:dandylight/pages/booking_page/BookingSetupPage.dart';
import 'package:dandylight/pages/booking_page/NewOfferingPage.dart';
import 'package:dandylight/pages/calendar_page/CalendarPage.dart';
import 'package:dandylight/pages/client_details_page/ClientDetailsPage.dart';
import 'package:dandylight/pages/client_details_page/JobHistoryListPage.dart';
import 'package:dandylight/pages/clients_page/ClientsPage.dart';
import 'package:dandylight/pages/dashboard_page/widgets/JobListPage.dart';
import 'package:dandylight/pages/dashboard_page/widgets/ReminderNotificationsPage.dart';
import 'package:dandylight/pages/home_page/HomePage.dart';
import 'package:dandylight/pages/income_expense_settings_page/IncomeAndExpenseSettingsPage.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsPage.dart';
import 'package:dandylight/pages/job_details_page/JobPosesPage.dart';
import 'package:dandylight/pages/job_details_page/PreviewContractPage.dart';
import 'package:dandylight/pages/login_page/LoginPage.dart';
import 'package:dandylight/pages/main_settings_page/EditAccountPage.dart';
import 'package:dandylight/pages/main_settings_page/MainSettingsPage.dart';
import 'package:dandylight/pages/manage_subscription_page/ManageSubscriptionPage.dart';
import 'package:dandylight/pages/map_location_selection_widget/MapLocationSelectionWidget.dart';
import 'package:dandylight/pages/new_contact_pages/NewContactPage.dart';
import 'package:dandylight/pages/new_job_page/NewJobPage.dart';
import 'package:dandylight/pages/onboarding/OnBoardingPage.dart';
import 'package:dandylight/pages/payment_request_info_page/PaymentRequestInfoPage.dart';
import 'package:dandylight/pages/poses_page/PosesSearchPage.dart';
import 'package:dandylight/pages/review_poses_page/ReviewPosesPage.dart';
import 'package:dandylight/pages/select_a_photo_page/SelectAPhotoPage.dart';
import 'package:dandylight/pages/subscribe_now_page/SubscribeNowPage.dart';
import 'package:dandylight/pages/upload_pose_page/UploadPosePage.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;


import '../data_layer/api_clients/DandylightFunctionsClient.dart';
import '../data_layer/repositories/PendingEmailsRepository.dart';
import '../models/Client.dart';
import '../models/Job.dart';
import '../models/JobStage.dart';
import '../models/LocationDandy.dart';
import '../models/Question.dart';
import '../models/Report.dart';
import '../models/SessionType.dart';
import '../pages/booking_page/BookingPage.dart';
import '../pages/contract_edit_page/ContractEditPage.dart';
import '../pages/dashboard_page/DashboardPageState.dart';
import '../pages/dashboard_page/widgets/ContractListPage.dart';
import '../pages/dashboard_page/widgets/QuestionnairesDashboardPage.dart';
import '../pages/income_expense_settings_page/ReportsPage.dart';
import '../pages/edit_branding_page/EditBrandingPage.dart';
import '../pages/new_question_page/NewQuestionPage.dart';
import '../pages/new_questionnaire_page/NewQuestionnairePage.dart';
import '../pages/main_settings_page/BookAZoomCallPage.dart';
import '../pages/new_session_type_page/NewSessionTypePage.dart';
import '../pages/poses_page/PosesPage.dart';
import '../pages/questionnaires_page/QuestionnairesPage.dart';
import '../pages/share_with_client_page/ShareWithClientPage.dart';
import 'AdminCheckUtil.dart';
import 'analytics/EventNames.dart';
import 'analytics/EventSender.dart';

class NavigationUtil {
  static onShowSubscribeNowPage(BuildContext context) async {
    Profile? profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SubscribeNowPage(profile: profile,)));
  }
  static onClientTapped(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ClientDetailsPage()));
  }
  static onUnconvertedLeadsSelected(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ClientsPage(comingFromUnconverted: true)));
  }
  static onReviewPosesSelected(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ReviewPosesPage()));
  }
  static onInAppPreviewContractSelected(BuildContext context, Contract contract, String photographerName) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => PreviewContractPage(contract: contract, photographerName: photographerName)));
  }
  static onAnswerQuestionnaireSelected(BuildContext context, Questionnaire questionnaire, Profile profile, String? userId, String? jobId, bool isPreview, bool isWebsite, Function? updateQuestionnaireForPortal) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => AnswerQuestionnairePage(
        questionnaire: questionnaire,
        isPreview: isPreview,
        profile: profile,
        userId: userId,
        jobId: jobId,
        isWebsite: isWebsite,
        updateQuestionnaireForPortal: updateQuestionnaireForPortal,
    )));
  }
  static onJobTapped(BuildContext context, bool comingFromOnBoarding, String jobDocumentId) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => JobDetailsPage(jobDocumentId: jobDocumentId, comingFromOnBoarding: comingFromOnBoarding)));
  }
  static onCalendarSelected(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => CalendarPage()));
  }
  static onRecurringChargeSelected(BuildContext context, RecurringExpense recurringExpense) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => RecurringExpenseDetailsPage(recurringExpense)));
  }
  static onSelectMapLocation(BuildContext context, Function(LatLng)? onLocationSaved, double lat, double lng, Function(LocationDandy)? saveSelectedLocation) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => MapLocationSelectionWidget(onLocationSaved, lat, lng, saveSelectedLocation)));
  }
  static onSignOutSelected(BuildContext context) async {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage()));
  }
  static onMainSettingsSelected(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => MainSettingsPage()));
  }
  static onIncomeAndExpenseSettingsSelected(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => IncomeAndExpenseSettingsPage()));
  }
  static onInvoiceNotificationSelected(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => IncomeAndExpensesPage()));
  }
  static onContractNotificationSelected(BuildContext context, String documentId) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => JobDetailsPage(jobDocumentId: documentId,)));
  }
  static onJobSelected(BuildContext context, String documentId) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => JobDetailsPage(jobDocumentId: documentId,)));
  }
  static onJobSelectedFromProgress(BuildContext context, String documentId) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => JobDetailsPage(jobDocumentId: documentId, comingFromProgress: true)));
  }
  static onPaymentRequestInfoSelected(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => PaymentRequestInfoPage()));
  }
  static onEditProfileSelected(BuildContext context, Profile profile) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditAccountPage(profile)));
  }
  static onBookACallSelected(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => BookAZoomCallPage()));
  }
  static onShareWIthClientSelected(BuildContext context, Job job, {bool isPreview = false}) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ShareWithClientPage(job: job, isPreview: isPreview)));
  }
  static onEditBrandingSelected(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditBrandingPage()));
  }
  static onAddQuestionnaireToJobSelected(BuildContext context, String jobDocumentId) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => QuestionnairesPage(jobDocumentId: jobDocumentId, addToJobNew: true)));
  }
  static onContractSelected(BuildContext context, Contract contract, String contractName, bool isNew, String? jobDocumentId, Function(BuildContext, Contract)? onDeleteFromJob) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ContractEditPage(contract: contract, contractName: contractName, isNew: isNew, jobDocumentId: jobDocumentId, deleteFromJob: onDeleteFromJob)));
  }
  static onQuestionnaireSelected(BuildContext context, Questionnaire? questionnaire, String title, bool isNew, String? jobDocumentId, Function(BuildContext, Questionnaire)? onDeleteFromJob) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewQuestionnairePage(questionnaire: questionnaire, title: title, isNew: isNew, jobDocumentId: jobDocumentId, deleteFromJob: onDeleteFromJob)));
  }
  static onNewQuestionSelected(BuildContext context, Question? question, Function(Question) onQuestionSaved, int number) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewQuestionPage(question: question, onQuestionSaved: onQuestionSaved, number: number)));
  }
  static onManageSubscriptionSelected(BuildContext context, Profile profile) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ManageSubscriptionPage(profile)));
  }
  static onStageStatsSelected(BuildContext context, DashboardPageState pageState, String title, JobStage? stage, bool isActiveJobs) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => JobListPage(pageState: pageState, pageTitle: title, stage: stage, isActiveJobs: isActiveJobs)));
  }
  static onDashboardContractsSelected(BuildContext context, DashboardPageState pageState, bool signed) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ContractListPage(pageState: pageState, signed: signed)));
  }
  static onDashboardQuestionnairesSelected(BuildContext context, int index) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => QuestionnairesDashboardPage(index)));
  }
  static onJobHistorySelected(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => JobHistoryListPage()));
  }
  static onNotificationsSelected(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ReminderNotificationsPage()));
  }
  static onJobPosesSelected(BuildContext context, bool comingFromOnboarding) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => JobPosesPage(comingFromOnboarding)));
  }
  static onUploadPoseSelected(BuildContext context, Profile profile) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => UploadPosePage(profile)));
  }
  static onPosesSelected(BuildContext context, Job? job, bool comingFromJobDetails, bool goToSubmittedPoses, bool comingFromGettingStarted) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => PosesPage(job, comingFromJobDetails, goToSubmittedPoses, comingFromGettingStarted)));
  }
  static onSearchPosesSelected(BuildContext context, Job? job, bool comingFromJobDetails) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => PosesSearchPage(job, comingFromJobDetails)));
  }
  static void onSuccessfulLogin(BuildContext context) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(seconds: 0),
        pageBuilder: (context, animation1, animation2) => HomePage(),
      ),
    );
  }

  static void onShowOnBoarding(BuildContext context) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(seconds: 0),
        pageBuilder: (context, animation1, animation2) => OnBoardingPage(),
      ),
    );
  }

  static void onIncomeExpenseReportSelected(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ReportsPage(pageTitle: Report.TYPE_INCOME_EXPENSE)));
  }

  static void onMileageReportSelected(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ReportsPage(pageTitle: Report.TYPE_MILEAGE)));
  }

  static void onSelectAPhotoSelected(BuildContext context, Function(String) onImageSelected) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SelectAPhotoPage(onImageSelected: onImageSelected)));
  }

  static void showNewSessionTypePage(BuildContext context, SessionType? sessionType) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewSessionTypePage(sessionType)));
  }

  static void showBookingPage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => BookingPage()));
  }

  static void showBookingSetupPage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => BookingSetupPage()));
  }

  static void showNewOfferingPage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewOfferingPage()));
  }

  static void showNewJobPage(BuildContext context, {Client? client}) async {
    Profile? profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    if(profile!.isSubscribed! || profile.jobsCreatedCount! < 5 || profile.isFreeForLife! || AdminCheckUtil.isAdmin(profile)) {
      if(context.mounted) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewJobPage(client: client)));
      }
    } else {
      EventSender().sendEvent(eventName: EventNames.JOB_LIMIT_REACHED);
      PendingEmailsRepository(functions: DandylightFunctionsApi(httpClient: http.Client())).sendTrialLimitReachedEmail();
      if(context.mounted) {
        NavigationUtil.onShowSubscribeNowPage(context);
      }
    }
  }

  static void showNewContactPage(BuildContext context, Client? client) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewContactPage(client: client)));
  }
}




