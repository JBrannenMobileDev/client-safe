import 'dart:io';

import 'package:dandylight/models/Client.dart';
import 'package:dandylight/models/EventDandyLight.dart';
import 'package:dandylight/models/Invoice.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/JobReminder.dart';
import 'package:dandylight/models/Location.dart';
import 'package:dandylight/models/PriceProfile.dart';
import 'package:dandylight/pages/client_details_page/ClientDetailsPageActions.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsActions.dart';
import 'package:dandylight/pages/job_details_page/document_items/DocumentItem.dart';
import 'package:dandylight/pages/jobs_page/JobsPageActions.dart';
import 'package:dandylight/pages/new_invoice_page/NewInvoicePageActions.dart';
import 'package:dandylight/utils/analytics/EventSender.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';
import '../../models/JobType.dart';
import '../../models/ReminderDandyLight.dart';
import '../../utils/analytics/EventNames.dart';
import '../pose_group_page/GroupImage.dart';
import '../sunset_weather_page/SunsetWeatherPageActions.dart';

class JobDetailsPageState {
  final Job job;
  final Client client;
  final DateTime sunsetTime;
  final DateTime selectedDate;
  final int newStagAnimationIndex;
  final double stageScrollOffset;
  final List<EventDandyLight> eventList;
  final List<Event> deviceEvents;
  final List<Job> jobs;
  final List<GroupImage> poseImages;
  final JobType jobType;
  final List<JobReminder> reminders;
  final String jobTitleText;
  final double unsavedAddOnCostAmount;
  final int unsavedTipAmount;
  final List<Location> locations;
  final List<File> imageFiles;
  final Location selectedLocation;
  final Function(Location) onLocationSelected;
  final List<int> expandedIndexes;
  final String documentPath;
  final PriceProfile selectedPriceProfile;
  final List<PriceProfile> priceProfiles;
  final List<JobType> jobTypes;
  final List<DocumentItem> documents;
  final Invoice invoice;
  final String notes;
  final File locationImage;
  final String weatherIcon;
  final String tempHigh;
  final String tempLow;
  final String chanceOfRain;
  final String cloudCoverage;
  final String eveningGoldenHour;
  final String sunset;
  final String eveningBlueHour;
  final Function(PriceProfile) onPriceProfileSelected;
  final Function(String) onSaveUpdatedPriceProfileSelected;
  final Function(JobType) onJobTypeSelected;
  final Function(Job, int) onStageCompleted;
  final Function(Job, int) onStageUndo;
  final Function(int) setNewIndexForStageAnimation;
  final Function(int) addExpandedIndex;
  final Function(int) removeExpandedIndex;
  final Function() onDeleteSelected;
  final Function() onInstagramSelected;
  final Function(double) onScrollOffsetChanged;
  final Function(DateTime) onNewTimeSelected;
  final Function(DateTime) onNewEndTimeSelected;
  final Function() onSaveSelectedDate;
  final Function(Client) onClientClicked;
  final Function(Job) onJobClicked;
  final Function(Location) onLocationSaveSelected;
  final Function(String) onJobTitleTextChanged;
  final Function() onNameChangeSaved;
  final Function() onJobTypeSaveSelected;
  final Function(int) onAddToDeposit;
  final Function() onSaveAddOnCost;
  final Function() onClearUnsavedDeposit;
  final Function(int) onAddToTip;
  final Function() onSaveTipChange;
  final Function() onClearUnsavedTip;
  final Function() onAddInvoiceSelected;
  final Function(Invoice) onDeleteInvoiceSelected;
  final Function(Invoice) onInvoiceSent;
  final Function() onBackPressed;
  final Function(JobReminder) onDeleteReminderSelected;
  final Function(DateTime) onMonthChanged;
  final Function(DateTime) onNewDateSelected;
  final Function(int) onDeletePoseSelected;
  final Function(String) onNotesTextChanged;
  final Function() setOnBoardingComplete;
  final Function() onSunsetWeatherSelected;

