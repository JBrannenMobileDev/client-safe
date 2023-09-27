class Contract {
  int id;
  String documentId;
  String contractName;
  String photographerSignature;
  String clientSignature;
  String terms;
  String jsonTerms;
  bool signedByClient = false;
  bool signedByPhotographer = false;
  DateTime clientSignedDate;
  DateTime photographerSignedDate;



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
  });

  Map<String, dynamic> toMap() {
    return {
      'documentId' : documentId,
      'contractName': contractName,
      'terms' : terms,
      'jsonTerms' : jsonTerms,
      'signedByClient' : signedByClient,
      'signedByPhotographer' : signedByPhotographer,
      'photographerSignature' : photographerSignature,
      'clientSignature' : clientSignature,
      'clientSignedDate' : clientSignedDate != null ? clientSignedDate.toString() : "",
      'photographerSignedDate' : photographerSignedDate != null ? photographerSignedDate.toString() : "",
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
      photographerSignature: map['photographerSignature'],
      clientSignature: map['clientSignature'],
      photographerSignedDate: map['photographerSignedDate'] != "" && map['photographerSignedDate'] != null ? DateTime.parse(map['photographerSignedDate']) : null,
      clientSignedDate: map['clientSignedDate'] != "" && map['clientSignedDate'] != null ? DateTime.parse(map['clientSignedDate']) : null,
    );
  }
}