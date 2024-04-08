import 'Code.dart';

class DiscountCodes {
  static const String FIFTY_PERCENT_TYPE = "50Percent";
  static const String LIFETIME_FREE = "lifetimeFree";
  static const String FIRST_3_MONTHS_FREE = "First3MonthsFree";
  static const String A_LITTLE_STORY_30 = "ALittleStory30";

  List<Code>? codes;
  String? type;

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
      codes: convertMapsToCodes(map['codes']),
      type: map['type'],
    );
  }

  List<Map<String, dynamic>> convertCodesToMap(List<Code>? codes){
    List<Map<String, dynamic>> listOfMaps = [];
    for(Code code in codes != null ? codes : []){
      listOfMaps.add(code.toMap());
    }
    return listOfMaps;
  }

  static List<Code> convertMapsToCodes(List? listOfMaps){
    List<Code> listOfCodes = [];
    for(Map map in listOfMaps != null ? listOfMaps : []){
      listOfCodes.add(Code.fromMap(map as Map<String, dynamic>));
    }
    return listOfCodes;
  }
}