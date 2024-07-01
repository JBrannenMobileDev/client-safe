
class PendingEmail{
  int? id;
  String? documentId;
  DateTime sendTime;
  String emailType;
  String toAddress;
  String uid;

  PendingEmail({
    this.id,
    this.documentId,
    required this.sendTime,
    required this.emailType,
    required this.toAddress,
    required this.uid
  });

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'documentId' : documentId,
      'sendTime' : sendTime.millisecondsSinceEpoch,
      'emailType' : emailType,
      'toAddress' : toAddress,
      'uid' : uid
    };
  }

  static PendingEmail fromMap(Map<String, dynamic> map) {
    return PendingEmail(
      id: map['id'],
      documentId: map['documentId'],
      sendTime: DateTime.fromMillisecondsSinceEpoch(map['sendTime']),
      emailType: map['emailType'],
      toAddress: map['toAddress'],
      uid: map['uid']
    );
  }
}