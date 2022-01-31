import 'package:json_annotation/json_annotation.dart';
import 'package:pub_dev_crawler/services/remote/pub_client_interface.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'pub_api_app.g.dart';

@RestApi(baseUrl: "https://pub.dev")
abstract class PubClientApp implements PubClientInterface {
  factory PubClientApp(Dio dio, {String baseUrl}) = _PubClientApp;

  @GET("/{type}?q={q}&sort={sort}&page={page}")
  Future<String> getPackagesPage(
      {@Path("type") String type = "packages", @Path("q") String keywords = "", @Path("sort") String sort = "created", @Path("page") int page = 1});

  @GET("/packages/{name}")
  Future<String> getPackagesDetail(@Path("name") String name,);

}