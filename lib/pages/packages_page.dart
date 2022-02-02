

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:pub_dev_crawler/states/package_search_state.dart';
import 'package:pub_dev_crawler/widgets/list_item/package_list_item_widget.dart';
import 'package:pub_dev_crawler/widgets/package_search.dart';
import 'package:pub_dev_crawler/widgets/packages_page_header.dart';
import 'package:pub_dev_crawler/widgets/sort_by_row_widget.dart';
import 'package:sliver_tools/sliver_tools.dart';

class PagePackages extends ConsumerStatefulWidget {
  const PagePackages({Key? key}) : super(key: key);

  @override
  ConsumerState<PagePackages> createState() => _PackagesPageState();
}

class _PackagesPageState extends ConsumerState<PagePackages> {
  final logger = Logger();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      var state = StatePackageSearch.read(ref);
      state.submitSearch('');
    });
  }

  @override
  Widget build(BuildContext context) {
    var state = StatePackageSearch.watch(ref);
    return Scaffold(
      body: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
        },),
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: PackagesPageHeader(),),
            const SliverToBoxAdapter(child: PackageSearchWidget(),),
            SliverPinnedHeader(child: ColoredBox(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: SortByRowWidget(),
              ),
            ),),
            SliverList(delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  var package = state.sortedPackages[index];
                  return Container(
                    color: index % 2 == 0 ? Colors.transparent : Colors.grey[200],
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: PackageListItem(package: package,),
                  );
                },
              childCount: state.sortedPackages.length,
            ),),
          ],
        ),
      ),
    );
  }
}