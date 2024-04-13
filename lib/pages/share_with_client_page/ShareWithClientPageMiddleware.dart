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
    if(action is SetClientMessageAction) {
      saveMessage(store, action, next);
    }
    if(action is SetClientShareMessageAction) {
      saveShareMessage(store, action, next);
    }
    if(action is SetPosesCheckBox) {
      savePosesCheckedState(store, action, next);
    }
    if(action is SetContractCheckBox) {
      saveContractCheckedState(store, action, next);
    }
    if(action is SetInvoiceCheckBox) {
      saveInvoiceCheckedState(store, action, next);
    }
    if(action is SetQuestionnairesCheckBox) {
      saveQuestionnairesCheckedState(store, action, next);
    }
  }

  void saveQuestionnairesCheckedState(Store<AppState> store, SetQuestionnairesCheckBox action, NextDispatcher next) async {
    store.dispatch(UpdateQuestionnairesCheckInProgressStateAction(store.state.shareWithClientPageState, true));
    Job job = await JobDao.getJobById(action.pageState.job.documentId);
    job.proposal.includeQuestionnaires = action.checked;
    await JobDao.update(job);
    next(SetQuestionnairesCheckBox(store.state.shareWithClientPageState, action.checked));
  }

  void savePosesCheckedState(Store<AppState> store, SetPosesCheckBox action, NextDispatcher next) async {
    store.dispatch(UpdatePosesCheckInProgressStateAction(store.state.shareWithClientPageState, true));
    Job? job = await JobDao.getJobById(action.pageState!.job!.documentId);
    job!.proposal!.includePoses = action.checked;
    await JobDao.update(job);
    next(SetPosesCheckBox(store.state.shareWithClientPageState, action.checked));
  }

  void saveInvoiceCheckedState(Store<AppState> store, SetInvoiceCheckBox action, NextDispatcher next) async {
    store.dispatch(UpdateInvoiceCheckInProgressStateAction(store.state.shareWithClientPageState, true));
    Job? job = await JobDao.getJobById(action.pageState!.job!.documentId);
    job!.proposal!.includeInvoice = action.checked;
    await JobDao.update(job);
    next(SetInvoiceCheckBox(store.state.shareWithClientPageState, action.checked));
  }

  void saveContractCheckedState(Store<AppState> store, SetContractCheckBox action, NextDispatcher next) async {
    store.dispatch(UpdateContractCheckInProgressStateAction(store.state.shareWithClientPageState, true));
    Job? job = await JobDao.getJobById(action.pageState!.job!.documentId);
    job!.proposal!.includeContract = action.checked;
    await JobDao.update(job);
    next(SetContractCheckBox(store.state.shareWithClientPageState, action.checked));
  }

  void saveMessage(Store<AppState> store, SetClientMessageAction action, NextDispatcher next) async {
    Job? job = await JobDao.getJobById(action.pageState!.job!.documentId);
    job!.proposal!.detailsMessage = action.clientMessage;
    await JobDao.update(job);
    next(SetClientMessageAction(store.state.shareWithClientPageState, action.clientMessage));
  }

  void saveShareMessage(Store<AppState> store, SetClientShareMessageAction action, NextDispatcher next) async {
    Job? job = await JobDao.getJobById(action.pageState!.job!.documentId);
    job!.proposal!.shareMessage = action.clientMessage;
    await JobDao.update(job);
    next(SetClientShareMessageAction(store.state.shareWithClientPageState, action.clientMessage));
  }

  void saveProposal(Store<AppState> store, SaveProposalAction action, NextDispatcher next) async {
    Job? job = await JobDao.getJobById(action.pageState!.job!.documentId);
    Proposal proposal = job!.proposal!;
    proposal.detailsMessage = action.pageState!.clientMessage;

    if(proposal.contract != null && proposal.contract!.firstSharedDate == null){
      proposal.contract!.firstSharedDate = DateTime.now();
    }

    job.proposal = proposal;

    await JobDao.update(job);
    if(proposal.includeInvoice!) {
      await store.dispatch(InvoiceSentAction(store.state.jobDetailsPageState, job.invoice));
    }
    next(SaveProposalAction(store.state.shareWithClientPageState));
  }

  void fetchProfile(Store<AppState> store, FetchProfileAction action, NextDispatcher next) async {
    Profile? profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    next(SetProfileShareWIthClientAction(store.state.shareWithClientPageState, profile));

    List<Job> jobs = (await JobDao.getAllJobs())!.where((job) => job.proposal != null && job.proposal!.detailsMessage != null && job.proposal!.detailsMessage!.isNotEmpty).toList();
    store.dispatch(SetAllJobsAction(store.state.shareWithClientPageState, jobs.reversed.toList()));
  }
}