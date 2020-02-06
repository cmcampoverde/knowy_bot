import 'package:get_it/get_it.dart';

import 'Connection/LoginSrv.dart';
import 'Connection/network_utils.dart';

GetIt locator = GetIt.asNewInstance();

Future setupLocator() async {

  // login
  NetworkUtils netUtils = NetworkUtils();
  locator.registerLazySingleton<LoginSrv>( () => LoginSrv(netUtils));

}
