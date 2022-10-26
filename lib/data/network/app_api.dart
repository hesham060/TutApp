
import 'package:dio/dio.dart';
import 'package:firstproject/data/response/responses.dart';
import 'package:retrofit/http.dart';

import '../../app/constants.dart';

part 'app_api.g.dart';

@RestApi(baseUrl: Constants.baseUrl)
abstract class AppServiceClients {
  factory AppServiceClients(Dio dio, {String baseUrl}) = _AppServiceClients;

  @POST("/customers/login")
  Future<AuthenticationResponse> login(
      @Field("email") String email, @Field("password") String password);
}