

import 'package:dio/dio.dart';
import 'package:pub_dev_crawler/services/remote/pub_api.dart';
import 'package:pub_dev_crawler/services/remote/pub_api_app.dart';
import 'package:pub_dev_crawler/services/remote/pub_client_interface.dart';

class Services {
  static PubClientInterface? _pubClient;

  static PubClientInterface get pubClient {
    if (_pubClient == null) {
      Dio dio = Dio();
      dio.interceptors.add(MyInterceptor());
      dio.interceptors.add(LogInterceptor(responseBody: false,));
      _pubClient = PubClientApp(dio);
    }
    return _pubClient!;
  }

}

class MyInterceptor extends Interceptor {

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    response.headers.add('Access-Control-Allow-Origin','*');
    handler.next(response);
  }
}