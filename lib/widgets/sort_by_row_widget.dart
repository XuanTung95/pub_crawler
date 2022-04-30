

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pub_dev_crawler/states/package_search_state.dart';
import 'package:pub_dev_crawler/theme/app_text_style.dart';
import 'package:pub_dev_crawler/utils/constant.dart';

class SortByRowWidget extends ConsumerStatefulWidget {
  const SortByRowWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<SortByRowWidget> createState() => _SortByRowWidgetState();
}

class _SortByRowWidgetState extends ConsumerState<SortByRowWidget> {
  final GlobalKey<PopupMenuButtonState> popupKey = GlobalKey<PopupMenuButtonState>();

  @override
  Widget build(BuildContext context) {
    var state = StatePackageSearch.watch(ref);
    var textStyle = AppTextStyle(context);
    return Column(
      children: [
        Row(children: [
          Text('SORT:', style: textStyle.darkBoldText,),
          ...state.selectedClientSort.map((e) => Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(7),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(e.name, style: textStyle.packageNormalText,),
                InkWell(
                    onTap: () {
                      e.isDesc = !e.isDesc;
                      state.notifySort();
                    },
                    child: Icon(e.isDesc ? Icons.arrow_downward : Icons.arrow_upward, size: 22,)),
              ],
            ),
          )).toList(),
          PopupMenuButton<ClientSort>(
            enableFeedback: true,
            offset: const Offset(0, 30),
            onSelected: (ClientSort value) {
              state.setClientSort(value);
            },
            child: const Icon(Icons.add_circle, color: Colors.blue,),
            itemBuilder: (BuildContext context) => state.allClientSort.map((e) => PopupMenuItem<ClientSort>(
              value: e,
              child: Row(
                children: [
                  Text(e.name.toLowerCase()),
                ],
              ),
            )).toList(),
          ),
          InkWell(
              onTap: () {
                state.clearClientSort();
              },
              child: const Icon(Icons.clear, color: Colors.blue,))
        ],),
        const SizedBox(height: 5,),
        Row(children: [
          Text('LOADING:', style: textStyle.darkBoldText,),
          Text(' ${state.loadingCount}/${state.totalLoading} ', style: textStyle.countText,),
          ElevatedButton(onPressed: () {
            state.paused = !state.paused;
            state.lastLoadedCount = 0;
            state.notifyListeners();
          }, child: Text(state.paused ? 'Continue' : 'Pause')),
          SizedBox(width: 10,),
          Container(
            color: Colors.grey[300],
            child: TextButton(onPressed: () {
              showDialog(context: context, builder: (context) {
                final textController = TextEditingController();
                textController.text = state.currPage.toString();
                return AlertDialog(
                  title: Text('Set current page and close dialog'),
                  actions: <Widget>[
                    TextField(controller: textController, onChanged: (value) {
                      try {
                        int _page = int.parse(value);
                        state.currPage = _page;
                      } catch (e) {

                      }
                    },),
                  ],
                );
              });
            },
            child: Text(' PAGE: ${state.currPage}', style: textStyle.darkBoldText,)),
          ),
          SizedBox(width: 10,),
          ElevatedButton(onPressed: () async {
            await Hive.box('packages').clear();
            await Hive.box('meta').clear();
          }, child: Text('Clear Database')),
        ],),
        Row(children: [
          Text('RESULTS', style: textStyle.darkBoldText,),
          Container(
              color: Colors.grey[200],
              margin: const EdgeInsets.only(left: 3, right: 3, top: 5),
              padding: const EdgeInsets.only(top: 6, bottom: 6),
              child: Text(' ${state.sortedPackages.length}/${state.totalPackages} ', style: textStyle.countText,)),
          Text(' packages for search query ', style: textStyle.packageNormalText,),
          Container(
              color: Colors.grey[200],
              margin: const EdgeInsets.only(left: 3, right: 3, top: 5),
              padding: const EdgeInsets.only(top: 6, bottom: 6),
              child: Text(' ${state.keyword} ', style: textStyle.countText,)),
          const Spacer(),
          PopupMenuButton<PackageSort>(
            key: popupKey,
            enableFeedback: true,
            offset: const Offset(0, 30),
            onSelected: (PackageSort value) {
              state.setSortType(value);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
              child: Row(children: [Text('SORT BY', style: textStyle.darkBoldText,),
                Text(' ${state.serverSort.name}', style: textStyle.sortType,),
              ],),
            ),
            itemBuilder: (BuildContext context) => Constant.allSorts.map((e) => PopupMenuItem<PackageSort>(
              value: e,
              child: Text(e.name.toLowerCase()),
            )).toList(),
          )
        ],),
      ],
    );
  }
}