  JobDetailsPageState({
    @required this.job,
    @required this.selectedDate,
    @required this.client,
    @required this.sunsetTime,
    @required this.eventList,
    @required this.deviceEvents,
    @required this.jobs,
    @required this.documentPath,
    @required this.jobTitleText,
    @required this.locations,
    @required this.selectedLocation,
    @required this.onLocationSelected,
    @required this.expandedIndexes,
    @required this.stageScrollOffset,
    @required this.onStageCompleted,
    @required this.invoice,
    @required this.newStagAnimationIndex,
    @required this.onStageUndo,
    @required this.setNewIndexForStageAnimation,
    @required this.addExpandedIndex,
    @required this.removeExpandedIndex,
    @required this.onDeleteSelected,
    @required this.onInstagramSelected,
    @required this.onScrollOffsetChanged,
    @required this.onNewTimeSelected,
    @required this.onSaveSelectedDate,
    @required this.onClientClicked,
    @required this.onJobClicked,
    @required this.onLocationSaveSelected,
    @required this.onJobTitleTextChanged,
    @required this.onNameChangeSaved,
    @required this.onJobTypeSelected,
    @required this.onJobTypeSaveSelected,
    @required this.selectedPriceProfile,
    @required this.priceProfiles,
    @required this.onPriceProfileSelected,
    @required this.onSaveUpdatedPriceProfileSelected,
    @required this.unsavedAddOnCostAmount,
    @required this.onAddToDeposit,
    @required this.onSaveAddOnCost,
    @required this.onClearUnsavedDeposit,
    @required this.onAddInvoiceSelected,
    @required this.documents,
    @required this.onDeleteInvoiceSelected,
    @required this.onInvoiceSent,
    @required this.unsavedTipAmount,
    @required this.onAddToTip,
    @required this.onSaveTipChange,
    @required this.onClearUnsavedTip,
    @required this.onBackPressed,
    @required this.reminders,
    @required this.onDeleteReminderSelected,
    @required this.onMonthChanged,
    @required this.onNewDateSelected,
    @required this.imageFiles,
    @required this.jobType,
    @required this.jobTypes,
    @required this.onNewEndTimeSelected,
    @required this.poseImages,
    @required this.onDeletePoseSelected,
    @required this.onNotesTextChanged,
    @required this.notes,
    @required this.setOnBoardingComplete,
    @required this.locationImage,
    @required this.weatherIcon,
    @required this.tempHigh,
    @required this.tempLow,
    @required this.chanceOfRain,
    @required this.cloudCoverage,
    @required this.eveningGoldenHour,
    @required this.sunset,
    @required this.eveningBlueHour,
    @required this.onSunsetWeatherSelected,
  });

