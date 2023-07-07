class Contract {
  int id;
  String documentId;
  String contractName;
  String terms;
  bool signedByClient = false;
  bool signedByPhotographer = false;



  Contract({
    this.id,
    this.documentId,
    this.contractName,
    this.terms,
    this.signedByClient,
    this.signedByPhotographer,
  });

  Map<String, dynamic> toMap() {
    return {
      'documentId' : documentId,
      'contractName': contractName,
      'terms' : terms,
      'signedByClient' : signedByClient,
      'signedByPhotographer' : signedByPhotographer,
    };
  }

  static Contract fromMap(Map<String, dynamic> map) {
    return Contract(
      documentId: map['documentId'],
      contractName: map['contractName'],
      terms: map['terms'],
      signedByClient: map['signedByClient'],
      signedByPhotographer: map['signedByPhotographer'],
    );
  }
}