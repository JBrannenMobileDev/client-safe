import 'package:client_safe/models/Client.dart';
import 'package:client_safe/models/Job.dart';
import 'package:client_safe/pages/client_details_page/ClientDetailsPageState.dart';

class InitializeClientDetailsAction{
  final ClientDetailsPageState pageState;
  final Client client;
  InitializeClientDetailsAction(this.pageState, this.client);
}

class DeleteClientAction{
  final ClientDetailsPageState pageState;
  DeleteClientAction(this.pageState);
}

class InstagramSelectedAction{
  final ClientDetailsPageState pageState;
  InstagramSelectedAction(this.pageState);
}

class SetClientJobsAction{
  final ClientDetailsPageState pageState;
  final List<Job> clientJobs;
  SetClientJobsAction(this.pageState, this.clientJobs);
}


