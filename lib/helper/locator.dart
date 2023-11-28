
import 'package:get_it/get_it.dart';
import 'package:scc_web/helper/app_route.gr.dart';

GetIt locator = GetIt.asNewInstance();

void setupLocator() {
  locator.registerSingleton<AppRouter>(AppRouter());
}
