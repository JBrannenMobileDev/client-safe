import 'dart:typed_data';

import 'package:client_safe/AppState.dart';
import 'package:client_safe/data_layer/local_db/daos/ClientDao.dart';
import 'package:client_safe/data_layer/local_db/daos/InvoiceDao.dart';
import 'package:client_safe/data_layer/local_db/daos/JobDao.dart';
import 'package:client_safe/data_layer/local_db/daos/NextInvoiceNumberDao.dart';
import 'package:client_safe/models/Client.dart';
import 'package:client_safe/models/Invoice.dart';
import 'package:client_safe/models/Job.dart';
import 'package:client_safe/models/JobStage.dart';
import 'package:client_safe/pages/IncomeAndExpenses/IncomeAndExpensesPageActions.dart';
import 'package:client_safe/pages/dashboard_page/DashboardPageActions.dart';
import 'package:client_safe/pages/job_details_page/JobDetailsActions.dart';
import 'package:client_safe/pages/new_invoice_page/NewInvoicePageActions.dart';
import 'package:client_safe/pages/new_invoice_page/NewInvoicePageState.dart';
import 'package:client_safe/utils/PdfUtil.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
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
    if(action is SaveNewInvoiceAction){
      _saveInvoice(store, action, next);
    }
  }

  void _saveInvoice(Store<AppState> store, action, NextDispatcher next) async {
    NewInvoicePageState pageState = store.state.newInvoicePageState;
    await InvoiceDao.insertOrUpdate(
        Invoice(
          clientId: pageState.selectedJob.clientId,
          invoiceId: pageState.invoiceNumber,
          clientName: pageState.selectedJob.clientName,
          jobName: pageState.selectedJob.jobTitle,
          jobId: pageState.selectedJob.id,
          unpaidAmount: pageState.unpaidAmount,
          createdDate: DateTime.now(),
          dueDate: pageState.dueDate,
          depositPaid: pageState.selectedJob.hasCompletedStage(JobStage.STAGE_5_DEPOSIT_RECEIVED),
          invoicePaid: false,
          priceProfile: pageState.selectedJob.priceProfile,
          discount: pageState.discountValue,
          total: pageState.total,
          lineItems: pageState.lineItems,
    ));
    store.dispatch(LoadAllInvoicesAction(store.state.incomeAndExpensesPageState));
    Job selectedJob = pageState.selectedJob;
    selectedJob.invoice = await InvoiceDao.getInvoiceById(pageState.invoiceNumber);
    await JobDao.update(selectedJob);
    store.dispatch(LoadJobsAction(store.state.dashboardPageState));
    store.dispatch(SetNewInvoice(store.state.jobDetailsPageState, selectedJob.invoice));
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
    NewInvoicePageState pageState = store.state.newInvoicePageState;
    Client client = await ClientDao.getClientById(pageState.selectedJob.clientId);
    final Document pdf = Document();

    pdf.addPage(MultiPage(
        theme: Theme.withFont(
          base: Font.ttf(await rootBundle.load('assets/fonts/Raleway-Regular.ttf')),
          bold: Font.ttf(await rootBundle.load('assets/fonts/Raleway-Bold.ttf')),
          italic: Font.ttf(await rootBundle.load('assets/fonts/simplicity.ttf')),
          boldItalic: Font.ttf(await rootBundle.load('assets/fonts/Raleway-Bold.ttf')),
        ),
        pageFormat:
        PdfPageFormat.letter.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
        crossAxisAlignment: CrossAxisAlignment.start,
        header: (Context context) {
          if (context.pageNumber == 1) {
            return null;
          }
          return Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              padding: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              decoration: const BoxDecoration(
                  border: BoxBorder(
                      bottom: true, width: 0.5, color: PdfColors.grey)),
              child: Text('Vintage Vibes Photography Invoice',
                  style: Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.grey)));
        },
        footer: (Context context) {
          return Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
              child: Text(
                  'Page ${context.pageNumber} of ${context.pagesCount}',
                  style: Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.grey)));
        },
        build: (Context context) => <Widget>[
          Header(
              level: 2,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Vintage Vibes Photography', textScaleFactor: 2.0),
                  ])),
          Padding(
            padding: EdgeInsets.only(top: 32.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Invoice for', textScaleFactor: 1.5),
                    Text(pageState.selectedJob.clientName, textScaleFactor: 1.5),
                    client.phone.isNotEmpty ? Text(client.phone.toString(), textScaleFactor: 1.5) : SizedBox(),
                    client.email.isNotEmpty ? Text(client.email.toString(), textScaleFactor: 1.5) : SizedBox(),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(pageState.invoiceNumber.toString(), textScaleFactor: 1.5),
                    Text('Sent: ' + DateFormat('MMM dd, yyyy').format(DateTime.now()), textScaleFactor: 1.5),
                    pageState.dueDate != null ? Text('Due: ' + DateFormat('MMM dd, yyyy').format(pageState.dueDate), textScaleFactor: 1.5) : SizedBox(),
                  ],
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.only(top: 64.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    width: 198.0,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Item',
                      textScaleFactor: 1.5,
                      textAlign: TextAlign.left,
                    ),
                ),
                Row(

                  children: <Widget>[
                    Container(
                      width: 70.0,
                      alignment: Alignment.centerRight,
                      child: Text(
                          'Quantity',
                          textScaleFactor: 1.5,
                          textAlign: TextAlign.right
                      ),
                    ),
                    Container(
                      width: 100.0,
                      alignment: Alignment.centerRight,
                      child: Text(
                          'Price',
                          textScaleFactor: 1.5,
                          textAlign: TextAlign.right
                      ),
                    ),
                    Container(
                      width: 100.0,
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Amount',
                        textScaleFactor: 1.5,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Container(
                height: 1.0,
                width: 468.0,
                color: PdfColor.fromHex('0x000000'),
              )
          ),

          Padding(
            padding: EdgeInsets.only(top: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
            ListView.builder(
            itemCount: pageState.lineItems.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 250.0,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    pageState.lineItems.elementAt(index).itemName,
                    textScaleFactor: 1.5,
                    textAlign: TextAlign.left,
                  ),
                );
              },
            ),
                Row(

                  children: <Widget>[
                    ListView.builder(
                        itemCount: pageState.lineItems.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 18.0,
                            alignment: Alignment.centerRight,
                            child: Text(
                                  pageState.lineItems.elementAt(index).itemQuantity.toString(),
                                  textScaleFactor: 1.5,
                                  textAlign: TextAlign.right
                              ),
                          );
                        },
                      ),
                    ListView.builder(
                        itemCount: pageState.lineItems.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 100.0,
                            alignment: Alignment.centerRight,
                            child: Text(
                                '\$' + pageState.lineItems.elementAt(index).itemPrice.truncate().toString(),
                                textScaleFactor: 1.5,
                                textAlign: TextAlign.right
                            ),
                          );
                        },
                    ),
                    ListView.builder(
                        itemCount: pageState.lineItems.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 100.0,
                            alignment: Alignment.centerRight,
                            child: Text(
                              '\$' + pageState.lineItems.elementAt(index).getTotal().truncate().toString(),
                              textScaleFactor: 1.5,
                              textAlign: TextAlign.right,
                            ),
                          );
                        },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
              padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
              child: Container(
                height: 1.0,
                width: 468.0,
                color: PdfColor.fromHex('0x000000'),
              )
          ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 198.0,
                alignment: Alignment.centerLeft,
                child: Text(
                  '',
                  textScaleFactor: 1.5,
                  textAlign: TextAlign.left,
                ),
              ),
              Row(

                children: <Widget>[
                  Container(
                    width: 70.0,
                    alignment: Alignment.centerRight,
                    child: Text(
                        '',
                        textScaleFactor: 1.5,
                        textAlign: TextAlign.right
                    ),
                  ),
                  Container(
                    width: 100.0,
                    alignment: Alignment.centerRight,
                    child: Text(
                        'Subtotal',
                        textScaleFactor: 1.5,
                        textAlign: TextAlign.right
                    ),
                  ),
                  Container(
                    width: 100.0,
                    alignment: Alignment.centerRight,
                    child: Text(
                      '\$' + pageState.total.truncate().toString(),
                      textScaleFactor: 1.5,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ],
          ),

          pageState.depositValue > 0 && pageState.selectedJob.hasCompletedStage(JobStage.STAGE_5_DEPOSIT_RECEIVED) ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 198.0,
                alignment: Alignment.centerLeft,
                child: Text(
                  '',
                  textScaleFactor: 1.5,
                  textAlign: TextAlign.left,
                ),
              ),
              Row(

                children: <Widget>[
                  Container(
                    width: 70.0,
                    alignment: Alignment.centerRight,
                    child: Text(
                        '',
                        textScaleFactor: 1.5,
                        textAlign: TextAlign.right
                    ),
                  ),
                  Container(
                    width: 100.0,
                    alignment: Alignment.centerRight,
                    child: Text(
                        'Deposit',
                        textScaleFactor: 1.5,
                        textAlign: TextAlign.right
                    ),
                  ),
                  Container(
                    width: 100.0,
                    alignment: Alignment.centerRight,
                    child: Text(
                      '-\$' + pageState.depositValue.truncate().toString(),
                      textScaleFactor: 1.5,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ],
          ) : SizedBox(),

          pageState.discountValue > 0 ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 198.0,
                alignment: Alignment.centerLeft,
                child: Text(
                  '',
                  textScaleFactor: 1.5,
                  textAlign: TextAlign.left,
                ),
              ),
              Row(

                children: <Widget>[
                  Container(
                    width: 70.0,
                    alignment: Alignment.centerRight,
                    child: Text(
                        '',
                        textScaleFactor: 1.5,
                        textAlign: TextAlign.right
                    ),
                  ),
                  Container(
                    width: 100.0,
                    alignment: Alignment.centerRight,
                    child: Text(
                        'Discount',
                        textScaleFactor: 1.5,
                        textAlign: TextAlign.right
                    ),
                  ),
                  Container(
                    width: 100.0,
                    alignment: Alignment.centerRight,
                    child: Text(
                      '-\$' + pageState.discountValue.truncate().toString(),
                      textScaleFactor: 1.5,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ],
          ) : SizedBox(),

          Row(

            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                  child: Container(
                    height: 0.0,
                    width: 263.0,
                  )
              ),
              Padding(
                  padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                  child: Container(
                    height: 1.0,
                    width: 205.0,
                    color: PdfColor.fromHex('0x000000'),
                  )
              ),
            ],
          ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 198.0,
                alignment: Alignment.centerLeft,
                child: Text(
                  '',
                  textScaleFactor: 1.5,
                  textAlign: TextAlign.left,
                ),
              ),
              Row(

                children: <Widget>[
                  Container(
                    width: 50.0,
                    alignment: Alignment.centerRight,
                    child: Text(
                        '',
                        textScaleFactor: 1.5,
                        textAlign: TextAlign.right
                    ),
                  ),
                  Container(
                    width: 120.0,
                    alignment: Alignment.centerRight,
                    child: Text(
                        'Balance due',
                        textScaleFactor: 1.5,
                        textAlign: TextAlign.right
                    ),
                  ),
                  Container(
                    width: 100.0,
                    alignment: Alignment.centerRight,
                    child: Text(
                      '\$' + pageState.unpaidAmount.truncate().toString(),
                      textScaleFactor: 1.5,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ],
          )

        ]));

    await PdfUtil.savePdfFile(store.state.newInvoicePageState.invoiceNumber, pdf);
  }
}



