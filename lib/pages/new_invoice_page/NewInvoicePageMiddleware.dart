import 'dart:typed_data';

import 'package:client_safe/AppState.dart';
import 'package:client_safe/data_layer/local_db/daos/ClientDao.dart';
import 'package:client_safe/data_layer/local_db/daos/JobDao.dart';
import 'package:client_safe/data_layer/local_db/daos/NextInvoiceNumberDao.dart';
import 'package:client_safe/models/Client.dart';
import 'package:client_safe/models/Job.dart';
import 'package:client_safe/models/JobStage.dart';
import 'package:client_safe/pages/new_invoice_page/NewInvoicePageActions.dart';
import 'package:client_safe/utils/PdfUtil.dart';
import 'package:flutter/services.dart';
import 'package:redux/redux.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart';
import 'package:path_provider/path_provider.dart';

class NewInvoicePageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is FetchAllInvoiceJobsAction) {
      _loadAll(store, action, next);
    }
    if(action is SaveNewLineItemAction){
      _saveNewLineItem(store, action, next);
    }
    if(action is DeleteLineItemAction){
      _deleteLineItem(store, action, next);
    }
    if(action is SaveNewDiscountAction){
      _saveNewDiscount(store, action, next);
    }
    if(action is DeleteDiscountAction){
      _deleteDiscount(store, action, next);
    }
    if(action is UpdateDepositStatusAction){
      _updateDepositStatus(store, action, next);
    }
    if(action is GenerateInvoicePdfAction){
      _generateNewInvoicePdf(store, action, next);
    }
  }

  void _updateDepositStatus(Store<AppState> store, action, NextDispatcher next) async {
    bool isDepositPaid = store.state.newInvoicePageState.selectedJob.isDepositPaid();
    Job selectedJob = store.state.newInvoicePageState.selectedJob;
    if(isDepositPaid) {
      List<JobStage> completedJobStages = selectedJob.completedStages.toList();
      JobStage stageToRemove = JobStage.getStageFromIndex(4);
      completedJobStages = _removeStage(stageToRemove, completedJobStages);
      selectedJob.completedStages = completedJobStages;
      JobStage highestCompletedState;
      for(JobStage completedStage in completedJobStages){
        if(highestCompletedState == null) highestCompletedState = completedStage;
        if(completedStage.value > highestCompletedState.value) highestCompletedState = completedStage;
      }
      if(highestCompletedState != null){
        selectedJob.stage = JobStage.getNextStage(highestCompletedState);
      }else{
        selectedJob.stage = JobStage.getStageFromIndex(1);
      }
      Job jobToSave = Job(
        id: selectedJob.id,
        clientId: selectedJob.clientId,
        clientName: selectedJob.clientName,
        jobTitle: selectedJob.jobTitle,
        selectedDate: selectedJob.selectedDate,
        selectedTime: selectedJob.selectedTime,
        type: selectedJob.type,
        stage: selectedJob.stage,
        completedStages: selectedJob.completedStages,
        location: selectedJob.location,
        priceProfile: selectedJob.priceProfile,
        depositAmount: selectedJob.depositAmount,
      );
      await JobDao.insertOrUpdate(jobToSave);
      store.dispatch(SaveSelectedJobAction(store.state.newInvoicePageState, jobToSave));
    }else {
      List<JobStage> completedJobStages = selectedJob.completedStages.toList();
      JobStage stageToComplete = JobStage.getStageFromIndex(4);
      completedJobStages.add(stageToComplete);
      selectedJob.completedStages = completedJobStages;
      selectedJob.stage = _getNextUncompletedStage(4, selectedJob.completedStages);
      Job jobToSave = Job(
        id: selectedJob.id,
        clientId: selectedJob.clientId,
        clientName: selectedJob.clientName,
        jobTitle: selectedJob.jobTitle,
        selectedDate: selectedJob.selectedDate,
        selectedTime: selectedJob.selectedTime,
        type: selectedJob.type,
        stage: selectedJob.stage,
        completedStages: selectedJob.completedStages,
        location: selectedJob.location,
        priceProfile: selectedJob.priceProfile,
        depositAmount: selectedJob.depositAmount,
      );
      await JobDao.insertOrUpdate(jobToSave);
      store.dispatch(SaveSelectedJobAction(store.state.newInvoicePageState, jobToSave));
    }
  }

  JobStage _getNextUncompletedStage(int stageIndex, List<JobStage> completedStages) {
    JobStage currentStage = JobStage.getStageFromIndex(stageIndex);
    JobStage nextStage = JobStage.getNextStage(currentStage);
    while(_completedStagesContainsNextStage(completedStages, nextStage)){
      nextStage = JobStage.getNextStage(nextStage);
    }
    return nextStage;
  }

  bool _completedStagesContainsNextStage(List<JobStage> completedStages, JobStage nextStage) {
    if(nextStage.stage == JobStage.STAGE_COMPLETED_CHECK) return false;
    bool containsNextStage = false;
    for(JobStage completedStage in completedStages){
      if(completedStage.value == nextStage.value) return true;
    }
    return containsNextStage;
  }

  List<JobStage> _removeStage(JobStage stageToRemove, List<JobStage> completedJobStages) {
    List<JobStage> resultList = List();
    for(JobStage completedStage in completedJobStages){
      if(completedStage.value != stageToRemove.value)resultList.add(completedStage);
    }
    return resultList;
  }

  void _loadAll(Store<AppState> store, FetchAllInvoiceJobsAction action, NextDispatcher next) async {
    List<Client> allClients = await ClientDao.getAllSortedByFirstName();
    int newInvoiceNumber = await NextInvoiceNumberDao.nextNumber();
    List<Job> allJobs = await JobDao.getAllJobs();
    allJobs = allJobs.where((job) => !job.hasCompletedStage(JobStage.STAGE_9_PAYMENT_RECEIVED) && !job.hasCompletedStage(JobStage.STAGE_14_JOB_COMPLETE)).toList();
    store.dispatch(SetAllJobsAction(store.state.newInvoicePageState, allJobs, allClients, newInvoiceNumber));
  }

  void _saveNewLineItem(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
  }

  void _deleteLineItem(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
  }

  void _saveNewDiscount(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
  }

  void _deleteDiscount(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
  }

  void _generateNewInvoicePdf(Store<AppState> store, action, NextDispatcher next) async {
    final Document pdf = Document();
    final font = await rootBundle.load("assets/fonts/Nocturne.ttf");
    final ttf = Font.ttf(font);

    pdf.addPage(Page(
        pageFormat: PdfPageFormat.a4,
        build: (Context context) {
          return Center(
            child: Text("Invoice Demo", style: TextStyle(font: ttf, fontSize: 40, color: PdfColor.fromHex('0x000000'))),
          ); // Center
        }));

    await PdfUtil.savePdfFile(store.state.newInvoicePageState.invoiceNumber, pdf);
    store.dispatch(UpdatePdfSavedFlag(store.state.newInvoicePageState));
  }
}