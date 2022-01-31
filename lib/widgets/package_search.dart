import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pub_dev_crawler/states/package_search_state.dart';
import 'package:pub_dev_crawler/widgets/package_search_bar.dart';

class PackageSearchWidget extends ConsumerWidget {
  const PackageSearchWidget({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/hero-bg-static.png"),
          fit: BoxFit.cover,
        ),
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700, minWidth: 100),
                  child: PackageSearchBar(onSubmit: (keyword) {
                    StatePackageSearch.read(ref).submitSearch(keyword);
                  },)),
            ),
          ),
        ],
      ),
    );
  }
}