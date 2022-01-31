

import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

abstract class PubClientInterface {
  PubClientInterface(Dio dio, {String baseUrl = ""});

  Future<String> getPackagesPage(
      {String type = "packages", String keywords = "", String sort = "created", int page = 1});

  Future<String> getPackagesDetail(String name,);
}