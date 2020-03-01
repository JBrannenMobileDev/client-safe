import 'package:client_safe/models/Client.dart';
import 'package:client_safe/models/Event.dart';
import 'package:client_safe/models/Job.dart';
import 'package:client_safe/models/Location.dart';
import 'package:client_safe/models/PriceProfile.dart';
import 'package:client_safe/pages/job_details_page/JobDetailsPageState.dart';

class SetJobInfo{
  final JobDetailsPageState pageState;
  final Job job;
  SetJobInfo(this.pageState, this.job);
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

class UpdateJobDateAction{
  final JobDetailsPageState pageState;
  final DateTime newDate;
  UpdateJobDateAction(this.pageState, this.newDate);
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
  SetLocationsAction(this.pageState, this.locations);
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
  final String jobType;
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
  SaveUpdatedPricePackageAction(this.pageState);
}

class SetPricingProfiles{
  final JobDetailsPageState pageState;
  final List<PriceProfile> priceProfiles;
  SetPricingProfiles(this.pageState, this.priceProfiles);
}