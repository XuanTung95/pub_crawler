import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:html/dom.dart' as h;
import 'package:flutter/material.dart';
import 'package:pub_dev_crawler/model/package_page.dart';
import 'package:pub_dev_crawler/pages/packages_page.dart';
import 'package:pub_dev_crawler/services/remote/pub_api.dart';
import 'package:pub_dev_crawler/widgets/list_item/home_list_item.dart';
import 'package:html/parser.dart' show parse;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: GetMaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String html = "";

  @override
  Widget build(BuildContext context) {
    return PagePackages();
  }
}