import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pub_dev_crawler/theme/app_text_style.dart';

class PackageSearchBar extends StatelessWidget {
  final void Function(String keyword) onSubmit;

  const PackageSearchBar({Key? key, required this.onSubmit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(200),
        color: const Color(0xFF35404d),
      ),
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          const SizedBox(
            width: 20,
          ),
          const Icon(
            Icons.search,
            color: Colors.grey,
            size: 20,
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
              child: TextField(
            style: AppTextStyle(context).searchBarText,
            cursorColor: Colors.grey[400],
            onSubmitted: (value) {
              print("onSubmitted");
              onSubmit.call(value);
            },
            decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: 'Search packages',
                hintStyle: AppTextStyle(context)
                    .searchBarText
                    .copyWith(color: Colors.grey)),
          )),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }
}
