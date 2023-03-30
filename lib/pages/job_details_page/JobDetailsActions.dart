import 'dart:io';

import 'package:dandylight/models/Client.dart';
import 'package:dandylight/models/EventDandyLight.dart';
import 'package:dandylight/models/Invoice.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/Location.dart';
import 'package:dandylight/models/PriceProfile.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsPageState.dart';
import 'package:device_calendar/device_calendar.dart';

import '../../models/JobReminder.dart';
import '../../models/JobType.dart';
import '../../models/ReminderDandyLight.dart';
import '../pose_group_page/GroupImage.dart';

class SetJobInfo{
  final JobDetailsPageState pageState;
  final Job job;
  SetJobInfo(this.pageState, this.job);
}

class SetJobInfoWithJobDocumentId{
  final JobDetailsPageState pageState;
  final String jobDocumentId;
  SetJobInfoWithJobDocumentId(this.pageState, this.jobDocumentId);
}

class FetchJobDetailsDeviceEvents{
  final JobDetailsPageState calendarPageState;
  final DateTime month;
  FetchJobDetailsDeviceEvents(this.calendarPageState, this.month);
}

class SetJobDetailsSelectedDateAction{
  final JobDetailsPageState pageState;
  final DateTime selectedDate;
  SetJobDetailsSelectedDateAction(this.pageState, this.selectedDate);
}

class DeleteJobPoseAction {
  final JobDetailsPageState pageState;
  final int imageIndex;
  DeleteJobPoseAction(this.pageState, this.imageIndex);
}

class SaveJobNotesAction {
  final JobDetailsPageState pageState;
  final String notes;
  SaveJobNotesAction(this.pageState, this.notes);
}

class SetDeviceEventsAction {
  final JobDetailsPageState pageState;
  final List<Event> deviceEvents;
  SetDeviceEventsAction(this.pageState, this.deviceEvents);
}

class SetRemindersAction{
  final JobDetailsPageState pageState;
  final List<JobReminder> reminders;
  SetRemindersAction(this.pageState, this.reminders);
}

class FetchJobRemindersAction{
  final JobDetailsPageState pageState;
  FetchJobRemindersAction(this.pageState);
}

class FetchAllJobTypesAction{
  final JobDetailsPageState pageState;
  FetchAllJobTypesAction(this.pageState);
}

class SetAllJobTypesAction{
  final JobDetailsPageState pageState;
  final List<JobType> jobTypes;
  SetAllJobTypesAction(this.pageState, this.jobTypes);
}

class SetPoseImagesAction {
  final JobDetailsPageState pageState;
  final List<GroupImage> poseImages;
  SetPoseImagesAction(this.pageState, this.poseImages);
}

class DeleteReminderFromJobAction{
  final JobDetailsPageState pageState;
  final JobReminder reminder;
  DeleteReminderFromJobAction(this.pageState, this.reminder);
}

class SetNewInvoice{
  final JobDetailsPageState pageState;
  final Invoice invoice;
  SetNewInvoice(this.pageState, this.invoice);
}

class DeleteInvoiceFromLocalStateAction{
  final JobDetailsPageState pageState;
  DeleteInvoiceFromLocalStateAction(this.pageState);
}

class SetSunsetTimeForJobAction{
  final JobDetailsPageState pageState;
  final DateTime sunset;
  SetSunsetTimeForJobAction(this.pageState, this.sunset);
}

class FetchTimeOfSunsetJobAction{
  final JobDetailsPageState pageState;
  FetchTimeOfSunsetJobAction(this.pageState);
}

class FetchJobPosesAction {
  final JobDetailsPageState pageState;
  FetchJobPosesAction(this.pageState);
}

class JobInstagramSelectedAction{
  final JobDetailsPageState pageState;
  JobInstagramSelectedAction(this.pageState);
}

class SaveStageCompleted{
  final JobDetailsPageState pageState;
  final Job job;
  final int stageIndex;
  SaveStageCompleted(this.pageState, this.job, this.stageIndex);
}

class UndoStageAction{
  final JobDetailsPageState pageState;
  final Job job;
  final int stageIndex;
  UndoStageAction(this.pageState, this.job, this.stageIndex);
}

class SetNewStagAnimationIndex{
  final JobDetailsPageState pageState;
  final int newStagAnimationIndex;
  SetNewStagAnimationIndex(this.pageState, this.newStagAnimationIndex);
}

class SetExpandedIndexAction{
  final JobDetailsPageState pageState;
  final int index;
  SetExpandedIndexAction(this.pageState, this.index);
}

class RemoveExpandedIndexAction{
  final JobDetailsPageState pageState;
  final int index;
  RemoveExpandedIndexAction(this.pageState, this.index);
}

class DeleteJobAction{
  final JobDetailsPageState pageState;
  DeleteJobAction(this.pageState);
}

class SetClientAction{
  final JobDetailsPageState pageState;
  final Client client;
  SetClientAction(this.pageState, this.client);
}