  JobDetailsPageState copyWith({
    String weatherIcon,
    String tempHigh,
    String tempLow,
    String chanceOfRain,
    String cloudCoverage,
    Job job,
    Client client,
    DateTime selectedDate,
    int newStagAnimationIndex,
    double stageScrollOffset,
    List<EventDandyLight> eventList,
    List<Event> deviceEvents,
    List<Job> jobs,
    JobType jobType,
    String jobTitleText,
    List<Location> locations,
    List<File> imageFiles,
    List<JobReminder> reminders,
    Location selectedLocation,
    Function(Location) onLocationSelected,
    List<int> expandedIndexes,
    String documentPath,
    Invoice invoice,
    List<JobType> jobTypes,
    PriceProfile selectedPriceProfile,
    List<PriceProfile> priceProfiles,
    File locationImage,
    String eveningGoldenHour,
    String sunset,
    String eveningBlueHour,
    Function(PriceProfile) onPriceProfileSelected,
    Function(String) onSaveUpdatedPriceProfileSelected,
    Function(JobType) onJobTypeSelected,
    Function(Job, int) onStageCompleted,
    Function(Job, int) onStageUndo,
    Function(int) setNewIndexForStageAnimation,
    Function(int) addExpandedIndex,
    Function(int) removeExpandedIndex,
    Function() onDeleteSelected,
    Function() onInstagramSelected,
    DateTime sunsetTime,
    Function(double) onScrollOffsetChanged,
    Function(DateTime) onNewTimeSelected,
    Function() onSaveSelectedDate,
    Function(Client) onClientClicked,
    Function(Job) onJobClicked,
    Function(Location) onLocationSaveSelected,
    Function(String) onJobTitleTextChanged,
    Function() onNameChangeSaved,
    Function(JobType) onJobTypeSaveSelected,
    double unsavedAddOnCostAmount,
    Function(int) onAddToDeposit,
    Function() onSaveAddOnCost,
    Function() onClearUnsavedDeposit,
    Function() onAddInvoiceSelected,
    List<DocumentItem> documents,
    Function(Invoice) onDeleteInvoiceSelected,
    Function(Invoice) onInvoiceSent,
    Function(int) onAddToTip,
    Function() onSaveTipChange,
    Function() onClearUnsavedTip,
    int unsavedTipAmount,
    Function() onBackPressed,
    Function(JobReminder) onDeleteReminderSelected,
    Function(DateTime) onMonthChanged,
    Function(DateTime) onNewDateSelected,
    Function(DateTime) onNewEndTimeSelected,
    List<GroupImage> poseImages,
    Function(int) onDeletePoseSelected,
    Function(String) onNotesTextChanged,
    String notes,
    Function() setOnBoardingComplete,
    Function() onSunsetWeatherSelected,
  }){
    return JobDetailsPageState(
      job: job ?? this.job,
      client: client ?? this.client,
      onAddToTip: onAddToTip ?? this.onAddToTip,
      onSaveTipChange: onSaveTipChange ?? this.onSaveTipChange,
      onClearUnsavedTip: onClearUnsavedTip ?? this.onClearUnsavedTip,
      sunsetTime: sunsetTime ?? this.sunsetTime,
      stageScrollOffset: stageScrollOffset ?? this.stageScrollOffset,
      eventList: eventList ?? this.eventList,
      deviceEvents: deviceEvents ?? this.deviceEvents,
      jobs: jobs ?? this.jobs,
      jobType: jobType ?? this.jobType,
      reminders: reminders ?? this.reminders,
      documentPath: documentPath ?? this.documentPath,
      jobTitleText: jobTitleText ?? this.jobTitleText,
      locations: locations ?? this.locations,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      onLocationSelected: onLocationSelected ?? this.onLocationSelected,
      expandedIndexes: expandedIndexes ?? this.expandedIndexes,
      onStageCompleted: onStageCompleted ?? this.onStageCompleted,
      onStageUndo: onStageUndo ?? this.onStageUndo,
      newStagAnimationIndex: newStagAnimationIndex ?? this.newStagAnimationIndex,
      setNewIndexForStageAnimation: setNewIndexForStageAnimation ?? this.setNewIndexForStageAnimation,
      addExpandedIndex: addExpandedIndex ?? this.addExpandedIndex,
      removeExpandedIndex: removeExpandedIndex ?? this.removeExpandedIndex,
      onDeleteSelected: onDeleteSelected ?? this.onDeleteSelected,
      onInstagramSelected: onInstagramSelected ?? this.onInstagramSelected,
      onScrollOffsetChanged: onScrollOffsetChanged ?? this.onScrollOffsetChanged,
      onNewTimeSelected: onNewTimeSelected ?? this.onNewTimeSelected,
      onSaveSelectedDate: onSaveSelectedDate ?? this.onSaveSelectedDate,
      onClientClicked: onClientClicked ?? this.onClientClicked,
      onJobClicked: onJobClicked ?? this.onJobClicked,
      onLocationSaveSelected: onLocationSaveSelected ?? this.onLocationSaveSelected,
      onJobTitleTextChanged: onJobTitleTextChanged ?? this.onJobTitleTextChanged,
      onNameChangeSaved: onNameChangeSaved ?? this.onNameChangeSaved,
      onJobTypeSelected: onJobTypeSelected ?? this.onJobTypeSelected,
      onJobTypeSaveSelected: onJobTypeSaveSelected ?? this.onJobTypeSaveSelected,
      selectedPriceProfile: selectedPriceProfile ?? this.selectedPriceProfile,
      priceProfiles: priceProfiles ?? this.priceProfiles,
      unsavedTipAmount: unsavedTipAmount ?? this.unsavedTipAmount,
      onPriceProfileSelected: onPriceProfileSelected ?? this.onPriceProfileSelected,
      onSaveUpdatedPriceProfileSelected: onSaveUpdatedPriceProfileSelected ?? this.onSaveUpdatedPriceProfileSelected,
      unsavedAddOnCostAmount: unsavedAddOnCostAmount ?? this.unsavedAddOnCostAmount,
      onAddToDeposit: onAddToDeposit ?? this.onAddToDeposit,
      onSaveAddOnCost:  onSaveAddOnCost ?? this.onSaveAddOnCost,
      onClearUnsavedDeposit: onClearUnsavedDeposit ?? this.onClearUnsavedDeposit,
      onAddInvoiceSelected: onAddInvoiceSelected ?? this.onAddInvoiceSelected,
      documents: documents ?? this.documents,
      onDeleteInvoiceSelected: onDeleteInvoiceSelected ?? this.onDeleteInvoiceSelected,
      invoice: invoice ?? this.invoice,
      onInvoiceSent: onInvoiceSent ?? this.onInvoiceSent,
      onBackPressed: onBackPressed ?? this.onBackPressed,
      onDeleteReminderSelected: onDeleteReminderSelected?? this.onDeleteReminderSelected,
      selectedDate: selectedDate ?? this.selectedDate,
      onMonthChanged: onMonthChanged ?? this.onMonthChanged,
      onNewDateSelected: onNewDateSelected ?? this.onNewDateSelected,
      imageFiles: imageFiles ?? this.imageFiles,
      jobTypes: jobTypes ?? this.jobTypes,
      onNewEndTimeSelected: onNewEndTimeSelected ?? this.onNewEndTimeSelected,
      poseImages: poseImages ?? this.poseImages,
      onDeletePoseSelected: onDeletePoseSelected ?? this.onDeletePoseSelected,
      onNotesTextChanged: onNotesTextChanged ?? this.onNotesTextChanged,
      notes: notes ?? this.notes,
      setOnBoardingComplete: setOnBoardingComplete ?? this.setOnBoardingComplete,
      locationImage: locationImage ?? this.locationImage,
      weatherIcon: weatherIcon ?? this.weatherIcon,
      tempLow: tempLow ?? this.tempLow,
      tempHigh: tempHigh ?? this.tempHigh,
      chanceOfRain: chanceOfRain ?? this.chanceOfRain,
      cloudCoverage: cloudCoverage ?? this.cloudCoverage,
      eveningGoldenHour: eveningGoldenHour ?? this.eveningGoldenHour,
      sunset: sunset ?? this.sunset,
      eveningBlueHour: eveningBlueHour ?? this.eveningBlueHour,
      onSunsetWeatherSelected: onSunsetWeatherSelected ?? this.onSunsetWeatherSelected,
    );
  }

