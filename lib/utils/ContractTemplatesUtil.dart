import '../models/Contract.dart';

class ContractTemplatesUtil {

  static Contract getGeneralContract() {
    return Contract(
      contractName: "General Contract",
      terms: "This is the general contract...",
      jsonTerms: "This is the general contract..."
    );
  }
  static Contract getWeddingContract() {
    return Contract(
        contractName: "Wedding Contract",
        terms: "This is the general contract...",
        jsonTerms: "This is the general contract..."
    );
  }
  static Contract getPortraitContract() {
    return Contract(
        contractName: "Portrait Contract",
        terms: "This is the general contract...",
        jsonTerms: "This is the general contract..."
    );
  }
}