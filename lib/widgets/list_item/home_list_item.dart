


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeListItem extends StatelessWidget {
  final String text;
  final VoidCallback callback;

  const HomeListItem({Key? key, required this.text, required this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        child: Text(text, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),),
      ),
    );
  }

}