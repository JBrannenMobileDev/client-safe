import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/JobDao.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:redux/redux.dart';
import 'package:sembast/sembast.dart';
import '../../models/Job.dart';
import '../../models/Proposal.dart';
import '../job_details_page/JobDetailsActions.dart';
import 'ShareWithClientActions.dart';

class ShareWithClientPageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is FetchProfileAction){
      fetchProfile(store, action, next);
    }
    if(action is SaveProposalAction){
      saveProposal(store, action, next);
    }
  }

  void saveProposal(Store<AppState> store, SaveProposalAction action, NextDispatcher next) async {
    Job job = await JobDao.getJobById(action.pageState.job.documentId);
    Proposal proposal = job.proposal;
    proposal.includePoses = action.pageState.posesSelected;
    proposal.includeInvoice = action.pageState.invoiceSelected;
    proposal.includeContract = action.pageState.contractSelected;
    proposal.detailsMessage = action.pageState.clientMessage;
    job.proposal = proposal;
    await JobDao.update(job);
    if(proposal.includeInvoice) {
      await store.dispatch(InvoiceSentAction(store.state.jobDetailsPageState, job.invoice));
    }
    next(SaveProposalAction(store.state.shareWithClientPageState));

    // (await JobDao.getJobsStream()).listen((jobSnapshots) async {
    //   List<Job> jobs = List();
    //   for(RecordSnapshot clientSnapshot in jobSnapshots) {
    //     jobs.add(Job.fromMap(clientSnapshot.value));
    //   }
    //   store.dispatch(SetClientJobsAction(store.state.clientDetailsPageState, jobs));
    // });
  }

  void fetchProfile(Store<AppState> store, FetchProfileAction action, NextDispatcher next) async {
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    next(SetProfileShareWIthClientAction(store.state.shareWithClientPageState, profile));
  }
}