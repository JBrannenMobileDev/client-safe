class Contract {
  int? id;
  String? documentId;
  String? contractName;
  String? photographerSignature;
  String? clientSignature;
  String? terms;//do not use. remove this field when you have a chance..   Might be never!
  String? jsonTerms;
  String? clientName;
  String? jobDocumentId;
  bool? signedByClient = false;
  bool? signedByPhotographer = false;
  bool? isReviewed = false;
  bool? isVoid = false;
  DateTime? clientSignedDate;
  DateTime? photographerSignedDate;
  DateTime? firstSharedDate;


  Contract({
    this.id,
    this.documentId,
    this.contractName,
    this.terms,
    this.jsonTerms,
    this.signedByClient,
    this.signedByPhotographer,
    this.photographerSignature,
    this.clientSignature,
    this.clientSignedDate,
    this.photographerSignedDate,
    this.firstSharedDate,
    this.isReviewed,
    this.isVoid,
    this.clientName,
    this.jobDocumentId,
  });

  Map<String, dynamic> toMap() {
    return {
      'documentId' : documentId,
      'contractName': contractName,
      'terms' : terms,
      'jsonTerms' : jsonTerms,
      'signedByClient' : signedByClient,
      'signedByPhotographer' : signedByPhotographer,
      'isReviewed' : isReviewed,
      'isVoid' : isVoid,
      'photographerSignature' : photographerSignature,
      'clientSignature' : clientSignature,
      'clientName' : clientName,
      'jobDocumentId' : jobDocumentId,
      'clientSignedDate' : clientSignedDate?.millisecondsSinceEpoch ?? null,
      'photographerSignedDate' : photographerSignedDate?.millisecondsSinceEpoch ?? null,
      'firstSharedDate' : firstSharedDate?.millisecondsSinceEpoch ?? null,
    };
  }

  static Contract fromMap(Map<String, dynamic> map) {
    return Contract(
      documentId: map['documentId'],
      contractName: map['contractName'],
      terms: map['terms'],
      jsonTerms: map['jsonTerms'],
      signedByClient: map['signedByClient'],
      signedByPhotographer: map['signedByPhotographer'],
      isReviewed: map['isReviewed'],
      isVoid: map['isVoid'],
      photographerSignature: map['photographerSignature'],
      clientSignature: map['clientSignature'],
      clientName: map['clientName'],
      jobDocumentId: map['jobDocumentId'],
      photographerSignedDate: map['photographerSignedDate'] != null? DateTime.fromMillisecondsSinceEpoch(map['photographerSignedDate']) : null,
      clientSignedDate: map['clientSignedDate'] != null? DateTime.fromMillisecondsSinceEpoch(map['clientSignedDate']) : null,
      firstSharedDate: map['firstSharedDate'] != null? DateTime.fromMillisecondsSinceEpoch(map['firstSharedDate']) : null,
    );
  }
}