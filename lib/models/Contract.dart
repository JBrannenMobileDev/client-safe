class Contract {
  int id;
  String documentId;
  String contractName;
  String photographerSignature;
  String clientSignature;
  String terms;
  bool signedByClient = false;
  bool signedByPhotographer = false;
  DateTime clientSignedDate;
  DateTime photographerSignedDate;



  Contract({
    this.id,
    this.documentId,
    this.contractName,
    this.terms,
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
      'signedByClient' : signedByClient,
      'signedByPhotographer' : signedByPhotographer,
      'photographerSignature' : photographerSignature,
      'clientSignature' : clientSignature,
      'clientSignedDate' : clientSignedDate,
      'photographerSignedDate' : photographerSignedDate,
    };
  }

  static Contract fromMap(Map<String, dynamic> map) {
    return Contract(
      documentId: map['documentId'],
      contractName: map['contractName'],
      terms: map['terms'],
      signedByClient: map['signedByClient'],
      signedByPhotographer: map['signedByPhotographer'],
      photographerSignature: map['photographerSignature'],
      clientSignature: map['clientSignature'],
      photographerSignedDate: map['photographerSignedDate'],
      clientSignedDate: map['clientSignedDate'],
    );
  }
}