  static JobDetailsPageState fromStore(Store<AppState> store) {
    return JobDetailsPageState(
        job: store.state.jobDetailsPageState.job,
        selectedDate: store.state.jobDetailsPageState.selectedDate,
        client: store.state.jobDetailsPageState.client,
        sunsetTime: store.state.jobDetailsPageState.sunsetTime,
        stageScrollOffset: store.state.jobDetailsPageState.stageScrollOffset,
        eventList: store.state.jobDetailsPageState.eventList,
        deviceEvents: store.state.jobDetailsPageState.deviceEvents,
        jobs: store.state.jobDetailsPageState.jobs,
        jobTitleText: store.state.jobDetailsPageState.jobTitleText,
        locations: store.state.jobDetailsPageState.locations,
        selectedLocation: store.state.jobDetailsPageState.selectedLocation,
        expandedIndexes: store.state.jobDetailsPageState.expandedIndexes,
        newStagAnimationIndex: store.state.jobDetailsPageState.newStagAnimationIndex,
        selectedPriceProfile: store.state.jobDetailsPageState.selectedPriceProfile,
        priceProfiles: store.state.jobDetailsPageState.priceProfiles,
        unsavedAddOnCostAmount: store.state.jobDetailsPageState.unsavedAddOnCostAmount,
        unsavedTipAmount: store.state.jobDetailsPageState.unsavedTipAmount,
        documentPath: store.state.jobDetailsPageState.documentPath,
        documents: store.state.jobDetailsPageState.documents,
        invoice: store.state.jobDetailsPageState.invoice,
        reminders: store.state.jobDetailsPageState.reminders,
        imageFiles: store.state.jobDetailsPageState.imageFiles,
        jobType: store.state.jobDetailsPageState.jobType,
        jobTypes: store.state.jobDetailsPageState.jobTypes,
        poseImages: store.state.jobDetailsPageState.poseImages,
        notes: store.state.jobDetailsPageState.notes,
        locationImage: store.state.jobDetailsPageState.locationImage,
        weatherIcon: store.state.jobDetailsPageState.weatherIcon,
        tempLow: store.state.jobDetailsPageState.tempLow,
        tempHigh: store.state.jobDetailsPageState.tempHigh,
        chanceOfRain: store.state.jobDetailsPageState.chanceOfRain,
        cloudCoverage: store.state.jobDetailsPageState.cloudCoverage,
        eveningGoldenHour: store.state.jobDetailsPageState.eveningGoldenHour,
        sunset: store.state.jobDetailsPageState.sunset,
        eveningBlueHour: store.state.jobDetailsPageState.eveningBlueHour,
        onAddToTip: (amountToAdd) => store.dispatch(AddToTipAction(store.state.jobDetailsPageState, amountToAdd)),
        onSaveTipChange: () => store.dispatch(SaveTipChangeAction(store.state.jobDetailsPageState)),
        onClearUnsavedTip: () => store.dispatch(ClearUnsavedTipAction(store.state.jobDetailsPageState)),
        onStageUndo: (job, stageIndex) => store.dispatch(UndoStageAction(store.state.jobDetailsPageState, job, stageIndex)),
        onStageCompleted: (job, stageIndex) => store.dispatch(SaveStageCompleted(store.state.jobDetailsPageState, job, stageIndex)),
        setNewIndexForStageAnimation: (index) => store.dispatch(SetNewStagAnimationIndex(store.state.jobDetailsPageState, index)),
        addExpandedIndex: (index) => store.dispatch(SetExpandedIndexAction(store.state.jobDetailsPageState, index)),
        removeExpandedIndex: (index) => store.dispatch(RemoveExpandedIndexAction(store.state.jobDetailsPageState, index)),
        onDeleteSelected: () => store.dispatch(DeleteJobAction(store.state.jobDetailsPageState)),
        onInstagramSelected: () => store.dispatch(JobInstagramSelectedAction(store.state.jobDetailsPageState)),
        onScrollOffsetChanged: (offset) => store.dispatch(UpdateScrollOffset(store.state.jobDetailsPageState, offset)),
        onNewTimeSelected: (newTime) => store.dispatch(UpdateJobTimeAction(store.state.jobDetailsPageState, newTime)),
        onNewEndTimeSelected: (newTime) => store.dispatch(UpdateJobEndTimeAction(store.state.jobDetailsPageState, newTime)),
        onSaveSelectedDate: () => store.dispatch(UpdateJobDateAction(store.state.jobDetailsPageState)),
        onClientClicked: (client) => store.dispatch(InitializeClientDetailsAction(store.state.clientDetailsPageState, client)),
        onJobClicked: (job) => store.dispatch(SetJobInfo(store.state.jobDetailsPageState, job)),
        onLocationSelected: (location) => store.dispatch(SetNewSelectedLocation(store.state.jobDetailsPageState, location)),
        onLocationSaveSelected: (location) => store.dispatch(UpdateNewLocationAction(store.state.jobDetailsPageState, location)),
        onJobTitleTextChanged: (newText) => store.dispatch(UpdateJobNameAction(store.state.jobDetailsPageState, newText)),
        onNameChangeSaved: () => store.dispatch(SaveJobNameChangeAction(store.state.jobDetailsPageState)),
        onJobTypeSelected: (jobType) => store.dispatch(UpdateSelectedJobTypeAction(store.state.jobDetailsPageState, jobType)),
        onJobTypeSaveSelected: () => store.dispatch(SaveUpdatedJobTypeAction(store.state.jobDetailsPageState)),
        onPriceProfileSelected: (priceProfile) => store.dispatch(UpdateSelectedPricePackageAction(store.state.jobDetailsPageState, priceProfile)),
        onSaveUpdatedPriceProfileSelected: (oneTimePrice) => store.dispatch(SaveUpdatedPricePackageAction(store.state.jobDetailsPageState, oneTimePrice)),
        onAddToDeposit: (amountToAdd) => store.dispatch(AddToAddOnCostAction(store.state.jobDetailsPageState, amountToAdd)),
        onSaveAddOnCost: () => store.dispatch(SaveAddOnCostAction(store.state.jobDetailsPageState)),
        onClearUnsavedDeposit: () => store.dispatch(ClearUnsavedDepositAction(store.state.jobDetailsPageState)),
        onAddInvoiceSelected: () {
          store.dispatch(SetShouldClearAction(store.state.newInvoicePageState, false));
          store.dispatch(SaveSelectedJobAction(store.state.newInvoicePageState, store.state.jobDetailsPageState.job));
        },
        onDeleteInvoiceSelected: (invoice) => store.dispatch(OnDeleteInvoiceSelectedAction(store.state.jobDetailsPageState, invoice)),
        onInvoiceSent: (invoice) => store.dispatch(InvoiceSentAction(store.state.jobDetailsPageState, invoice)),
        onBackPressed: () => store.dispatch(FetchJobsAction(store.state.jobsPageState)),
        onDeleteReminderSelected: (reminder) => store.dispatch(DeleteReminderFromJobAction(store.state.jobDetailsPageState, reminder)),
        onMonthChanged: (month) => store.dispatch(FetchJobDetailsDeviceEvents(store.state.jobDetailsPageState, month)),
        onNewDateSelected: (selectedDate) => store.dispatch(SetJobDetailsSelectedDateAction(store.state.jobDetailsPageState, selectedDate)),
        onDeletePoseSelected: (imageIndex) => store.dispatch(DeleteJobPoseAction(store.state.jobDetailsPageState, imageIndex)),
        onNotesTextChanged: (notes) {
          store.dispatch(SaveJobNotesAction(store.state.jobDetailsPageState, notes));
        },
        setOnBoardingComplete: () => store.dispatch(SetOnBoardingCompleteAction(store.state.jobDetailsPageState)),
        onSunsetWeatherSelected: () => store.dispatch(LoadInitialLocationAndDateComingFromNewJobAction(store.state.sunsetWeatherPageState, store.state.jobDetailsPageState.job.location, store.state.jobDetailsPageState.job.selectedDate)),
    );
  }

