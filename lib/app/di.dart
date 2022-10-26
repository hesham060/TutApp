import 'package:dio/dio.dart';
import 'package:firstproject/app/shared_prefs.dart';
import 'package:firstproject/data/data_source/remote_data_source.dart';
import 'package:firstproject/data/network/app_api.dart';
import 'package:firstproject/data/network/dio_factory.dart';
import 'package:firstproject/data/network/network_info.dart';
import 'package:firstproject/data/repository/repository_impl.dart';
import 'package:firstproject/domain/repository/repository.dart';
import 'package:firstproject/domain/usecase/login_use_case.dart';
import 'package:firstproject/presentation/login_view/viewmodel/login_view_model.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt instance = GetIt.instance;

Future<void> initAppModule() async {
// app module , its amodule which we put all generic instance of project

  final sharedprefs = await SharedPreferences.getInstance();

  // lazy to save memory
  instance.registerLazySingleton<SharedPreferences>((() => sharedprefs));
  // app prefs instance
  instance
      .registerLazySingleton<AppPrefreneces>(() => AppPrefreneces(instance()));
  // app network info
  instance.registerLazySingleton<NetwokInfo>(
      () => NetworkingInfoImpl(InternetConnectionChecker()));
  // Dio factory
  instance.registerLazySingleton<DioFactory>(() => DioFactory(instance()));
  // App service client
  Dio dio = await instance<DioFactory>().getDio();

  instance
      .registerLazySingleton<AppServiceClients>(() => AppServiceClients(dio));

  // remote data source
  instance.registerLazySingleton<RemoteDataSource>(
      () => RemoreDataSourceImpl(instance()));

  // repository

  instance.registerLazySingleton<Repository>(
      () => RepositoryImpl(instance(), instance()));
      // login object 
}

loginAppModule() {
  if (!GetIt.I.isRegistered()) {
// login use case
    instance.registerFactory<LoginUseCase>(() => LoginUseCase(instance()));
    instance.registerFactory<LoginViewModel>(() => LoginViewModel(instance()));
  }
}
