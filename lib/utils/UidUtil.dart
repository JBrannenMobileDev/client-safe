
class UidUtil {
  static final UidUtil _uidUtil = UidUtil._internal();
  String _uid = '';

  factory UidUtil() {
    return _uidUtil;
  }

  void setUid(String uid){
    this._uid = uid;
  }

  String getUid(){
    return _uid;
  }

  UidUtil._internal();
}