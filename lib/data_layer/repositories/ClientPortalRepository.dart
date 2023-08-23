import 'package:dandylight/models/Job.dart';

import '../../models/Profile.dart';
import '../api_clients/DandylightFunctionsClient.dart';
import 'package:meta/meta.dart';

class ClientPortalRepository {
  final DandylightFunctionsApi functions;

  ClientPortalRepository({@required this.functions}) : assert(functions != null);

  Future<Job> fetchJob(String userId, String jobId) async {
    return await functions.fetchJob(userId, jobId);
  }

  Future<Profile> fetchProfile(String userId, String jobId) async {
    return await functions.fetchProfile(userId, jobId);
  }

  Future<int> saveClientSignature(String userId, String jobId, String clientSignature) async {
    return await functions.saveClientSignature(userId, jobId, clientSignature);
  }
}