import 'package:dandylight/models/Contract.dart';
import 'package:dandylight/pages/contracts_page/ContractsPageState.dart';

class FetchContractsAction{
  final ContractsPageState pageState;
  FetchContractsAction(this.pageState);
}

class SetContractsAction{
  final ContractsPageState pageState;
  final List<Contract> contracts;
  SetContractsAction(this.pageState, this.contracts);
}