  factory JobDetailsPageState.initial() => JobDetailsPageState(
    job: null,
    client: null,
    onBackPressed: null,
    onDeleteReminderSelected: null,
    selectedDate: null,
    onMonthChanged: null,
    sunsetTime: null,
    stageScrollOffset: 200.0,
    newStagAnimationIndex: 2,
    eventList: [],
    deviceEvents: [],
    jobs: [],
    jobTitleText: "",
    onDeleteInvoiceSelected: null,
    documents: [],
    jobType: null,
    onLocationSaveSelected: null,
    setNewIndexForStageAnimation: null,
    locations: [],
    onInvoiceSent: null,
    selectedLocation: null,
    expandedIndexes: [],
    onStageCompleted: null,
    onStageUndo: null,
    addExpandedIndex: null,
    removeExpandedIndex: null,
    onDeleteSelected: null,
    onInstagramSelected: null,
    onScrollOffsetChanged: null,
    onNewTimeSelected: null,
    onSaveSelectedDate: null,
    onClientClicked: null,
    onJobClicked: null,
    onLocationSelected: null,
    onJobTitleTextChanged: null,
    onNameChangeSaved: null,
    documentPath: '',
    onJobTypeSelected: null,
    onJobTypeSaveSelected: null,
    selectedPriceProfile: null,
    priceProfiles: [],
    onPriceProfileSelected: null,
    onSaveUpdatedPriceProfileSelected: null,
    unsavedAddOnCostAmount: 0,
    onAddToDeposit: null,
    onSaveAddOnCost: null,
    onClearUnsavedDeposit: null,
    onAddInvoiceSelected: null,
    invoice: null,
    unsavedTipAmount: 0,
    onAddToTip: null,
    onSaveTipChange: null,
    onClearUnsavedTip: null,
    reminders: [],
    imageFiles: [],
    jobTypes: [],
    onNewEndTimeSelected: null,
    poseImages: [],
    onDeletePoseSelected: null,
    onNotesTextChanged: null,
    locationImage: null,
    notes: "",
    setOnBoardingComplete: null,
    weatherIcon: "",
    tempLow: "",
    tempHigh: "",
    chanceOfRain: "",
    cloudCoverage: "",
    eveningGoldenHour: "",
    sunset: "Loading...",
    eveningBlueHour: "",
    onSunsetWeatherSelected: null,
    onNewDateSelected: null,
  );

