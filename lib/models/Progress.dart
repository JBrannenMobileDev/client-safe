class Progress {
  static const String PREVIEW_CLIENT_PORTAL = 'Preview Client Portal';
  static const String PREVIEW_SAMPLE_JOB = "Preview Sample Job";
  static const String SETUP_BRAND = 'Setup Brand';
  static const String CREATE_JOB_TYPE = 'Create Job Type';
  static const String CREATE_PRICE_PACKAGE = 'Create Price Package';
  static const String ADD_CLIENT = 'Add Client';
  static const String CREATE_JOB = 'Create Job';
  static const String CREATE_CONTRACT = 'Create Contract';
  static const String ADD_CONTRACT_TO_JOB = 'Add Contract to Job';
  static const String ADD_INVOICE_TO_JOB = 'Add Invoice to JOb';
  static const String ADD_QUESTIONNAIRE_TO_JOB = 'Add Questionnaire to Job';
  static const String ADD_POSES_TO_JOB = 'Add Poses to Job';
  static const String CREATE_SINGLE_EXPENSE = 'Create SIngle Expense';
  static const String CREATE_LOCATION = 'Create Location';
  static const String SHARED_WITH_FRIEND = 'Shared With Friend';
  static const String ADD_LOCATION_TO_JOB = 'Add Location to Job';
  static const String CREATE_RECURRING_EXPENSE = 'Create Recurring Expense';

  int? id;
  bool previewClientPortal;
  bool previewSampleJob;
  bool setupBrand;
  bool createJobType;
  bool createPricePackage;
  bool addClient;
  bool createJob;
  bool createContract;
  bool addContractToJob;
  bool addInvoiceToJob;
  bool addQuestionnaireToJob;
  bool addPosesToJob;
  bool createLocation;
  bool sharedWithFriend;
  bool addLocationToJob;
  bool createSingleExpense;
  bool createRecurringExpense;
  bool canShow;

  Progress({
    this.previewClientPortal = false,
    this.previewSampleJob = false,
    this.setupBrand = false,
    this.createJobType = false,
    this.createPricePackage = false,
    this.addClient = false,
    this.createJob = false,
    this.createContract = false,
    this.addContractToJob = false,
    this.addInvoiceToJob = false,
    this.addQuestionnaireToJob = false,
    this.addPosesToJob = false,
    this.createLocation = false,
    this.sharedWithFriend = false,
    this.addLocationToJob = false,
    this.createSingleExpense = false,
    this.createRecurringExpense = false,
    this.id,
    this.canShow = true,
});

  bool isComplete() {
    return getProgressValue() == 100;
  }

  double getProgressValue() {
    double progress = 0.0;
    if(previewClientPortal) progress = progress + 5.88;
    if(previewSampleJob) progress = progress + 5.88;
    if(setupBrand) progress = progress + 5.88;
    if(createJobType) progress = progress + 5.88;
    if(createPricePackage) progress = progress + 5.88;
    if(addClient) progress = progress + 5.88;
    if(createJob) progress = progress + 5.88;
    if(createContract) progress = progress + 5.88;
    if(addContractToJob) progress = progress + 5.88;
    if(addInvoiceToJob) progress = progress + 5.88;
    if(addQuestionnaireToJob) progress = progress + 5.88;
    if(addPosesToJob) progress = progress + 5.88;
    if(createLocation) progress = progress + 5.88;
    if(sharedWithFriend) progress = progress + 5.88;
    if(addLocationToJob) progress = progress + 5.88;
    if(createSingleExpense) progress = progress + 5.88;
    if(createRecurringExpense) progress = progress + 5.88;
    if(progress > 98) progress = 100;
    return progress/100;
  }

  String getProgressString() {
    String result = '0';
    double progress = getProgressValue()*100;
    result = progress.toStringAsFixed(0);
    return result;
  }

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'previewClientPortal' : previewClientPortal,
      'previewSampleJob' : previewSampleJob,
      'setupBrand' : setupBrand,
      'createJobType' : createJobType,
      'createPricePackage' : createPricePackage,
      'addClient' : addClient,
      'createJob' : createJob,
      'createContract' : createContract,
      'addContractToJob' : addContractToJob,
      'addInvoiceToJob' : addInvoiceToJob,
      'addQuestionnaireToJob' : addQuestionnaireToJob,
      'addPosesToJob' : addPosesToJob,
      'createLocation' : createLocation,
      'sharedWithFriend' : sharedWithFriend,
      'addLocationToJob' : addLocationToJob,
      'createSingleExpense' : createSingleExpense,
      'createRecurringExpense' : createRecurringExpense,
      'canShow' : canShow,
    };
  }

  static Progress fromMap(Map<String, dynamic> map) {
    return Progress(
      id: map['id'],
      previewClientPortal: map['previewClientPortal'] ?? false,
      previewSampleJob: map['previewSampleJob'] ?? false,
      setupBrand: map['setupBrand'] ?? false,
      createJobType: map['createJobType'] ?? false,
      createPricePackage: map['createPricePackage'] ?? false,
      addClient: map['addClient'] ?? false,
      createJob: map['createJob'] ?? false,
      createContract: map['createContract'] ?? false,
      addContractToJob: map['addContractToJob'] ?? false,
      addInvoiceToJob: map['addInvoiceToJob'] ?? false,
      addQuestionnaireToJob: map['addQuestionnaireToJob'] ?? false,
      addPosesToJob: map['addPosesToJob'] ?? false,
      createLocation: map['createLocation'] ?? false,
      sharedWithFriend: map['sharedWithFriend'] ?? false,
      addLocationToJob: map['addLocationToJob'] ?? false,
      createSingleExpense: map['createSingleExpense'] ?? false,
      createRecurringExpense: map['createRecurringExpense'] ?? false,
      canShow: map['canShow'] ?? true,
    );
  }
}