import 'package:json_annotation/json_annotation.dart';
import 'package:pub_dev_crawler/services/remote/pub_client_interface.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'pub_api.g.dart';

@RestApi(baseUrl: "https://api.allorigins.win")
abstract class PubClient implements PubClientInterface {
  factory PubClient(Dio dio, {String baseUrl}) = _PubClient;

  @GET("/raw?url=https%3A%2F%2Fpub.dev%2F{type}%3Fq%3D{q}%26sort%3D{sort}%26page%3D{page}")
  Future<String> getPackagesPage(
      {@Path("type") String type = "packages", @Path("q") String keywords = "", @Path("sort") String sort = "created", @Path("page") int page = 1});

  @GET("/raw?url=https%3A%2F%2Fpub.dev%2Fpackages%2F{name}")
  Future<String> getPackagesDetail(@Path("name") String name,);

}