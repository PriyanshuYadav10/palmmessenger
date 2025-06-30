import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/constants/app_constants.dart';
import 'features/data/data-source/remote/dio_client.dart';
import 'features/data/data-source/remote/logging_interceptor.dart';
import 'features/data/repository/auth_repo.dart';
import 'features/data/repository/home_repo.dart';
import 'features/helper/network_info.dart';
import 'features/provider/authProvider.dart';
import 'features/provider/homeProvider.dart';


final sl = GetIt.instance;

Future<void> init() async {
  // Core

  sl.registerLazySingleton(() => checkInternetConnection(sl()));
  sl.registerLazySingleton(() => DioClient(AppConstants.baseURL,sl(), loggingInterceptor: sl(),
      sharedPreferences: sl()));

  //User Repository
  sl.registerLazySingleton(() => HomeRepo(dioClient: sl()));

  //User Provider
  sl.registerFactory(() => HomeProvider(homeRepo: sl()));
  // // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => LoggingInterceptor());
  sl.registerLazySingleton(() => Connectivity());

  sl.registerLazySingleton(() => AuthRepo(dioClient: sl(),));
  sl.registerFactory(() => AuthProvider(authRepo: sl()));
}
