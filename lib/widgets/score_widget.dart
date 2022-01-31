


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pub_dev_crawler/theme/app_text_style.dart';

class ScoreWidget extends StatelessWidget {
  final String top;
  final String bot;
  final bool percent;

  const ScoreWidget({Key? key, required this.top, required this.bot, this.percent = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var style = AppTextStyle(context);
    return Column(children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(top, style: style.score,),
          if (percent) Text('%', style: style.percent,),
        ],
      ),
      const SizedBox(height: 6,),
      Text(bot, style: const TextStyle(fontSize: 10, color: Color(0xFF757575)),),
    ],);
  }

}