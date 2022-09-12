class Contract {
  int id;
  String documentId;
  String contractName;



  Contract({
    this.id,
    this.documentId,
    this.contractName,
  });

  Map<String, dynamic> toMap() {
    return {
      'documentId' : documentId,
      'contractName': contractName,
    };
  }

  static Contract fromMap(Map<String, dynamic> map) {
    return Contract(
      documentId: map['documentId'],
      contractName: map['contractName'],
    );
  }
}