class UpdateScrollOffset{
  final JobDetailsPageState pageState;
  final double offset;
  UpdateScrollOffset(this.pageState, this.offset);
}

class UpdateJobTimeAction{
  final JobDetailsPageState pageState;
  final DateTime newTime;
  UpdateJobTimeAction(this.pageState, this.newTime);
}

class UpdateJobEndTimeAction{
  final JobDetailsPageState pageState;
  final DateTime newTime;
  UpdateJobEndTimeAction(this.pageState, this.newTime);
}

class UpdateJobDateAction{
  final JobDetailsPageState pageState;
  UpdateJobDateAction(this.pageState);
}

class SaveUpdatedJobAction{
  final JobDetailsPageState pageState;
  final Job job;
  SaveUpdatedJobAction(this.pageState, this.job);
}

class SetEventMapAction{
  final JobDetailsPageState pageState;
  final List<Job> upcomingJobs;
  SetEventMapAction(this.pageState, this.upcomingJobs);
}

class FetchJobDetailsLocationsAction{
  final JobDetailsPageState pageState;
  FetchJobDetailsLocationsAction(this.pageState);
}

class SetLocationsAction{
  final JobDetailsPageState pageState;
  final List<Location> locations;
  final List<File> imageFiles;
  SetLocationsAction(this.pageState, this.locations, this.imageFiles);
}

class FetchJobsForDateSelection{
  final JobDetailsPageState pageState;
  FetchJobsForDateSelection(this.pageState);
}

class SetNewSelectedLocation{
  final JobDetailsPageState pageState;
  final Location location;
  SetNewSelectedLocation(this.pageState, this.location);
}

class UpdateNewLocationAction{
  final JobDetailsPageState pageState;
  final Location location;
  UpdateNewLocationAction(this.pageState, this.location);
}

class UpdateJobNameAction{
  final JobDetailsPageState pageState;
  final String jobName;
  UpdateJobNameAction(this.pageState, this.jobName);
}

class SaveJobNameChangeAction{
  final JobDetailsPageState pageState;
  SaveJobNameChangeAction(this.pageState);
}

class UpdateSelectedJobTypeAction{
  final JobDetailsPageState pageState;
  final JobType jobType;
  UpdateSelectedJobTypeAction(this.pageState, this.jobType);
}

class SaveUpdatedJobTypeAction{
  final JobDetailsPageState pageState;
  SaveUpdatedJobTypeAction(this.pageState);
}

class FetchJobDetailsPricePackagesAction{
  final JobDetailsPageState pageState;
  FetchJobDetailsPricePackagesAction(this.pageState);
}

class UpdateSelectedPricePackageAction{
  final JobDetailsPageState pageState;
  final PriceProfile selectedPriceProfile;
  UpdateSelectedPricePackageAction(this.pageState, this.selectedPriceProfile);
}

class SaveUpdatedPricePackageAction{
  final JobDetailsPageState pageState;
  final String oneTimePrice;
  SaveUpdatedPricePackageAction(this.pageState, this.oneTimePrice);
}

class SetPricingProfiles{
  final JobDetailsPageState pageState;
  final List<PriceProfile> priceProfiles;
  SetPricingProfiles(this.pageState, this.priceProfiles);
}

class AddToAddOnCostAction{
  final JobDetailsPageState pageState;
  final int amountToAdd;
  AddToAddOnCostAction(this.pageState, this.amountToAdd);
}

class SaveAddOnCostAction{
  final JobDetailsPageState pageState;
  SaveAddOnCostAction(this.pageState);
}

class ClearUnsavedDepositAction{
  final JobDetailsPageState pageState;
  ClearUnsavedDepositAction(this.pageState);
}

class AddToTipAction{
  final JobDetailsPageState pageState;
  final int amountToAdd;
  AddToTipAction(this.pageState, this.amountToAdd);
}

class SaveTipChangeAction{
  final JobDetailsPageState pageState;
  SaveTipChangeAction(this.pageState);
}

class ClearUnsavedTipAction{
  final JobDetailsPageState pageState;
  ClearUnsavedTipAction(this.pageState);
}

class SetDocumentPathAction{
  final JobDetailsPageState pageState;
  final String documentPath;
  SetDocumentPathAction(this.pageState, this.documentPath);
}

class OnDeleteInvoiceSelectedAction{
  final JobDetailsPageState pageState;
  final Invoice invoice;
  OnDeleteInvoiceSelectedAction(this.pageState, this.invoice);
}

class InvoiceSentAction{
  final JobDetailsPageState pageState;
  final Invoice invoice;
  InvoiceSentAction(this.pageState, this.invoice);
}

class SetJobAction{
  final JobDetailsPageState pageState;
  final Job job;
  SetJobAction(this.pageState, this.job);
}

class ClearPreviousStateAction {
  final JobDetailsPageState pageState;
  ClearPreviousStateAction(this.pageState);
}