  @override
  int get hashCode =>
      unsavedTipAmount.hashCode ^
      onAddToTip.hashCode ^
      onBackPressed.hashCode ^
      onDeleteReminderSelected.hashCode ^
      selectedDate.hashCode ^
      deviceEvents.hashCode ^
      onSaveTipChange.hashCode ^
      onClearUnsavedTip.hashCode ^
      unsavedAddOnCostAmount.hashCode ^
      onAddToDeposit.hashCode ^
      onSaveAddOnCost.hashCode ^
      job.hashCode ^
      weatherIcon.hashCode ^
      tempLow.hashCode ^
      tempHigh.hashCode ^
      chanceOfRain.hashCode ^
      cloudCoverage.hashCode ^
      jobTypes.hashCode ^
      jobType.hashCode ^
      documentPath.hashCode ^
      client.hashCode ^
      sunsetTime.hashCode ^
      stageScrollOffset.hashCode ^
      eventList.hashCode ^
      jobs.hashCode ^
      invoice.hashCode ^
      onMonthChanged.hashCode ^
      onAddInvoiceSelected.hashCode ^
      jobTitleText.hashCode ^
      onNameChangeSaved.hashCode ^
      selectedLocation.hashCode ^
      onLocationSelected.hashCode ^
      locations.hashCode ^
      setOnBoardingComplete.hashCode ^
      expandedIndexes.hashCode ^
      newStagAnimationIndex.hashCode ^
      onStageCompleted.hashCode ^
      onStageUndo.hashCode ^
      addExpandedIndex.hashCode ^
      removeExpandedIndex.hashCode ^
      onDeleteSelected.hashCode ^
      onInstagramSelected.hashCode ^
      onScrollOffsetChanged.hashCode ^
      onNewTimeSelected.hashCode ^
      onSaveSelectedDate.hashCode ^
      onClientClicked.hashCode ^
      onJobClicked.hashCode ^
      onJobTitleTextChanged.hashCode ^
      onJobTypeSelected.hashCode ^
      onJobTypeSaveSelected.hashCode ^
      priceProfiles.hashCode ^
      selectedPriceProfile.hashCode ^
      onPriceProfileSelected.hashCode ^
      onSaveUpdatedPriceProfileSelected.hashCode ^
      onClearUnsavedDeposit.hashCode ^
      imageFiles.hashCode ^
      onNewEndTimeSelected.hashCode ^
      poseImages.hashCode ^
      onDeletePoseSelected.hashCode ^
      onNotesTextChanged.hashCode ^
      notes.hashCode ^
      locationImage.hashCode ^
      eveningGoldenHour.hashCode ^
      sunset.hashCode ^
      eveningBlueHour.hashCode ^
      onSunsetWeatherSelected.hashCode ^
      reminders.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is JobDetailsPageState &&
              unsavedAddOnCostAmount == other.unsavedAddOnCostAmount &&
              onAddToDeposit == other.onAddToDeposit &&
              onAddInvoiceSelected == other.onAddInvoiceSelected &&
              onSaveAddOnCost == other.onSaveAddOnCost &&
              job == other.job &&
              eveningGoldenHour == other.eveningGoldenHour &&
              sunset == other.sunset &&
              eveningBlueHour == other.eveningBlueHour &&
              jobTypes == other.jobTypes &&
              selectedDate == other.selectedDate &&
              deviceEvents == other.deviceEvents &&
              unsavedTipAmount == other.unsavedTipAmount &&
              onAddToTip == other.onAddToTip &&
              jobType == other.jobType &&
              onSunsetWeatherSelected == other.onSunsetWeatherSelected &&
              setOnBoardingComplete == other.setOnBoardingComplete &&
              onSaveTipChange == other.onSaveTipChange &&
              onClearUnsavedTip == other.onClearUnsavedTip &&
              documentPath == other.documentPath &&
              client == other.client &&
              sunsetTime == other.sunsetTime &&
              stageScrollOffset == other.stageScrollOffset &&
              eventList == other.eventList &&
              jobs == other.jobs &&
              onMonthChanged == other.onMonthChanged &&
              reminders == other.reminders &&
              invoice == other.invoice &&
              jobTitleText == other.jobTitleText &&
              onNameChangeSaved == other.onNameChangeSaved &&
              selectedLocation == other.selectedLocation &&
              onLocationSelected == other.onLocationSelected &&
              locations == other.locations &&
              expandedIndexes == other.expandedIndexes &&
              newStagAnimationIndex == other.newStagAnimationIndex &&
              onStageCompleted == other.onStageCompleted &&
              onStageUndo == other.onStageUndo &&
              addExpandedIndex == other.addExpandedIndex &&
              removeExpandedIndex ==other.removeExpandedIndex &&
              onDeleteSelected == other.onDeleteSelected &&
              onInstagramSelected == other.onInstagramSelected &&
              onScrollOffsetChanged == other.onScrollOffsetChanged &&
              onNewTimeSelected == other.onNewTimeSelected &&
              onSaveSelectedDate == other.onSaveSelectedDate &&
              onClientClicked == other.onClientClicked &&
              onJobClicked == other.onJobClicked &&
              onJobTitleTextChanged == other.onJobTitleTextChanged &&
              onJobTypeSelected == other.onJobTypeSelected &&
              onJobTypeSaveSelected == other.onJobTypeSaveSelected &&
              selectedPriceProfile == other.selectedPriceProfile &&
              priceProfiles == other.priceProfiles &&
              onPriceProfileSelected == other.onPriceProfileSelected &&
              onSaveUpdatedPriceProfileSelected == other.onSaveUpdatedPriceProfileSelected &&
              imageFiles == other.imageFiles &&
              onNewEndTimeSelected == other.onNewEndTimeSelected &&
              poseImages == other.poseImages &&
              onDeletePoseSelected == other.onDeletePoseSelected &&
              onNotesTextChanged == other.onNotesTextChanged &&
              locationImage == other.locationImage &&
              notes == other.notes &&
              weatherIcon == other.weatherIcon &&
              tempLow == other.tempLow &&
              tempHigh == other.tempHigh &&
              chanceOfRain == other.chanceOfRain &&
              cloudCoverage == other.cloudCoverage &&
              onClearUnsavedDeposit == other.onClearUnsavedDeposit;
}
