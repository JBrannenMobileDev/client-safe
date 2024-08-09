class Progress {
  static const String PREVIEW_CLIENT_PORTAL = 'Preview Client Portal';
  static const String PREVIEW_SAMPLE_JOB = "Preview Sample Job";
  static const String SETUP_BRAND = 'Setup Brand';
  static const String CREATE_SESSION_TYPE = 'Create Sessions Type';
  static const String ADD_CLIENT = 'Add Client';
  static const String CREATE_JOB = 'Create Job';
  static const String CREATE_CONTRACT = 'Create Contract';
  static const String ADD_CONTRACT_TO_JOB = 'Add Contract to Job';
  static const String ADD_INVOICE_TO_JOB = 'Add Invoice to JOb';
  static const String ADD_QUESTIONNAIRE_TO_JOB = 'Add Questionnaire to Job';
  static const String ADD_POSES_TO_JOB = 'Add Poses to Job';
  static const String CREATE_SINGLE_EXPENSE = 'Create SIngle Expense';
  static const String CREATE_LOCATION = 'Create Location';
  static const String ADD_LOCATION_TO_JOB = 'Add Location to Job';
  static const String SHARED_WITH_FRIEND = 'Shared With Friend';
  static const String CREATE_RECURRING_EXPENSE = 'Create Recurring Expense';

  int? id;
  bool previewClientPortal;
  bool previewClientPortalSent;
  bool previewSampleJob;
  bool previewSampleJobSent;
  bool setupBrand;
  bool setupBrandSent;
  bool createSessionType;
  bool createSessionTypeSent;
  bool addClient;
  bool addClientSent;
  bool createJob;
  bool createJobSent;
  bool createContract;
  bool createContractSent;
  bool addContractToJob;
  bool addContractToJobSent;
  bool addInvoiceToJob;
  bool addInvoiceToJobSent;
  bool addQuestionnaireToJob;
  bool addQuestionnaireToJobSent;
  bool addPosesToJob;
  bool addPosesToJobSent;
  bool createLocation;
  bool createLocationSent;
  bool sharedWithFriend;
  bool sharedWithFriendSent;
  bool addLocationToJob;
  bool addLocationToJobSent;
  bool createSingleExpense;
  bool createSingleExpenseSent;
  bool createRecurringExpense;
  bool createRecurringExpenseSent;
  bool canShow;

  Progress({
    this.previewClientPortal = false,
    this.previewClientPortalSent = false,
    this.previewSampleJob = false,
    this.previewSampleJobSent = false,
    this.setupBrand = false,
    this.setupBrandSent = false,
    this.createSessionType = false,
    this.createSessionTypeSent = false,
    this.addClient = false,
    this.addClientSent = false,
    this.createJob = false,
    this.createJobSent = false,
    this.createContract = false,
    this.createContractSent = false,
    this.addContractToJob = false,
    this.addContractToJobSent = false,
    this.addInvoiceToJob = false,
    this.addInvoiceToJobSent = false,
    this.addQuestionnaireToJob = false,
    this.addQuestionnaireToJobSent = false,
    this.addPosesToJob = false,
    this.addPosesToJobSent = false,
    this.createLocation = false,
    this.createLocationSent = false,
    this.sharedWithFriend = false,
    this.sharedWithFriendSent = false,
    this.addLocationToJob = false,
    this.addLocationToJobSent = false,
    this.createSingleExpense = false,
    this.createSingleExpenseSent = false,
    this.createRecurringExpense = false,
    this.createRecurringExpenseSent = false,
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
    if(createSessionType) progress = progress + 5.88;
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
      'previewClientPortalSent' : previewClientPortalSent,
      'previewSampleJob' : previewSampleJob,
      'previewSampleJobSent' : previewSampleJobSent,
      'setupBrand' : setupBrand,
      'setupBrandSent' : setupBrandSent,
      'createSessionType' : createSessionType,
      'createSessionTypeSent' : createSessionTypeSent,
      'addClient' : addClient,
      'addClientSent' : addClientSent,
      'createJob' : createJob,
      'createJobSent' : createJobSent,
      'createContract' : createContract,
      'createContractSent' : createContractSent,
      'addContractToJob' : addContractToJob,
      'addContractToJobSent' : addContractToJobSent,
      'addInvoiceToJob' : addInvoiceToJob,
      'addInvoiceToJobSent' : addInvoiceToJobSent,
      'addQuestionnaireToJob' : addQuestionnaireToJob,
      'addQuestionnaireToJobSent' : addQuestionnaireToJobSent,
      'addPosesToJob' : addPosesToJob,
      'addPosesToJobSent' : addPosesToJobSent,
      'createLocation' : createLocation,
      'createLocationSent' : createLocationSent,
      'sharedWithFriend' : sharedWithFriend,
      'sharedWithFriendSent' : sharedWithFriendSent,
      'addLocationToJob' : addLocationToJob,
      'addLocationToJobSent' : addLocationToJobSent,
      'createSingleExpense' : createSingleExpense,
      'createSingleExpenseSent' : createSingleExpenseSent,
      'createRecurringExpense' : createRecurringExpense,
      'createRecurringExpenseSent' : createRecurringExpenseSent,
      'canShow' : canShow,
    };
  }

  static Progress fromMap(Map<String, dynamic> map) {
    return Progress(
      id: map['id'],
      previewClientPortal: map['previewClientPortal'] ?? false,
      previewClientPortalSent: map['previewClientPortalSent'] ?? false,
      previewSampleJob: map['previewSampleJob'] ?? false,
      previewSampleJobSent: map['previewSampleJobSent'] ?? false,
      setupBrand: map['setupBrand'] ?? false,
      setupBrandSent: map['setupBrandSent'] ?? false,
      createSessionType: map['createSessionType'] ?? false,
      createSessionTypeSent: map['createSessionTypeSent'] ?? false,
      addClient: map['addClient'] ?? false,
      addClientSent: map['addClientSent'] ?? false,
      createJob: map['createJob'] ?? false,
      createJobSent: map['createJobSent'] ?? false,
      createContract: map['createContract'] ?? false,
      createContractSent: map['createContractSent'] ?? false,
      addContractToJob: map['addContractToJob'] ?? false,
      addContractToJobSent: map['addContractToJobSent'] ?? false,
      addInvoiceToJob: map['addInvoiceToJob'] ?? false,
      addInvoiceToJobSent: map['addInvoiceToJobSent'] ?? false,
      addQuestionnaireToJob: map['addQuestionnaireToJob'] ?? false,
      addQuestionnaireToJobSent: map['addQuestionnaireToJobSent'] ?? false,
      addPosesToJob: map['addPosesToJob'] ?? false,
      addPosesToJobSent: map['addPosesToJobSent'] ?? false,
      createLocation: map['createLocation'] ?? false,
      createLocationSent: map['createLocationSent'] ?? false,
      sharedWithFriend: map['sharedWithFriend'] ?? false,
      sharedWithFriendSent: map['sharedWithFriendSent'] ?? false,
      addLocationToJob: map['addLocationToJob'] ?? false,
      addLocationToJobSent: map['addLocationToJobSent'] ?? false,
      createSingleExpense: map['createSingleExpense'] ?? false,
      createSingleExpenseSent: map['createSingleExpenseSent'] ?? false,
      createRecurringExpense: map['createRecurringExpense'] ?? false,
      createRecurringExpenseSent: map['createRecurringExpenseSent'] ?? false,
      canShow: map['canShow'] ?? true,
    );
  }

  bool canSend(String typeToSend) {
    bool canSend = false;
    switch(typeToSend) {
      case Progress.PREVIEW_CLIENT_PORTAL:
        canSend = !previewClientPortalSent;
        break;
      case Progress.PREVIEW_SAMPLE_JOB:
        canSend = !previewSampleJobSent;
        break;
      case Progress.SETUP_BRAND:
        canSend = !setupBrandSent;
        break;
      case Progress.CREATE_SESSION_TYPE:
        canSend = !createSessionTypeSent;
        break;
      case Progress.ADD_CLIENT:
        canSend = !addClientSent;
        break;
      case Progress.CREATE_JOB:
        canSend = !createJobSent;
        break;
      case Progress.CREATE_CONTRACT:
        canSend = !createContractSent;
        break;
      case Progress.ADD_CONTRACT_TO_JOB:
        canSend = !addContractToJobSent;
        break;
      case Progress.ADD_INVOICE_TO_JOB:
        canSend = !addInvoiceToJobSent;
        break;
      case Progress.ADD_QUESTIONNAIRE_TO_JOB:
        canSend = !addQuestionnaireToJobSent;
        break;
      case Progress.CREATE_SINGLE_EXPENSE:
        canSend = !createSingleExpenseSent;
        break;
      case Progress.CREATE_LOCATION:
        canSend = !createLocationSent;
        break;
      case Progress.ADD_LOCATION_TO_JOB:
        canSend = !addLocationToJobSent;
        break;
      case Progress.SHARED_WITH_FRIEND:
        canSend = !sharedWithFriendSent;
        break;
    }
    return canSend;
  }
}