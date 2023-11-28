import 'package:flutter_dotenv/flutter_dotenv.dart';

class UrlAPI {
  final baseUrl = dotenv.get("baseUrl");
  final sccIdentity = dotenv.get("sccIdentity");
  final sccSubscription = dotenv.get('sccSubscription');
  final sccMasterMain = dotenv.get('sccMasterMain');
  final sccMasterProduct = dotenv.get('sccMasterProduct');
  final sccMonitor = dotenv.get('sccMonitor');
  final sccUserMgmt = dotenv.get('sccUserMgmt');
  final sccDashboard = dotenv.get('sccDashboard');
  final sccItem = dotenv.get('sccItem');
  final sccItemValidation = dotenv.get('sccItemValidation');
  final sccItemConsume = dotenv.get('sccItemConsume');
}
