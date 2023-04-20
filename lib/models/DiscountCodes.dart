
import 'Code.dart';

class DiscountCodes {

  List<Code> codes;
  String type;

  DiscountCodes({
    this.codes,
    this.type
  });

  Map<String, dynamic> toMap() {
    return {
      'codes' : convertCodesToMap(codes),
      'type' : type,
    };
  }

  static DiscountCodes fromMap(Map<String, dynamic> map) {
    return DiscountCodes(
      codes: convertMapsToCodes(map['poses']),
      type: map['type'],
    );
  }

  List<Map<String, dynamic>> convertCodesToMap(List<Code> codes){
    List<Map<String, dynamic>> listOfMaps = [];
    for(Code code in codes != null ? codes : []){
      listOfMaps.add(code.toMap());
    }
    return listOfMaps;
  }

  static List<Code> convertMapsToCodes(List listOfMaps){
    List<Code> listOfCodes = [];
    for(Map map in listOfMaps != null ? listOfMaps : []){
      listOfCodes.add(Code.fromMap(map));
    }
    return listOfCodes;
  }
}