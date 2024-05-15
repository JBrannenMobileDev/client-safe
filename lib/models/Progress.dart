import 'package:intl/intl.dart';

class Progress {
  int? id;
  double progress;
  bool previewClientPortal;
  bool setupBrand;
  bool createJobType;
  bool createPricePackage;
  bool addClient;
  bool createJob;
  bool createContract;
  bool addContractToJob;
  bool addInvoiceToJob;
  bool addQuestionnaireToJob;
  bool browsePoses;
  bool addPosesToJob;
  bool inputSingleExpense;
  bool createLocation;
  bool canShow = true;

  Progress({
    this.progress = 0.0,
    this.previewClientPortal = false,
    this.setupBrand = false,
    this.createJobType = false,
    this.createPricePackage = false,
    this.addClient = false,
    this.createJob = false,
    this.createContract = false,
    this.addContractToJob = false,
    this.addInvoiceToJob = false,
    this.addQuestionnaireToJob = false,
    this.browsePoses = false,
    this.addPosesToJob = false,
    this.inputSingleExpense = false,
    this.createLocation = false,
    this.id,
});

  double getProgressValue() {
    double progress = 0.0;
    if(previewClientPortal) progress = progress + 7.1428;
    if(setupBrand) progress = progress + 7.1428;
    if(createJobType) progress = progress + 7.1428;
    if(createPricePackage) progress = progress + 7.1428;
    if(addClient) progress = progress + 7.1428;
    if(createJob) progress = progress + 7.1428;
    if(createContract) progress = progress + 7.1428;
    if(addContractToJob) progress = progress + 7.1428;
    if(addInvoiceToJob) progress = progress + 7.1428;
    if(addQuestionnaireToJob) progress = progress + 7.1428;
    if(browsePoses) progress = progress + 7.1428;
    if(addPosesToJob) progress = progress + 7.1428;
    if(inputSingleExpense) progress = progress + 7.1428;
    if(createLocation) progress = progress + 7.1428;
    return progress;
  }

  String getProgressString() {
    String result = '0';
    double progress = getProgressValue();
    if(progress > 95) progress = 100;
    result = progress.toStringAsFixed(0);
    return result;
  }

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'progress' : progress,
      'previewClientPortal' : previewClientPortal,
      'setupBrand' : setupBrand,
      'createJobType' : createJobType,
      'createPricePackage' : createPricePackage,
      'addClient' : addClient,
      'createJob' : createJob,
      'createContract' : createContract,
      'addContractToJob' : addContractToJob,
      'addInvoiceToJob' : addInvoiceToJob,
      'addQuestionnaireToJob' : addQuestionnaireToJob,
      'browsePoses' : browsePoses,
      'addPosesToJob' : addPosesToJob,
      'inputSingleExpense' : inputSingleExpense,
      'createLocation' : createLocation,
    };
  }

  static Progress fromMap(Map<String, dynamic> map) {
    return Progress(
      id: map['id'],
      progress: map['progress'],
      previewClientPortal: map['previewClientPortal'],
      setupBrand: map['setupBrand'],
      createJobType: map['createJobType'],
      createPricePackage: map['createPricePackage'],
      addClient: map['addClient'],
      createJob: map['createJob'],
      createContract: map['createContract'],
      addContractToJob: map['addContractToJob'],
      addInvoiceToJob: map['addInvoiceToJob'],
      addQuestionnaireToJob: map['addQuestionnaireToJob'],
      browsePoses: map['browsePoses'],
      addPosesToJob: map['addPosesToJob'],
      inputSingleExpense: map['inputSingleExpense'],
      createLocation: map['createLocation'],
    );
  }
}