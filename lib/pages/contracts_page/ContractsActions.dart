
import '../../models/Contract.dart';
import 'ContractsPageState.dart';

class FetchContractsAction{
  final ContractsPageState pageState;
  FetchContractsAction(this.pageState);
}

class SetContractsAction{
  final ContractsPageState pageState;
  final List<Contract> contracts;
  SetContractsAction(this.pageState, this.contracts);
}

